function [muevents,mueventscilo,mueventsciup,mueventsstatsign,muabsevents,muabseventscilo,muabseventsciup,muabseventsstatsign,...
          muposevents,muposeventscilo,muposeventsciup,muposeventsstatsign,muabsposevents,muabsposeventscilo,muabsposeventsciup,muabsposeventsstatsign,...
          munegevents,munegeventscilo,munegeventsciup,munegeventsstatsign,muabsnegevents,muabsnegeventscilo,muabsnegeventsciup,muabsnegeventsstatsign,...
          alleventwindows] = eventstudy

% Eks: 
% > [evts,evtslo,evtsup,evtssign,absevts,absevtslo,absevtsup,absevtssign,posevts,posevtslo,posevtsup,posevtssign,absposevts,absposevtslo,absposevtsup,absposevtssign,negevts,negevtslo,negevtsup,negevtssign,absnegevts,absnegevtslo,absnegevtsup,absnegevtssign,alleventwindows] = eventstudy;

load maintickers
load category20
categorylist = category;
k = length(tickerlist);
cm = length(categorylist);

alleventwindows = cell(cm+1,1);
allcateventwindows = [];
aggrabnret = [];
aggret = [];

                      % Loop through instruments and cumulate event windows
for j = 1:k
  eval(['load(''',tickerlist{j,1},''')'])

  for c = 1:cm                                              % Category loop                       
    alleventwindows{c,1} = [alleventwindows{c,1},eventwindows{c,1}]; 
    allcateventwindows = [allcateventwindows,eventwindows{c,1}];           %#ok<AGROW>
  end          
   
  aggrabnret = [aggrabnret;abnret];                                        %#ok<AGROW> % Aggregate abn ret for all stocks
  aggret = [aggret;xret];
 % disp([tickerlist{j,1},' Updated'])
end

alleventwindows{cm+1,1} = allcateventwindows;                      % Average all categories and place at bottom of alleventwindows
maggr = length(aggrabnret);
                                  
%[b,stats] = robustfit(ones(maggr,1),aggrabnret);                                              % 1: mu of abnormal return                              
estmuabnret = mean(aggrabnret); %b(1); %+ stats.se(1)*1.96;                                      

b = robustfit(ones(maggr,1),abs(aggrabnret));                                         % 2: mu of abnormal absolute return "variance" 
estmuabsabnret = b(1); %+ stats.se(1)*1.96;
                                                                           
b = robustfit(ones(length(aggrabnret(aggrabnret>0)),1),aggrabnret(aggrabnret>0));     % 3: mu of abnormal return if positive event      
estmuposabnret = b(1); %+ stats.se(1)*1.96;
                                                                           
b = robustfit(ones(length(aggrabnret(aggrabnret<0)),1),aggrabnret(aggrabnret<0));     % 4: mu of abnormal return if negative event     
estmunegabnret = b(1); %+ stats.se(1)*1.96;

muevents = zeros(cm+1,21);   % 1 mu
mueventscilo = zeros(cm+1,21);
mueventsciup = zeros(cm+1,21);
mueventsstatsign = zeros(cm+1,21);

muabsevents = zeros(cm+1,21);   % 2 abs(mu) "variance"
muabseventscilo = zeros(cm+1,21);
muabseventsciup = zeros(cm+1,21);
muabseventsstatsign = zeros(cm+1,21);

muposevents = zeros(cm+1,21);    % 3 mu Positive event-day
muposeventscilo = zeros(cm+1,21);
muposeventsciup = zeros(cm+1,21);
muposeventsstatsign = zeros(cm+1,21);

muabsposevents = zeros(cm+1,21);    % 4 mu abs(Positive event-day) "variance"
muabsposeventscilo = zeros(cm+1,21); 
muabsposeventsciup = zeros(cm+1,21); 
muabsposeventsstatsign = zeros(cm+1,21);

munegevents = zeros(cm+1,21);    % 5 mu Negative event-day
munegeventscilo = zeros(cm+1,21);
munegeventsciup = zeros(cm+1,21);
munegeventsstatsign = zeros(cm+1,21);

muabsnegevents = zeros(cm+1,21);    % 6 mu abs(Negative event-day) "variance"
muabsnegeventscilo = zeros(cm+1,21); 
muabsnegeventsciup = zeros(cm+1,21); 
muabsnegeventsstatsign = zeros(cm+1,21);

% ------------ Category event window estimates (pooled tickers) -----------
warning('off','all')
for j = 1:cm+1                    % Category loop (on Event days windows (company averages))
 
  curreventcat = alleventwindows{j,1};
  [mdays,mevents] = size(curreventcat);
 
 % 1 - Expected est. and conf. int. for stat sign of event window : are some news on average good or bad?
  for eventday = 1:mdays
     
     [b,stats] = robustfit(ones(1,mevents),curreventcat(eventday,:));
  
     muevents(j,eventday) = b(1);
     mueventscilo(j,eventday) = b(1) - stats.se(1)*1.96;
     mueventsciup(j,eventday) = b(1) + stats.se(1)*1.96;
     nevents = length(curreventcat(eventday,:));
     
     if stats.p(1) < 0.01   
       mueventsstatsign(j,eventday) = 3;  
     elseif stats.p(1) < 0.05
       mueventsstatsign(j,eventday) = 2;
     elseif stats.p(1) < 0.1
       mueventsstatsign(j,eventday) = 1;  
     end
  end

 % 2 - Abs value ("variance") - Expected est. and conf. int. for stat. sign. of event window
     % Which news categories cause most variance (are most "important" short term
  for eventday = 1:mdays
      
     [b,stats] = robustfit(ones(1,mevents),abs(curreventcat(eventday,:)));
  
     muabsevents(j,eventday) = b(1);
     muabseventscilo(j,eventday) = b(1) - stats.se(1)*1.96;
     muabseventsciup(j,eventday) = b(1) + stats.se(1)*1.96;
      
     if stats.p(1) < 0.1
       muabseventsstatsign(j,eventday) = 1;  
     elseif stats.p(1) < 0.05
       muabseventsstatsign(j,eventday) = 2;
     elseif stats.p(1) < 0.01   
       muabseventsstatsign(j,eventday) = 3;
     end                
  end
  
 % ---------- Event window reactions (mu & CI) of good & bad news (from reactions on day of news release
                                            % MODE 1: estmuabnret (measures pos/neg against avg.abn.ret, MODE 2: 0 (measure against zero)
                                                            % Change the limit to see if difference
                                                                                                                                                                                  
  poscurreventcat = curreventcat(:,curreventcat(11,:)>estmuposabnret);  % Event windows where event-days are more positive than average positive day
  negcurreventcat = curreventcat(:,curreventcat(11,:)<estmunegabnret);   % Event windows where event-days are more negative than average negative day
  
 % 3 - Positive reactions - Expected est and conf. int. for stat. sign. of event window  
 for eventday = 1:mdays     
     [b,stats] = robustfit(ones(1,size(poscurreventcat,2)),poscurreventcat(eventday,:));
  
     muposevents(j,eventday) = b(1);
     muposeventscilo(j,eventday) = b(1) - stats.se(1)*1.96;
     muposeventsciup(j,eventday) = b(1) + stats.se(1)*1.96;
      
     if stats.p(1) < 0.01   
       muposeventsstatsign(j,eventday) = 3;  
     elseif stats.p(1) < 0.05
       muposeventsstatsign(j,eventday) = 2;
     elseif stats.p(1) < 0.1
       muposeventsstatsign(j,eventday) = 1;  
     end        
 end
 
% 4 - Absolute values ("variance") of event windows of positive event-days
 for eventday = 1:mdays       
     [b,stats] = robustfit(ones(1,size(poscurreventcat,2)),abs(poscurreventcat(eventday,:)));
  
     muabsposevents(j,eventday) = b(1);
     muabsposeventscilo(j,eventday) = b(1) - stats.se(1)*1.96;
     muabsposeventsciup(j,eventday) = b(1) + stats.se(1)*1.96;
      
     if stats.p(1) < 0.01   
       muabsposeventsstatsign(j,eventday) = 3;  
     elseif stats.p(1) < 0.05
       muabsposeventsstatsign(j,eventday) = 2;
     elseif stats.p(1) < 0.1
       muabsposeventsstatsign(j,eventday) = 1;  
     end     
 end
 
  % 5 - Negative reactions - Expected est and conf. int. for stat. sign. of event window
  for eventday = 1:mdays    
     [b,stats] = robustfit(ones(1,size(negcurreventcat,2)),negcurreventcat(eventday,:));
  
     munegevents(j,eventday) = b(1);
     munegeventscilo(j,eventday) = b(1) - stats.se(1)*1.96;
     munegeventsciup(j,eventday) = b(1) + stats.se(1)*1.96;
      
     if stats.p(1) < 0.01   
       munegeventsstatsign(j,eventday) = 3;  
     elseif stats.p(1) < 0.05
       munegeventsstatsign(j,eventday) = 2;
     elseif stats.p(1) < 0.1
       munegeventsstatsign(j,eventday) = 1;  
     end      
  end
  
    % 6 - Absolute values ("variance") of event windows of negative event-days
    
  for eventday = 1:mdays
     [b,stats] = robustfit(ones(1,size(negcurreventcat,2)),abs(negcurreventcat(eventday,:)));
  
     muabsnegevents(j,eventday) = b(1);
     muabsnegeventscilo(j,eventday) = b(1) - stats.se(1)*1.96;
     muabsnegeventsciup(j,eventday) = b(1) + stats.se(1)*1.96;
      
     if stats.p(1) < 0.01   
       muabsnegeventsstatsign(j,eventday) = 3;  
     elseif stats.p(1) < 0.05
       muabsnegeventsstatsign(j,eventday) = 2;
     elseif stats.p(1) < 0.1
       muabsnegeventsstatsign(j,eventday) = 1;  
     end        
  end
    
  disp(cm+1-j)
end
 warning('on','all') 
 
 muabsabnret(1:21,1) = estmuabsabnret;
 muabsposabnret(1:21,1) = estmuposabnret;
 muabsnegabnret(1:21,1) = abs(estmunegabnret);
 
 save eventstudyoutput muevents mueventscilo mueventsciup mueventsstatsign muabsevents muabseventscilo muabseventsciup muabseventsstatsign ...
          muposevents muposeventscilo muposeventsciup muposeventsstatsign muabsposevents muabsposeventscilo muabsposeventsciup muabsposeventsstatsign ...
          munegevents munegeventscilo munegeventsciup munegeventsstatsign muabsnegevents muabsnegeventscilo muabsnegeventsciup muabsnegeventsstatsign ...
          alleventwindows muabsabnret  muabsposabnret muabsnegabnret;
% ----------------------------- Sum and means -----------------------------
 
 % -------------------------------- Plots ---------------------------------
 
 