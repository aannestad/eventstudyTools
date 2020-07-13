function stockeventwindows

load maintickers
load category20
%load allabnretstd

categorylist = category;
k = length(tickerlist);
cm = length(categorylist);
freqtable = zeros(k,cm);

% ------------------- Calculate relative standard deviations -------------
allabnretstd = zeros(k,1);
for j = 1:k
  eval(['load(''',tickerlist{j,1},''',''abnret'')'])
  allabnretstd(j) = std(abnret);
end  
 relabnretstd = allabnretstd./mean(allabnretstd);
 
% -------------------- Fill in event window returns------------------------
                                                 % Loop through instruments
for j = 1:k
  eval(['load(''',tickerlist{j,1},''')'])
  m = length(datenr);
  eventwindows = cell(cm,1);
  for c = 1:cm                                              % Category loop   
   if exist(categorylist{c,4},'var')  
    eval(['eventdummy=',categorylist{c,4},';']);   
    eventidx = find(eventdummy);
    em = length(eventidx);
    eventwindow = zeros(11,em);

    ei = 1;                                                      % Event window counter
    for i = 6:m-6
      if eventdummy(i,1) ~= 0
        eventwindow(:,ei) = abnret(i-5:i+5)./relabnretstd(j);             % Risk neutral measure: divide by relative standard deviations.
        ei = ei + 1;
      end
    end
   else eventwindow = [];     
   end
   eventwindows{c,1} = eventwindow;   
   eval(['clear ',categorylist{c,4},' ' categorylist{c,2},';']);           % Clears the current dummy for next stock process
  end          
 
  eval(['save(''',tickerlist{j,1},''',''eventwindows'',''-append'')'])
  disp([tickerlist{j,1},' Updated'])
end