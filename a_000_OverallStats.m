clear all; clc; format compact; 

%% run all code to get OVERALL values and stacked plots
% this code does everything except boostrap

%% run R files
% 1- mState_mbw5_predictionCurves.R
% 2- mState_Overall.R
% 3- mState_Bootstrap_SeSpPpvNpv.R

%% matlab files
a_step1_create_data_for_TimeDepCoxPH_AndGetOldDindTimes_mbw
%a_step2_Figure1_SeeAlarmsAndEvents
a_step3_PrepareDataForMstate_CreateTable2_InputToMstate % writes tabledata2.txt

%% get hazard files
%system('"C:\Program Files\                                                                                                                                                                                                                                                                                                                                                             R\R-3.1.2\bin\R" CMD BATCH mState_Overall.R');
a_step4a_CreateHazDataFiles
a_step6b_DiagnosticStatsOVERALL
a_step4c_ReportStatsOnOverallCases_FIGURE_STACKEDandPRED

%% BOOTSTRAPPING
% a_step6a_StatsFromStackedProbsBootstrapByCallingR

a_step6c_DiagnosticStatsPinkPlots_NUMBERS_FOR_TABLE_3
a_step7b_table2_M1

%% overall stats
tp = 50; fp = 10; tn = 41; fn = 2; 

se = tp/(tp+fn)
sp = tn/(tn+fp)
pv = tp/(tp+fp)
nv = tn/(tn+fn)