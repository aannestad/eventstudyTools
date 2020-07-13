function [freqtable,freqtabledisp,aggrnewsfreq,newsprticker] = freqoverview

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
   end
   
   eval(['clear ',categorylist{c,4},' ' categorylist{c,2},';']);           % Clears the current dummy for next stock process
  end          
 
  %eval(['save(''',tickerlist{j,1},''',''movbeta'',''xret'',''datenr'',''abnret'',''-append'')'])
  %disp([tickerlist{j,1},' Updated'])
   
   
end

aggrnewsfreq = [categorylist(:,1:2),categorylist(:,4),num2cell(sum(freqtable,1)')];
newsprticker = [tickerlist,num2cell(sum(freqtable,2))];


catmeans = num2cell([sum(freqtable,1)';sum(sum(freqtable,1))]);
tickermeans = num2cell(sum(freqtable,2)');

freqtabledisp = [['CATEGORY';'Sum';tickerlist]';[[categorydisp;'Sum'],catmeans,[num2cell(freqtable');tickermeans]]];