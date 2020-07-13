function timeplot(data,datenr)

%function mainfig(dates,open,close,trades,timeind, kursind, vol, volind, ret, cumret)

% Create figure
figure1 = figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1]);
axes1 = axes('Parent',figure1,'FontSize',20);
%xlim(axes1,[732806 735773]);
%ylim(axes1,[0 26]);
% Create xlabel
%xlabel('Time','FontSize',25);

% Create ylabel
ylabel('Data','FontSize',20);


%---------------------- Vindu 1: Data series -----------------------------

box('off');
grid('on');
hold('all');

plot1 = plot(datenr,data,'Parent',axes1,'MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor',[0 0 0]);
set(plot1(1),'MarkerSize',20,'Marker','none','LineWidth',2,...
    'Color',[0 0 0]);
%legendohlc = legend(axes1,'show');
%set(legendohlc,'FontSize',8);

datetick('x',1,'keeplimits')

%--------------------- Linked axis og autozoom ----------------------------
zh=zoom;
ph=pan;
set(zh,'ActionPostCallback', @adaptiveDateTicks);
set(ph,'ActionPostCallback', @adaptiveDateTicks);
set(zh,'Enable','on')
set(ph,'Enable','on')

linkaxes(axes1,'x');

hlink = linkprop(axes1,'XTick');
key = 'graphics_linkprop';
%  % Store link object on first subplot axes
setappdata(axes1,key,hlink)

hlink = getappdata(axes1,'graphics_linkprop');
addprop(hlink,'xlim') 
 
plotbrowser('off')

function adaptiveDateTicks(eventObjectHandle,figg)
% Resetting x axis to automatic tick mark generation 
set(figg.Axes,'XTickMode','auto')
% using automaticallly generate date ticks
datetick(figg.Axes,'x','keeplimits')



