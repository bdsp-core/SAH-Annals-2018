clear all; clc; format compact; 

%% Plots 
figure(1); clf; 
make_it_tight = true;
subplot = @(m,n,p) subtightplot (m, n, p, [0.045 0.02], [0.1 0.01], [0.1 0.01]);
if ~make_it_tight,  clear subplot;  end

%% plot risk vs time for an individual
figure(1); clf; subplot(2,3,4); 
% filename = 'HAZDATA1'; 
% filename = 'hazdata1';
filename = 'data_prediction_risk1.csv';
riskTitle = 'Risk = 1'; 
Talarm = 30; 
Tdind = 30; 
fcnPlotPredictionCurve_v2(filename, riskTitle,Talarm, Tdind,1);  

subplot(2,3,5); 
% filename = 'HAZDATA25'; 
filename = 'data_prediction_risk25.csv';
riskTitle = 'Risk = 2.5'; 
Talarm = 3; 
Tdind = 30; 
fcnPlotPredictionCurve_v2(filename, riskTitle,Talarm, Tdind,0);  

subplot(2,3,6); 
% filename = 'HAZDATA4';
filename = 'data_prediction_risk4.csv';
riskTitle = 'Risk = 4'; 
Talarm = 6; 
Tdind = 8; 
fcnPlotPredictionCurve_v2(filename, riskTitle,Talarm, Tdind,0);  

%%
%************************************************

%% remake the stacked probabilities plots from R
%***********************
%****** risk = 1 *******
%***********************
filename= 'risk_score1.csv';  
[time,pstate1,pstate2,pstate3,pstate4] = fcnReadStackedProbTable(filename); 

%% stacked probs -- overall -- from state1
subplot(2,3,1); 
fcnMakeStackedProbPlotNoXlabel(pstate1,pstate2,pstate3,pstate4,time,0); 
text(3,.4,'Baseline','fontsize',9);
text(8.5,0.7,'Alarm','fontsize',9);
text(12.5,0.83,'Predicted DCI','fontsize',9);
text(15,0.975,'Missed DCI','fontsize',9);
set(gca, 'LineWidth', 1.2)

disp('Risk = 1'); 
m = fcnGetSixStatsNoPlot(pstate1,pstate2,pstate3,pstate4,time); 
fcnReportStats_OnlyMain(m)
disp('***********'); 
%***********************
%****** risk = 2.5 *******
%***********************
%load('C:\Users\emily_000\Dropbox (SAH MONITORING)\Papers_InProgress\EEG_SAH_OutcomePredictionUsingEEGReports\R_stuff\RoutputsForPlottingInMatlab\PT.mat');
filename= 'risk_score2p5.csv'; 
[time,pstate1,pstate2,pstate3,pstate4] = fcnReadStackedProbTable(filename); 

%% stacked probs -- overall -- from state1
subplot(2,3,2); 
fcnMakeStackedProbPlotNoXlabel(pstate1,pstate2,pstate3,pstate4,time,1); 
text(2,.4,'Baseline','fontsize',9);
text(8,0.6,'Alarm','fontsize',9);
text(13,0.8,'Predicted DCI','fontsize',9);
text(15,0.97,'Missed DCI','fontsize',9);
set(gca, 'LineWidth', 1.2)

disp('Risk = 2.5'); 
m = fcnGetSixStatsNoPlot(pstate1,pstate2,pstate3,pstate4,time); 
fcnReportStats_OnlyMain(m)
disp('***********'); 

%***********************
%****** risk = 4 *******
%***********************
%load('C:\Users\emily_000\Dropbox (SAH MONITORING)\Papers_InProgress\EEG_SAH_OutcomePredictionUsingEEGReports\R_stuff\RoutputsForPlottingInMatlab\PT4.mat');
disp('Risk = 4'); 

filename= 'risk_score4.csv';  
[time,pstate1,pstate2,pstate3,pstate4] = fcnReadStackedProbTable(filename); 

%% stacked probs -- overall -- from state1
subplot(2,3,3); 
fcnMakeStackedProbPlotNoXlabel(pstate1,pstate2,pstate3,pstate4,time,1); 
text(3,.2,'Baseline','fontsize',9); 
text(6,0.35,'Alarm','fontsize',9);
text(9.5,0.7,'Predicted DCI','fontsize',9);
text(15,0.97,'Missed DCI','fontsize',9);
set(gca, 'LineWidth', 1.2)

disp('Risk = 4'); 
m = fcnGetSixStatsNoPlot(pstate1,pstate2,pstate3,pstate4,time); 
fcnReportStats_OnlyMain(m)
disp('***********'); 


subplot(2,3,1); 
xx = [20 20]; yy= [0 1]; 
plot(xx,yy,'k'); 

subplot(2,3,2); 
xx = [20 20]; yy= [0 1]; 
plot(xx,yy,'k'); 

subplot(2,3,3); 
xx = [20 20]; yy= [0 1]; 
plot(xx,yy,'k'); 

%%
set(gcf,'PaperPositionMode','auto')
print -dpng -r600 FigProbsPreds


