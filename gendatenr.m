function gendatenr(tickerlist,categorylist)
closetime = 1/24*(17+30/60);
k = length(tickerlist);
cm = length(categorylist);
                                                 % Loop through instruments
for j = 1:k
  eval(['load(''',tickerlist{j,1},''')'])
  for c = 1:cm                                              % Category loop 
       nc = eval(['size(',categorylist{c,2},',1)']);
       eval([categorylist{c,2},'=','[',categorylist{c,2},',cell(nc,1)];']); 
       
       for ic = 1:nc                                           % Event loop           
         eventdate = datenum(eval([categorylist{c,2},'(ic,1)']),'dd.mm.yyyy HH:MM:SS');       
         if eventdate-floor(eventdate) > closetime                         % If event is after close: add it next day
            eventdate = floor(eventdate) + 1;                              %#ok<NASGU>
         else
            eventdate = floor(eventdate);                                  %#ok<NASGU>
         end 
       eval([categorylist{c,2},'{',num2str(ic),',3}=eventdate;']);                   % Add the datenr to the news-variable
       end
  eval(['save(''',tickerlist{j,1},''',''',categorylist{c,2},''',''-append'')']);    
  end  
  disp([tickerlist{j,1},' Updated'])
end
