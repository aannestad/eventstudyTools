function [dsrcstatstable,abnretarchtest] = discrstats

load maintickers

k = length(tickerlist);

nobs = zeros(k,1);
means = zeros(k,1);
alphas = zeros(k,1);
alphasstatsign = cell(k,1);
betas = zeros(k,1);
stds = zeros(k,1);
skews = zeros(k,1);
kurts = zeros(k,1);
jbstats = zeros(k,1);
jbstatsign = cell(k,1);
archs = zeros(k,1);
archstatsign = cell(k,1);
abnarchs = zeros(k,1);
abnarchstatsign = cell(k,1);

corrs = zeros(k,1);
                                                 % Loop through instruments
for j = 1:k
  eval(['load(''',tickerlist{j,1},''')'])

  nobs(j) = length(xret);
  means(j) = mean(xret);     % [num2str(round(str2double(num2str(ncarcar(i,1)*100))*100)/100),'%'];
  
  stats = regstats(xret,idxret,'linear');  %regress(xret,[ones(nobs,1) idxret]);
  
  alphas(j) = stats.beta(1)*100;
  betas(j) = stats.beta(2);
  
  if stats.tstat.pval(1) <= 0.01
    alphasstatsign{j} = '***';       % Add ***
  elseif stats.tstat.pval(1) <= 0.05  
    alphasstatsign{j} = '**'; 
  elseif stats.tstat.pval(1) <= 0.1 
    alphasstatsign{j} = '*';       
  end 
 
  stds(j) = std(xret);
  skews(j) = skewness(xret);
  kurts(j) = kurtosis(xret);
  
  [h,p,jbstats(j)] = jbtest(xret);
  if p <= 0.01
    jbstatsign{j} = '***';       % Add ***
  elseif p <= 0.05  
    jbstatsign{j} = '**'; 
  elseif p <= 0.1 
    jbstatsign{j} = '*';       
  end  
                                 % ARCH-test on returns (check diagnostics)
  [h,p,archs(j),CritVal] = archtest(xret-mean(xret));
  if p <= 0.01
    archstatsign{j} = '***';       % Add % and ***
  elseif p <= 0.05  
    archstatsign{j} = '**'; 
  elseif p <= 0.1 
    archstatsign{j} = '*';       
  end  
                             % ARCH-test of final model (check diagnistics)
   
  spec = garchset('Display','off','P',1,'Q',1,'TolCon',1e-6);              % Set specification to GARCH model
  [~,~,~,~,condstd] = garchfit(spec,abnret);                % Estimate GARCH model and cond. std.
  xcv = condstd./mean(condstd);  
  abnret = abnret./xcv;                         
                                                       
  [h,p,abnarchs(j),CritVal] = archtest(abnret-mean(abnret));
  if p <= 0.01
    abnarchstatsign{j} = '***';       % Add % and ***
  elseif p <= 0.05  
    abnarchstatsign{j} = '**'; 
  elseif p <= 0.1 
    abnarchstatsign{j} = '*';       
  end  
  
  corrs(j) = corr(xret,idxret); 
end
heading = {'Ticker','N','mean','Std. Dev.','alpha','stat','beta','Skew','Kurt','JB Stat.','Sign','ARCH','Stat','Corr'};
dsrcstatstable = [heading;[tickerlist,[num2cell([nobs,means,stds,alphas]),alphasstatsign,num2cell([betas,skews,kurts,jbstats]),jbstatsign,num2cell(archs),archstatsign,num2cell(corrs)]]];

abnretarchtest = [num2cell(abnarchs),abnarchstatsign];

