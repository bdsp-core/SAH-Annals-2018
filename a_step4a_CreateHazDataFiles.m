clear all; clc; format compact; 

%% load, format, save data for cumulative hazards

% first run R code: mState_mbw5_predictionCurves.R

% variables: Haz, time, time1, varHaz, VarName1
%load HAZDATA25a
filename = 'risk_score25_haz.csv'
[VarName3,time,Haz,time5,varHaz] = fcnImportHaz25(filename);
[t,y,ye]=fcnGetHazData(time,Haz,varHaz); 
save hazdata25 t y ye
clear

%load HAZDATA1a
filename = 'risk_score1_haz.csv';
[VarName,time,Haz,time3,varHaz] = fcnImportHaz1(filename);
[t,y,ye]=fcnGetHazData(time,Haz,varHaz); 
save hazdata1 t y ye
clear

%load HAZDATA4a
filename = 'risk_score4_haz.csv';
[VarName,time,Haz,time1,varHaz] = fcnImportHaz4(filename);
[t,y,ye]=fcnGetHazData(time,Haz,varHaz); 
save hazdata4 t y ye

