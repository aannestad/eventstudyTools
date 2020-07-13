function eventwindowplot(plottype,catnr,signalpha)

if signalpha == 0.05
   signlimit = 2;
   showlevel = '95';
elseif signalpha == 0.01
    signlimit = 3;
    showlevel = '99';
elseif signalpha == 0.001;
    signlimit = 4;
    showlevel = '99.9';
end

load eventstudyoutput
load category20
%eventstudyoutput mleevents mleeventscilo mleeventsciup mleeventsstatsign mleabsevents mleabseventscilo mleabseventsciup mleabseventsstatsign ...
%          mleposevents mleposeventscilo mleposeventsciup mleposeventsstatsign mleabsposevents mleabsposeventscilo mleabsposeventsciup mleabsposeventsstatsign ...
%          mlenegevents mlenegeventscilo mlenegeventsciup mlenegeventsstatsign mleabsnegevents mleabsnegeventscilo mleabsnegeventsciup mleabsnegeventsstatsign ...
%          alleventwindows
 %m = size(1,muevents);
 %basevariance(m,1) = highpciestmuabsabnret; 
 categorydisp = [categorydisp;'ALL EVENTS'];
  disp(categorydisp(catnr))
if strcmp(plottype,'uncond')
           
  mueventscilo(mueventsstatsign<signlimit) = NaN;
  mueventsciup(mueventsstatsign<signlimit) = NaN;  
  muabseventscilo(muabseventsstatsign<signlimit) = NaN;
  muabseventsciup(muabseventsstatsign<signlimit) = NaN;
  
  muevts = [muevents(catnr,:);mueventsciup(catnr,:);mueventscilo(catnr,:)]'.*100;               %#ok<NODEF>
  muabsevts = [muabsevents(catnr,:);muabseventsciup(catnr,:);muabseventscilo(catnr,:);muabsabnret']'.*1;         %#ok<NODEF>
  
elseif strcmp(plottype,'pos')
    
  muposeventscilo(muposeventsstatsign<signlimit) = NaN;
  muposeventsciup(muposeventsstatsign<signlimit) = NaN;  
  muabsposeventscilo(muabsposeventsstatsign<signlimit) = NaN;
  muabsposeventsciup(muabsposeventsstatsign<signlimit) = NaN;
  
  muevts = [muposevents(catnr,:);muposeventsciup(catnr,:);muposeventscilo(catnr,:)]'.*100;               %#ok<NODEF>
  muabsevts = [muabsposevents(catnr,:);muabsposeventsciup(catnr,:);muabsposeventscilo(catnr,:);muabsposabnret']'.*1;         %#ok<NODEF> 

elseif strcmp(plottype,'neg')
    
  munegeventscilo(munegeventsstatsign<signlimit) = NaN;
  munegeventsciup(munegeventsstatsign<signlimit) = NaN;  
  muabsnegeventscilo(muabsnegeventsstatsign<signlimit) = NaN;
  muabsnegeventsciup(muabsnegeventsstatsign<signlimit) = NaN;
  
  muevts = [munegevents(catnr,:);munegeventsciup(catnr,:);munegeventscilo(catnr,:)]'.*100;               %#ok<NODEF>
  muabsevts = [muabsnegevents(catnr,:);muabsnegeventsciup(catnr,:);muabsnegeventscilo(catnr,:);muabsnegabnret']'.*1;  %#ok<NODEF>
end    

% Create figure
figure1 = figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1]);

% Create axes
axes1 = axes('Parent',figure1,...
    'XTickLabel',{'-5','-4','-3','-2','-1','0','1','2','3','4','5'},...
    'XTick',[1 2 3 4 5 6 7 8 9 10 11],...
    'XGrid','off',...
    'Position',[0.0634747145187602 0.1 0.4 0.55],...
    'FontSize',25);
% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[1 12]);
hold(axes1,'all');

% Create xlabel
xlabel('Days from event','FontSize',25);

% Create ylabel
ylabel('Abnormal return (%)','FontSize',25);

% Create multiple lines using matrix input to stem
stem1 = stem(muevts,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0],...
    'Parent',axes1,...
    'LineStyle','none');
set(stem1(1),'MarkerSize',30,'Marker','.','LineWidth',2,...
    'DisplayName','Mean',...
    'Color',[0 0 0],...
    'LineStyle','-');
set(stem1(2),'Marker','v','MarkerSize',12,'MarkerFaceColor',[0 2/3 0],'MarkerEdgeColor',[0 2/3 0],'Color',[1 0 0],'DisplayName',['CI (Upper ' showlevel '%)']);
set(stem1(3),'Marker','^','MarkerSize',12,'MarkerFaceColor',[0 2/3 0],'MarkerEdgeColor',[0 2/3 0],'Color',[1 0 0],'DisplayName',['CI (Lower ' showlevel '%)']);


% Create legend
legend(axes1,'show'); legend('boxoff'); %,'Location','Best');
title('Abnormal return','FontSize',30);

% Create axes
axes2 = axes('Parent',figure1,...
    'XTickLabel',{'-5','-4','-3','-2','-1','0','1','2','3','4','5'},...
    'XTick',[1 2 3 4 5 6 7 8 9 10 11],...
    'XGrid','off',...
    'Position',[0.578548123980425 0.1 0.4 0.55],...
    'FontSize',25);
% Uncomment the following line to preserve the X-limits of the axes
xlim(axes2,[1 12]);
hold(axes2,'all');

% Create xlabel
xlabel('Days from event','FontSize',25);

% Create ylabel
ylabel('Abnormal absolute return','FontSize',25);

% Create multiple lines using matrix input to plot
plot2 = plot(muabsevts,'Parent',axes2,'MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor',[0 0 0]);
set(plot2(1),'MarkerSize',30,'Marker','.','LineWidth',2,...
    'DisplayName','Mean abs.',...
    'Color',[0 0 0]);
set(plot2(2),'Marker','v','MarkerSize',12,'MarkerFaceColor',[0 2/3 0],'MarkerEdgeColor',[0 2/3 0],'LineStyle','none',...
    'Color',[1 0 0],...
    'DisplayName',['CI (Upper ' showlevel '%)']);
set(plot2(3),'Marker','^','MarkerSize',12,'MarkerFaceColor',[0 2/3 0],'MarkerEdgeColor',[0 2/3 0],'LineStyle','none',...
    'Color',[1 0 0],...
    'DisplayName',['CI (Lower ' showlevel '%)']);
set(plot2(4),'DisplayName','Uncond. abs.','Color',[0 0 0],...
    'MarkerFaceColor','none',...
    'MarkerEdgeColor','auto');
% Create legend
legend(axes2,'show'); legend('boxoff'); %,'Location','Best');
title('Abnormal volatility','FontSize',30);


