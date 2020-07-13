function [dsrcstatstable,abnretarchtest] = olskfjbtest

load maintickers

k = length(tickerlist);

nobs = zeros(k,1);
                                     % OLS variables 
olsmeans = zeros(k,1);
olsalphas = zeros(k,1);
olsalphasstatsign = cell(k,1);
olsbetas = zeros(k,1);
olsstds = zeros(k,1);
olsskews = zeros(k,1);
olskurts = zeros(k,1);
olsjbstats = zeros(k,1);
olsjbstatsign = cell(k,1);
olsarchs = zeros(k,1);
olsarchstatsign = cell(k,1);
olscorr = zeros(k,1);
                                    % KF variables 
kfmeans = zeros(k,1);
kfsalphas = zeros(k,1);
kfalphasstatsign = cell(k,1);
kfbetas = zeros(k,1);
kfstds = zeros(k,1);
kfskews = zeros(k,1);
kfkurts = zeros(k,1);
kfjbstats = zeros(k,1);
kfjbstatsign = cell(k,1);
kfarchs = zeros(k,1);
kfarchstatsign = cell(k,1);
kfcorr = zeros(k,1);
                                                 % Loop through instruments
for j = 1:k
  eval(['load(''',tickerlist{j,1},''')'])

  nobs(j) = length(xret);
  means(j) = mean(xret);     % [num2str(round(str2double(num2str(ncarcar(i,1)*100))*100)/100),'%'];
  
  stats = regstats(xret,idxret,'linear');  %regress(xret,[ones(nobs,1) idxret]);
  
  % -------------------------- OLS evaluation -----------------------------
  
  [h,p,olsjbstats(j)] = jbtest(stats.r);           % JB test of normality for OLS resid
  if p <= 0.01
    jbolsstatsign{j} = '***';       % Add ***
  elseif p <= 0.05  
    jbolsstatsign{j} = '**'; 
  elseif p <= 0.1 
    jbolsstatsign{j} = '*';       
  end  
  
  olsalphas(j) = stats.beta(1)*100;
  olsbetas(j) = stats.beta(2);
  
  if stats.tstat.pval(1) <= 0.01
    alphasstatsign{j} = '***';       % Add ***
  elseif stats.tstat.pval(1) <= 0.05  
    alphasstatsign{j} = '**'; 
  elseif stats.tstat.pval(1) <= 0.1 
    alphasstatsign{j} = '*';       
  end 
  
  olsstds(j) = std(stats.r);
  olsskews(j) = skewness(stats.r);
  olskurts(j) = kurtosis(stats.r);
  
   % -------------------------- KF abret evaluation -----------------------
  
  [h,p,jbstats(j)] = jbtest(abnret);
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
  
end
heading = {'Ticker','N','mean','Std. Dev.','alpha','stat','beta','Skew','Kurt','JB Stat.','Sign','ARCH','Stat','Corr'};
dsrcstatstable = [heading;[tickerlist,[num2cell([nobs,means,stds,alphas]),alphasstatsign,num2cell([betas,skews,kurts,jbstats]),jbstatsign,num2cell(archs),archstatsign,num2cell(corrs)]]];

abnretarchtest = [num2cell(abnarchs),abnarchstatsign];

