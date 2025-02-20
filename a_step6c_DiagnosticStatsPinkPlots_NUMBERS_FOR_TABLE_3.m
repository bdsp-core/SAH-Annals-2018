clear all; clc; format compact; 

%% calculate boostrapped credible intervals
%C:\Users\mw110\Dropbox (SAH MONITORING)\Papers_InProgress\EEG_SAH_OutcomePredictionUsingEEGReports\R_stuff
load OVERALLSTATS % stats1 stats4 statsA -- from fcnGetOverallStats -- may be the best program for plotting (needs adapting)
m1 = stats1; 
m4 = stats4; 
ma = statsA; 

load BOOTSTRAP_RESULTS2

% add to this BOOTSTRAP_RESULTS2 when done
stats4 = abs(stats4); 
stats1 = abs(stats1); statsA = abs(statsA); 
stats1 = fcnFixStatsProblems(stats1); 
stats4 = fcnFixStatsProblems(stats4); 
statsA = fcnFixStatsProblems(statsA); 

% for i = 1:size(stats4,2); 
%     y = statsA(:,i); 
%     bar(y); 
%     g = input('ok'); 
% end
%statsNames = {'Se' 'Fpr' 'PPV' 'NPV' 'Pre' 'ARI' 'ARR' 'LR+' 'LR-'};
% stats = [se sp lrp lrn dor ari ard nnt p0 pp np];
%%
disp('**************'); 
disp('Risk = 1'); 
[m1,L1,U1]=fcnReportStats(stats1,m1);

% 
disp('**************'); 
disp('Risk = 2.5'); ;
[ma,La,Ua]=fcnReportStats(statsA,ma);

%
disp('**************'); 
disp('Risk = 4'); 



[m4,L4,U4]=fcnReportStats(stats4,m4);

return
%%
[map,num,typ] = brewermap(9,'Reds');
%% make bar plot
y = [m1; ma; m4]'; L = [L1; La; L4]'; U = [U1; Ua; U4]';
y = y(1:7,:); L = L(1:7,:); U = U(1:7,:);
U = U-y; 
L = y-L; 
figure(1); clf; 
hb=bar(y);
% Labels = {'Se' 'Fpr' 'PPV' 'NPV' 'PTP' 'ARI' 'ARD'}; % 'LR+' 'LRN'}
Labels= {'Se' 'Sp' 'LR+' 'LR-' 'DOR' 'ARI' 'ARD' 'NNT' 'PTP' 'PPV' 'NPV'};
% stats = [se sp lrp lrn dor ari ard nnt p0 pp np];

set(gca,'xtick',1:7); 
set(gca,'XTickLabel',Labels(1:7))
box off
set(gcf,'color','w')

myC = map; 
for k=1:3
  set(hb(k),'facecolor',myC(k+3,:))
%     set(hb(k),'facecolor','r'); 
%   set(hb(k),'facealpha',.5); 
%     set(get(hb(k),'Children'),'FaceAlpha',0.3)
end 

hold on;
pause(0.1); %pause allows the figure to be created
for ib = 1:numel(hb)
    %XData property is the tick labels/group centers; XOffset is the offset
    %of each distinct group
    xData = hb(ib).XData+hb(ib).XOffset;
    errorbar(xData,y(:,ib)',L(:,ib)',U(:,ib)','k.','linewidth',1)
end
h=legend('Low','Med','High');
set(h,'edgecolor','w')
set(gca,'tickdir','out'); 
set(gca,'ygrid','on'); 
ylabel('%'); 
%% 
return
set(gcf,'PaperPositionMode','auto')
print -dpng -r600 FigStats