clear all; clc; format compact; 

%% remake the stacked probabilities plots from R

%% can generate plot by loading PT.mat 
%load('C:\Users\Siddharth\Dropbox\EEG_SAH_OutcomePredictionUsingEEGReports\R_stuff\RoutputsForPlottingInMatlab\PT.mat'); 
% load('D:\Dropbox (SAH MONITORING)\Papers_InProgress\EEG_SAH_OutcomePredictionUsingEEGReports\R_stuff\RoutputsForPlottingInMatlab\PT.mat'); 
%% generate boostrap sample and save to table
% T = fcnImportAnalysisData_v2();
T = readtable('tabledata2.txt');
% T = tabledata2;
sid = T.sid;
natime = T.natime; 
nastat = T.nastat; 
ndtime = T.ndtime; 
ndstat = T.ndstat;
risk = T.risk; 
% return
% [sid,natime,nastat,ndtime,ndstat,risk] = fcn_importSourceTableForBootstrap('tabledata2.csv');
T0=table(sid,natime,nastat,ndtime,ndstat,risk);

for i = 1:10000; 

    T=T0;
    n=size(T,1); 
    for j=1:n
       ind=randperm(n); ind=ind(1); 
       T(j,:)=T0(ind,:); 
    end
    writetable(T,'tabledataBootstrapSeSpPpNp.txt','Delimiter','\t'); 

    %% now try instead calling R code --> test.csv file --> get contents of PT.mat --> generate plot
    %% Run the R code to produce risk_score4_haz.csv (for example)
    %system('"C:\Program Files\R\R-3.1.2\bin\R" --version');
    %system('"C:\Program Files\R\R-3.1.2\bin\R" --version'); 
    system('"/usr/local/bin/R" CMD BATCH mState_Bootstrap.R outputForDebugging.txt');

    %system('"C:\Program Files\R\R-3.0.3\bin\R" --version'); 
    %system('"C:\Program Files\R\R-3.0.3\bin\R" CMD BATCH mState_Bootstrap_SeSpPpvNpv_mbw1.R outputForDebugging.txt');

    %% get stats for each risk score
    %statsNames = {'Se' 'Sp' 'LR+' 'LR-' 'DOR' 'ARI' 'ARD' 'NNT' 'PTP' 'PPV' 'NPV'};
    filename= 'risk_score1.csv'; stats1(i,:) = fcnGetSixStats(filename); 
    filename= 'risk_score2p5.csv'; statsA(i,:) = fcnGetSixStats(filename); 
    filename= 'risk_score4.csv'; stats4(i,:) = fcnGetSixStats(filename); 
    
    %% save results
    close all
    disp(i); 
    if ~mod(i,5)
        save BOOTSTRAP_RESULTS2 stats1 statsA stats4
    end
end

save BOOTSTRAP_RESULTS2 stats1 statsA stats4
