function plotseason(monthfreq1)
%CREATEFIGURE(MONTHFREQ1)

%meany(length(monthfreq)) = mean(monthfreq)';

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,...
'XTickLabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'},...
    'XTick',[1 2 3 4 5 6 7 8 9 10 11 12],...
    'XGrid','off','FontSize',25,'yGrid','On');
% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[1 12]);
box(axes1,'off');
hold(axes1,'all');
ylabel('Frequency','FontSize',30);
% Create bar 
bar(monthfreq1,'FaceColor',[0 0 0],'DisplayName','monthfreq(1:12,1)');

