function [allparams,allparamssign] = gencar(timestart,timeend)

load allxoptim3 %maintickers

allparams = zeros(35,3);
allse = zeros(35,3);
allparamssign = cell(35,3);
flimits = icdf('normal',[0.9 0.95 0.99],0,1);

timestart = datenum(timestart);
timeend = datenum(timeend);

totreplacements = 0;
totdatapoints = 0;

% Example: [allparams,allparamssign] = gencar('01-Jan-2004','01-Jul-2014'); OLD:  gencar('01-Jul-2004','01-Jul-2014');

k = length(tickerlist); %#ok<USENS>

% --------------------------- Import index --------------------------------

idxraw = importdata('OSEBX.csv');
idxclose = idxraw.data;
idxdate = idxraw.textdata(:,1);
mraw = length(idxdate);
dd = zeros(mraw,1);
mm = zeros(mraw,1);
year = zeros(mraw,1);

for i = 1:mraw
   dd(i) = str2double(idxdate{i,1}(1,1:2));
   mm(i) = str2double(idxdate{i,1}(1,4:5));
   year(i) = str2double(idxdate{i,1}(1,7:10));   
end
  idxdatenr = datenum(year,mm,dd);
  idxclose = idxclose(idxdatenr>=timestart & idxdatenr<= timeend);
  idxdatenr = idxdatenr(idxdatenr>=timestart & idxdatenr<= timeend);
  midx = length(idxclose);
  
% ------------------------------------------------------------------------- 
  
% Loop through instruments

for j = 1:k
  eval(['xraw=importdata(''',tickerlist{j,1},'.csv'');'])
 
%xraw = importdata('OSEBX.csv');
xclose = xraw.data;
xdate = xraw.textdata(:,1);
mraw = length(xdate);
dd = zeros(mraw,1);
mm = zeros(mraw,1);
year = zeros(mraw,1);
  
% Import stock:
for i = 1:mraw
   dd(i) = str2double(xdate{i,1}(1,1:2));
   mm(i) = str2double(xdate{i,1}(1,4:5));
   year(i) = str2double(xdate{i,1}(1,7:10));   
end
  xdatenr = datenum(year,mm,dd);
  xclose = xclose(xdatenr>=idxdatenr(1,1) & xdatenr<= idxdatenr(end,1));
  xdatenr = xdatenr(xdatenr>=idxdatenr(1,1) & xdatenr<= idxdatenr(end,1));    
  mx = length(xdatenr);
% ------------------- Sync time of stock to index -------------------------
  syncxdata = zeros(mx,1);
  syncdatenr = zeros(mx,1);
  syncidxdata = zeros(midx,1);
  ik = 1;
  
  for ix = 1:mx
    for iidx = 1:midx
       if xdatenr(ix,1) == idxdatenr(iidx,1) && ~isnan(xclose(ix,1)) && ~isnan(idxclose(iidx,1))      % Sync if equal date AND price in stock & idx
          syncxdata(ik,1) = xclose(ix,1);
          syncidxdata(ik,1) = idxclose(iidx,1);
          syncdatenr(ik,1) = xdatenr(ix,1);
          ik = ik + 1;
       end
    end
  end
  
  syncxdata = syncxdata(1:ik-1,:);
  syncidxclose = syncidxdata(1:ik-1,:);
  datenr = syncdatenr(1:ik-1,:);
  idxret = [0;diff(log(syncidxclose(:,1)))];
  
  % ----------------------------- GARCH: index ----------------------------
  spec = garchset('Display','off','P',1,'Q',1,'TolCon',1e-6);              % Set specification to GARCH model
  [EstSpec,EstSE,logL,e,condstd,summary] = garchfit(spec,idxret);                % Estimate GARCH model and cond. std.
  idxcv = condstd./mean(condstd);  
  %------------------------------------------------------------------------
 
  xclose = syncxdata(:,1);
  xret = [0;diff(log(xclose))];
  trimxret = xret;
  xm = length(xclose);
  totdatapoints = totdatapoints + xm;
  % ------------------ Winsor outliers for robustness --------------------  To avoid spurious results
  i = 1;                                                                                                     
  peakint = 500;                                                           % Time intervals (e.g. 250 days) of most extreme
  while i+peakint-1 < xm
    xretint = xret(i:i+peakint-1);                                           % Excess return limits
           
    filtupperlim = +std(xretint)*6;
    filtlowerlim = -std(xretint)*6;
        
    totreplacements = totreplacements + length(nonzeros(xretint<filtlowerlim | xretint>filtupperlim));
  
    xretint(xretint>filtupperlim) = filtupperlim;                          % Trim: Replace data in interval with limits
    xretint(xretint<filtlowerlim) = filtlowerlim;
    xret(i:i+peakint-1) = xretint;                                           % Fill inn trimmed values in org data
    i = i + peakint;
  end                                              % Calculate last period:

  xretint = xret(i:end); 
      
  filtupperlim = +std(xretint)*6;
  filtlowerlim = -std(xretint)*6;
  
  xretint(xretint>filtupperlim) = filtupperlim;                            % Trim: Replace data in interval with limits
  xretint(xretint<filtlowerlim) = filtlowerlim;
  xret(i:end) = xretint;                                                   % Fill inn trimmed values in org data

% ---------- Winsor high values for "normal" returns beta calc ------------
  i = 1;   
  pctlim = 0.025;           % <- (5+5) 10% largest abs(xret) cutoff for "normal returns"
  while i+peakint-1 < xm
    xretint = xret(i:i+peakint-1);
    sortxretint = sort(xretint,'descend');   % ERROR? SORT ABSOLUTE? LOWER QUANTILE WILL NOT BE EXTREME VALUES BUT VALUES CLOSE TO ZERO. REVISE AND REDO!!!        
    
    filtupperlim = sortxretint(round(peakint*pctlim),1); 
    filtlowerlim = sortxretint(end-round(peakint*pctlim),1);           
    xretint(xretint>filtupperlim) = filtupperlim;       % Trim: Replace data in interval with index returns
    xretint(xretint<filtlowerlim) = filtlowerlim;
    trimxret(i:i+peakint-1) = xretint;                                           % Fill inn trimmed values in org data
    i = i + peakint;
  end                                              % Calculate last period:
  xretint = xret(i:end);
  sortxretint = sort(xretint,'descend');           
  filtupperlim = sortxretint(ceil(length(xretint)*pctlim),1); 
  filtlowerlim = sortxretint(end-ceil(length(xretint)*pctlim),1); 
  xretint(xretint>filtupperlim) = filtupperlim;                            % Trim: Replace data in interval with limits
  xretint(xretint<filtlowerlim) = filtlowerlim;
  trimxret(i:end) = xretint;                                                   % Fill inn trimmed values in org data  
      
 % ----------------------------- GARCH: Stock -----------------------------
  spec = garchset('Display','on','P',1,'Q',1,'TolCon',1e-6);              % Set specification to GARCH model
  [EstSpec,EstSE,logL,e,condstd,summary] = garchfit(spec,trimxret);                % Estimate GARCH model and cond. std.
  xcv = condstd./mean(condstd);  

 % --------------------------- Observed Beta ------------------------------

  movbeta = genmovbeta(trimxret./xcv,idxret./idxcv); 
  R = std(movbeta);
  
 % ------------------------------ KALMAN Filtering ------------------------ 
 
 [x_kf,~,~] = fastkf(movbeta,1,1,allx(j,3),R);
 
  if any(~isfinite(x_kf))   % Replace inf in KF beta by prev.val.
    for i=1:m
       if ~isfinite(x_kf(i))
          x_kf(i) = x_kf(i-1); repinf = repinf + 1;
       end
    end
  end

  kfbeta = [1;x_kf(1:end-1)];              % One-step-ahead prediction (beta)
  xcv = [1;xcv(1:end-1)];
  idxcv = [1;idxcv(1:end-1)];
  
 % --------------------- Calculate abnormal return -------------------------
  abnret = xret./xcv - (idxret./idxcv).*kfbeta;                            
                                                                         % De-mean abnormal returns: we want deviations
  abnret = abnret - robustfit(ones(xm,1),abnret,[],[],'off');           %#ok<NASGU> % CAPM 
  
  %eval(['save(''',tickerlist{j,1},''',''movbeta'',''kfbeta'',''xret'',''idxret'',''xclose'',''datenr'',''abnret'',''-append'')'])
  disp([tickerlist{j,1},' Updated'])
  
  %--------------------- Calculate GARCH parameter significance -----------
  
  allparams(j,1) = EstSpec.K;
  allparams(j,2) = EstSpec.GARCH;
  allparams(j,3) = EstSpec.ARCH;
  allse(j,1) = EstSE.K;
  allse(j,2) = EstSE.GARCH;
  allse(j,3) = EstSE.ARCH;
  
  for jj = 1:size(allparams,2)
    if allparams(j,jj)/allse(j,jj) > flimits(3)
      allparamssign{j,jj} = '***';       % Add ***
    elseif allparams(j,jj)/allse(j,jj) > flimits(2) 
      allparamssign{j} = '**'; 
    elseif allparams(j,jj)/allse(j,jj) > flimits(1)
      allparamssign{j} = '*';       
    end 
  end
end
 disp('Tot. replacements')
 disp(totreplacements)
 disp('Tot. Data points')
 disp(totdatapoints)
 
end

function movbeta = genmovbeta(xret,idxret)

 m = length(xret);
                                                           
 movbeta = xret./idxret;                                  % Raw Moving beta
 
 % ------------------- 1 - Index close to zero (division) correction --------
 idxzeroind = idxret>-(std(idxret)/sqrt(m))*1.96 & idxret<(std(idxret)/sqrt(m))*1.96;   % Fix div by zero problem
 movbeta(idxzeroind) = 0;                   % Beta is zero where index is close to zero                        
 
 % ------------------- 2 - Stock AND index close to zero (division) correction --------
 
 xzeroind = xret>-(std(xret)/sqrt(m))*1.96 & xret<(std(xret)/sqrt(m))*1.96;   % 
 
 movbeta(xzeroind & idxzeroind) = 1;    % 2 - Beta is one where stock AND index is close to zero                                   
 
 % --------------- 3 - High stock AND low index correction ----------------
 pctlim = 0.1; 
 
 sortidx = sort(abs(idxret)); 
 idxretlim = sortidx(ceil(length(sortidx)*pctlim),1); 
 idxlow = abs(idxret)<idxretlim;
 
 sortx = sort(abs(xret)); 
 xretlim = sortx(end-ceil(length(sortx)*pctlim),1); 
 xhigh = abs(xret)>xretlim;
 
 movbeta(xhigh & idxlow) = 0;               % 3 - Beta is zero where stock is high (abs) and index low (abs)
 
 movbeta(movbeta>50) = 50;                   % Ceil extreme values at +-50
 movbeta(movbeta<-50) = -50;
end

function [x,K,P] = fastkf(z,A,H,Q,R)

% Process: x(t) = A*x(t-1) + w(t-1) , where p(w) ~N(0,Q)
% Measure: z(t) = H*x(t) + v(t) , where p(v) ~N(0,R)

%If RW: A = 1;  %H = 1;

[n,~] = size(z);

x = zeros(n,1); % State estimate
P = zeros(n,1); % Error covariance
K = zeros(n,1);  % Kalman gain vector => Weighting of measurements vs. state

% 0 - Initialization

x(1) = 1; %inv(H)*z(1);                               % 0.1 - Initial state prediction
P(1) = 1; %inv(H)*R*inv(H');                          % 0.2 - Initial error covariance prediction

for t=2:n
% -------------------------- Kalman filter --------------------------------   
   % 1 - Prediction
   
   x(t) = A*x(t-1);                               % 1.1 - State prediction
   P(t) = A*P(t-1) * A' + Q;                      % 1.2 - Error covariance prediction
 
   % 2 - Update
  
   K(t) = P(t)*H'* 1/(H*P(t)*H'+R);               % 2.1 - Kalman gain factor
               
   x(t) = x(t) + K(t)*(z(t)-H*x(t));              % 2.2 - Updated state estimate 
   P(t) = P(t) - K(t)*H*P(t);                     % 2.3 - Updated error covariance
% -------------------------------------------------------------------------    
end
%disp(P(t))
x(1:500) = 1;
end








