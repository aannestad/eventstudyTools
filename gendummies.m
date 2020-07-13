function gendummies

load maintickers
load category20
categorylist = category;

k = length(tickerlist);
cm = length(categorylist);
                                                 % Loop through instruments
for j = 1:k
  eval(['load(''',tickerlist{j,1},''')'])
  m = length(datenr);
  
  for c = 1:cm                                                             % Category-loop    
    currentdummy = zeros(m,1);                                             % Generate currentdummy
    eval(['currentevents=',categorylist{c,2},';']);  
    nc = size(currentevents,1);                                            %#ok<*USENS>
    if nc>0                                                                % Only run if there are news entries in category
      for i = 1:m                                                          % Time-loop       
       for ic = 1:nc                                                       % Events(in category)-loop                    
         if datenr(i) == currentevents{ic,3}                               %  if news on the current day
            currentdummy(i) = 1;                        
         end
       end
      end
    eval([categorylist{c,4},'=currentdummy;']);                             % Generate dummy with shortname of category
    eval(['save(''',tickerlist{j,1},''',''',categorylist{c,4},''',''-append'')'])
    end   
  end
  disp([tickerlist{j,1},' Updated'])
end