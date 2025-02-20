clear;clc;format compact;

%% step 1 %% create dataset for table
% required factors for the table 
% age, Hunt Hess, Fisher, presence of EEG alarm(if EEG alarm==1), subtypes
% of presence of EEG alarm, TCD ??, Duration of EEG monitoring, Gender,
% onset of EEG monitoring(days of after SAH monitoring)
ct=0; 

% pathName = 'C:\Users\mw110\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
% % pathName = 'C:\Users\mbwes\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
% pathName = 'C:\Users\emily_000\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
% fileName = 'sah_data_MASTER_FOR_ANALYSIS_v5.xlsx'; 
% load MASTERDATA % sahdataMASTERFORANALYSISv4
% T = sahdataMASTERFORANALYSISv5; 
% T=fcnImportAnalysisData([pathName fileName],'MSM_Data',2,102);
% % T = fcnGetCompleteDataAsTable(pathName,fileName);

% pathName = 'C:\Users\mw110\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
% pathName = 'C:\Users\mbwes\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
% pathName = 'C:\Users\emily_000\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
pathName = 'C:\Users\mw110\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
%pathName = 'C:\Users\mbwes\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
% pathName = 'C:\Users\emily_000\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';


fileName = 'sah_data_MASTER_FOR_ANALYSIS_v5.xlsx'; 
T=fcnImportAnalysisData_v2;

T = T(1:103,:);

T.anyWorse = min(T.newEpis,T.backgroundDecline);

sid = T.sidList; 
target = ~isnat(T.dci); % 1 = had dci, 0 = did not have dci

age = T.age; 
Gender = T.gender;
HH  = T.hh;
mFS  = T.mfs; %% check ! do I have FS or mFS?
coil = T.coiling == 'Coil';  
risk = T.riskScore;
tStart = datenum(T.eegStart) - datenum(T.tob);
eegDuration = datenum(T.eegEnd) - datenum(T.eegStart);



%%
dci = datenum(T.dci);
alarm = datenum(T.anyWorse); 

ind = find(~isnan(dci) & ~isnan(alarm)); 

alarm = alarm(ind); 
dci = dci(ind); 
Sid = sid(ind); 
t = dci - alarm

%% dci time relative to tob
tdci = datenum(T.dci(ind)) - datenum(T.tob(ind));


x = 0:11; n = zeros(size(x));
for i = 2:length(x); 
    n(i-1) = sum(t>=x(i-1)& t<x(i)); 
    L{i-1} = sprintf('%d-%d',x(i-1),x(i)); 
end
x = x(1:end-2); 
n = n(1:end-2);
n(9) = n(10); n(10)=0; 
L = L(1:length(n)); 
L{end} = '>10';
figure(1); clf;

p = n/sum(n)*100; 
bar(x,p,'k')

text(x(1:9),p(1:9)',num2str(n(1:9)','%0.0f'),... 
        'HorizontalAlignment','center',... 
        'VerticalAlignment','bottom')


set(gca,'xtick',x); 
set(gca,'xticklabel',L)
set(gcf,'color','w'); 
box off
set(gca,'tickdir','out');
xlabel('Latency from cEEG alarm to DCI (days)'); 
ylabel('% of DCI events'); 
xlim([-1 9.5])
grid on
ylim([0 35])



set(gcf,'PaperPositionMode','auto')
print -dpng -r600 Fig_Latencies