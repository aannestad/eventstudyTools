function eventstudytable = eventstudystats(ewlength)

% Example: eventstudytable = eventstudystats(1) or (3) or (5)

load eventstudyoutput alleventwindows muevents mueventsstatsign muabsevents muabseventsstatsign aggrabnret aggrevents
load category20
categorydisp = [categorydisp;{'ALL'}];
 %Ncar / car pr category, pr avg abnret: each category's importance as a
 % driver of abnormal return (on avg pr day, and total, with frequency)
 
 % Category, no. of obs.,
 
 if size(muevents,2) == 11
    if ewlength == 1
       ewin = 6;
    elseif ewlength == 3
       ewin = 5:7;
    elseif ewlength == 5
       ewin = 4:8;
    end
 end
 
 [freqtable,aggrnewsfreq,newsprticker] = getfreqoverview;
 cm = size(aggrnewsfreq,1);
 aggrnewsfreq = cell2mat(aggrnewsfreq(:,4));
 aggrnewsfreq = [aggrnewsfreq;sum(aggrnewsfreq)];
 
 totabscar = sum(abs(aggrabnret));
 totabsncar = sum(abs(aggrabnret(aggrevents~=0)));
 
 totposcar = sum(aggrabnret(aggrabnret>0));
 totnegcar = sum(aggrabnret(aggrabnret<0));
 
 totposfraq = length(aggrabnret(aggrabnret>0))/length(aggrabnret);
 
 pdfallncarcar = zeros(cm+1,11);
 pdfallposncarcar = zeros(cm+1,11);
 pdfallnegncarcar = zeros(cm+1,11); 
 
 pdfcatncarcar = zeros(cm+1,11);
 pdfcatposncarcar = zeros(cm+1,11);
 pdfcatnegncarcar = zeros(cm+1,11);
 
 eventretcat = cell(cm+1,1);
 posfraq = zeros(cm+1,11);
 posfraqdisp = cell(cm+1,11);
 posfraqstatsign = zeros(cm+1,11);
 posfraqstatsigndisp = cell(cm+1,11);
 
 ncarcar = zeros(21,1);

 for idj = 1:21       % Category loop
   for idk = 1:11         % Event day loop -10 ... 0 ... 10 
                                                      % 1: Absolute returns
    pdfallncarcar(idj,idk) = sum(abs(alleventwindows{idj,1}(idk,:)))/totabsncar;     % Total fraq of abn.ret.
    
    pdfcatncarcar(idj,idk) = sum(abs(alleventwindows{idj,1}(idk,:)))/sum(sum(abs(alleventwindows{idj,1}))); % Category dep. fraq
     
                                                      % 2: Positive returns
    currentret=alleventwindows{idj,1}(idk,:);
    
    eventret=alleventwindows{idj,1}(idk,:);     % Event-window interval: Mode 1 = 5:7 or mode 2: 6
    %eventret = sum(eventret,1);
    %eventretcat{idj} = eventret;
    
    posfraqstatsign(idj,idk) = 1 - binocdf(length(eventret(eventret>0)),length(eventret),totposfraq);
    posfraq(idj,idk) = length(eventret(eventret>0))/length(eventret);
    
    currentret=sum(currentret(currentret>0));
    totcatret=alleventwindows{idj,1};   
    postotcatret=sum(totcatret(totcatret>0));                               
    
    pdfallposncarcar(idj,idk) = currentret/totposcar;                      % Total fraq of pos abn.ret.
    pdfcatposncarcar(idj,idk) = currentret/postotcatret;                   % Category dep. fraq of neg abn ret
    
                                                      % 3: Negative returns                                                    
    currentret=alleventwindows{idj,1}(idk,:);
    currentret=sum(currentret(currentret<0));
    negtotcatret=sum(totcatret(totcatret<0));
    
    pdfallnegncarcar(idj,idk) = currentret/totnegcar;                      % Total fraq of neg abn.ret.
    pdfcatnegncarcar(idj,idk) = currentret/negtotcatret;                   % Category dep. fraq of neg abn ret                                                  
                                                                           
   end
   
   ncarcar(idj,1) = sum(pdfallncarcar(idj,ewin));                         % Event at day 6, Tot abn CAR (-1,0,1) pr. category 
   %posfraqdisp(idj,1) = length(current
 end
% ------------------ Event abn ret of abn ret -----------------------
maggr = size(aggrabnret,1);
aggrcarevents = zeros(maggr,1);
for i = 2:maggr-1
  if aggrevents(i) ~= 0
     aggrcarevents(i) = 1;                                           % i-1:i+1    (extend from i to more to get CAR (cumulative) in window)
  end
end  
ncarcar(idj,1) = sum(abs(aggrabnret(aggrcarevents~=0))) / totabsncar;

ncarcardisp = cell(cm+1,1);                  % Convert to cell and % (disp)
for i = 1:idj
  ncarcardisp{i,1} = [num2str(round(str2double(num2str(ncarcar(i,1)*100))*100)/100),'%'];
end

eventcaroftotcar = sum(abs(aggrabnret(aggrcarevents~=0))) / totabscar;
poseventcaroftotcar = sum(aggrabnret(aggrcarevents~=0 & aggrabnret > 0)) / totposcar;
negeventcaroftotcar = sum(aggrabnret(aggrcarevents~=0 & aggrabnret < 0)) / totnegcar;

fraqevents = length(aggrevents(aggrevents~=0)) / maggr;
% -------------------------------------------------------------------------
                                                     % CDFs of cumsum(PDFs)
cdfallncarcar = cumsum(pdfallncarcar,2);      
cdfallposncarcar = cumsum(pdfallposncarcar,2);
cdfallnegncarcar = cumsum(pdfallnegncarcar,2);
 
cdfcatncarcar = cumsum(pdfallncarcar,2);
cdfposcatncarcar = cumsum(pdfcatposncarcar,2);
cdfnegcatncarcar = cumsum(pdfcatnegncarcar,2);

% ------------------------- Stat. sign. conversion ------------------------
mueventsdisp = cell(idj,idk);
mueventstatsigndisp = cell(idj,idk);
muabseventsdisp = cell(idj,idk);
muabseventstatsigndisp = cell(idj,idk);
catnrdisp = cell(idj,1);
                                                    
for isc = 1:idk
  for isr = 1:idj                                    % Mu event stat. sign.
     mueventsdisp{isr,isc} = [num2str(round(str2double(num2str(muevents(isr,isc)*100))*100)/100),'%'];
     if mueventsstatsign(isr,isc) > 2 
       mueventstatsigndisp{isr,isc} = '***';       % Add % and ***
     elseif mueventsstatsign(isr,isc) == 2   
       mueventstatsigndisp{isr,isc} = '**'; 
     elseif mueventsstatsign(isr,isc) == 1
       mueventstatsigndisp{isr,isc} = '*';       
     else
       %mueventstatsigndisp(isr,isc) = '';  
     end 
     
     if mueventsstatsign(isr,isc) > 2 
       muabseventstatsigndisp{isr,isc} = '***';       % Add % and ***
     elseif mueventsstatsign(isr,isc) == 2   
       muabseventstatsigndisp{isr,isc} = '**'; 
     elseif mueventsstatsign(isr,isc) == 1
       muabseventstatsigndisp{isr,isc} = '*';       
     else
       %mueventstatsigndisp(isr,isc) = '';  
     end          
                                               % Pos. fraq. event stat. sign.
     posfraqdisp{isr,isc} = [num2str(round(str2double(num2str(posfraq(isr,isc)*100))*10)/10),'%'];
     if posfraqstatsign(isr,isc) <= 0.01 || posfraqstatsign(isr,isc) > 0.99
       posfraqstatsigndisp{isr,isc} = '***';       % Add % and ***
     elseif posfraqstatsign(isr,isc) <= 0.05 || posfraqstatsign(isr,isc) > 0.95   
       posfraqstatsigndisp{isr,isc} = '**'; 
     elseif posfraqstatsign(isr,isc) <= 0.1 || posfraqstatsign(isr,isc) > 0.9
       posfraqstatsigndisp{isr,isc} = '*';       
     else
       %mueventstatsigndisp(isr,isc) = '';  
     end             
     catnrdisp{isr} = num2str(isr);    
  end
end 

% -------------------------------------------------------------------------

heading = {'Nr','Category','Nr. of obs.','Mean return','Sign','Fraq. Pos.','Sign','Volatility','Sign','% of event CAR',};
eventstudytable = [heading;catnrdisp,categorydisp,num2cell(aggrnewsfreq), ...
                   mueventsdisp(:,6),mueventstatsigndisp(:,6),posfraqdisp(:,6),posfraqstatsigndisp(:,6), ...
                   num2cell(muabsevents(:,6)),muabseventstatsigndisp(:,6),ncarcardisp];
end
  
 function [freqtable,aggrnewsfreq,newsprticker] = getfreqoverview

load maintickers
load category20
categorylist = category;
k = length(tickerlist);
cm = length(categorylist);
freqtable = zeros(k,cm);
                                                 % Loop through instruments
for j = 1:k
  eval(['load(''',tickerlist{j,1},''')'])
  
  for c = 1:cm                                           % Category loop
   if exist(categorylist{c,4},'var')
    eval(['currentdummy=',categorylist{c,4},';']);     
    freqtable(j,c) = length(nonzeros(currentdummy));
    eval(['clear ',categorylist{c,4},' ' categorylist{c,2},';']);           % Clears the current dummy for next stock process
   end
  end          
  
  %eval(['save(''',tickerlist{j,1},''',''movbeta'',''xret'',''datenr'',''abnret'',''-append'')'])
  %disp([tickerlist{j,1},' Updated'])  
end

aggrnewsfreq = [categorylist(:,1:2),categorylist(:,4),num2cell(sum(freqtable,1)')];
newsprticker = [tickerlist,num2cell(sum(freqtable,2))];

end