function [monthfreq, catmonthfreq, catmonthfreqdisp] = seasonalevents

load maintickers
load category20


k = length(tickerlist);
monthfreq = zeros(12,1);

categorylist = category;
cm = length(categorylist);
catmonthfreq = zeros(cm,12);
                                 % Loop through instruments
for j = 1:k
  eval(['load(''',tickerlist{j,1},''')'])
 
  nzevents = nonzeros(eventdummy);
  nzeventdates = datenr(eventdummy~=0);
  [~, monthdate, ~, ~, ~, ~] = datevec(nzeventdates);
  
  for i = 1:12 
    monthfreq(i) = monthfreq(i) + sum(nzevents(monthdate==i));
  end
    
  for c = 1:cm                                           % Category loop
   if exist(categorylist{c,4},'var')
    eval(['currentdummy=',categorylist{c,4},';']);    

     catnzevents = nonzeros(currentdummy);
     catnzeventdates = datenr(currentdummy~=0);
    [~, catmonthdate, ~, ~, ~, ~] = datevec(catnzeventdates);
   
    for i = 1:12 
     catmonthfreq(c,i) = catmonthfreq(c,i) + sum(catnzevents(catmonthdate==i));
    end
  
   end
   eval(['clear ',categorylist{c,4},' ' categorylist{c,2},';']);  
  end          
          
end

monthheading = {'EVENT CATEGORY / Month','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
catmonthfreqdisp = [monthheading;[categorydisp,num2cell(catmonthfreq)]];

end
