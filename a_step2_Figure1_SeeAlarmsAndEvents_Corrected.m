clear all; clc; format compact

figure(1); clf; 

% goal: colums [days]
% gray1, green, yellow, g2 
load TIMEDATA sahdataFIGURE2
T = sahdataFIGURE2; 

%% fill in green state
tob = datenum(T.tob); 
dci = datenum(T.dci)-tob; 
dci(isnan(dci))=23; 
firstAlarm = datenum(T.firstAlarm)-tob;; 
greenTime = min(firstAlarm,dci); 
yellowTime = zeros(size(firstAlarm)); 
yellowTime = dci-firstAlarm; yellowTime(isnan(firstAlarm))=0; 
gy = [greenTime yellowTime]';
redTime = 23*ones(size(tob))-sum(gy)';
y = [greenTime yellowTime redTime];

%% get beginning and ending of eeg monitoring
t0 = datenum(T.eegStart)-tob; ind = find(t0<0); t0(ind)=0.3;
ind = find(t0>3.5); 
t0(ind) = 2.5; 
t1 = datenum(T.eegEnd) - tob; 

m=[0 0.5 0; 1 .6 0; 1 0 0];
bar_h=barh(y,'stacked');
shading faceted
colormap(m); 
for i = 1:3
    bar_h(i).FaceAlpha = 0.6; 
%     bar_h(i).EdgeColor = 'none';
    bar_h(i).BarWidth = .95;
end

set(gca,'xgrid','on')
set(gca,'ytick',[1 5:5:100 ])
set(gcf,'color','w');
set(gca,'tickdir','out')
box off

xlabel('Days after SAH','fontsize',14);
ylabel('Patient #','fontsize',12);
axis tight
xlim([0 20]);
set(gca,'fontsize',12); 
ylim([.2 103.8])

for i = 1:length(t0); 
   x = [t0(i) t1(i) t1(i) t0(i) t0(i)]; 
   y = [(i-.5) (i-.5) (i+.5) (i+.5) (i-.5)]; 
%    hold on; plot(x,y,'k','linewidth',1); 
%    hold on; plot(x,y,'k'); %,'markersize',7); 
   x = t1(i); y = i; 
   hold on; plot(x,y,'k.','markersize',7); 
   x = t0(i); y = i; 
   hold on; plot(x,y,'w.','markersize',7); 
end
%%
% set(gcf,'PaperPositionMode','auto')
% print -dpng -r600 Fig_TimeToEventPlot