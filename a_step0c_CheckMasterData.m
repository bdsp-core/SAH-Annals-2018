clear all; clc; format compact; 

%% get dci times
% pathName = 'D:\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Data_DoNotShare\';
% pathName = 'C:\Users\mw110\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Data_DoNotShare\';
% pathName = 'C:\Users\mw110\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
pathName = 'C:\Users\emily_000\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
% pathName = 'C:\Users\mbwes\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';

fileName = 'sah_data_MASTER_FOR_ANALYSIS_v5.xlsx'; 
T=fcnImportAnalysisData
% T=fcnImportAnalysisData; %([pathName fileName],'MSM_Data',2,101);

%% check that all cases have >= 3 days eeg
t = datenum(T.eegEnd) - datenum(T.eegStart); 
min(t)

%% check how long dci occurs after end of eeg: 
t = datenum(T.eegEnd) - datenum(T.dci); % should be no more negative than -1
sid = T.sidList;
[sid t]
sum(t<-1)
[sid(t<-1) t(t<-1)]

%% check no eeg alarms after dci
t = datenum(T.dci) - datenum(T.newEpis);
[sid(t<0) t(t<0)]
