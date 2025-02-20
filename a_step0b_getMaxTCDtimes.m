clear all; clc; format compact; 

%% get dci times
pathName = 'D:\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Data_DoNotShare\';
pathName = 'C:\Users\mw110\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Data_DoNotShare\';
%pathName = 'C:\Users\emily_000\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Data_DoNotShare';

pathName = 'C:\Users\mw110\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
%pathName = 'C:\Users\emily_000\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
fileName = 'sah_data_MASTER_FOR_ANALYSIS_v5.xlsx'; 

T=fcnImportAnalysisData % ([pathName fileName],'MSM_Data',2,104);

%% set tcd data location
td = 'D:\Dropbox (SAH MONITORING)\Papers_InProgress\EEG_SAH_OutcomePredictionUsingEEGReports\R_stuff\TCD_Data';
td = 'C:\Users\mw110\Dropbox (SAH MONITORING)\Papers_InProgress\EEG_SAH_OutcomePredictionUsingEEGReports\R_stuff\TCD_Data';
%td = 'C:\Users\emily_000\Dropbox (SAH MONITORING)\Papers_InProgress\EEG_SAH_OutcomePredictionUsingEEGReports\R_stuff\TCD_Data';

%%
dci = datenum(T.dci);
sid = T.sidList;
for i = 1:length(dci); 
   load([td '\TCD_Values_' num2str(sid(i))]); 
   figure(1); clf; 
   t = t_TCD;
   ind = find(laca>500); laca(ind) = nan; 
   ind = find(raca>500); raca(ind) = nan; 
   ind = find(lmca>500); lmca(ind) = nan; 
   ind = find(rmca>500); rmca(ind) = nan; 
   
   plot(t,laca,t,lmca,t,raca,t,rmca); drawnow; 
   disp(sid(i)); 
   if ~isnan(dci); tmax = dci(i); else; tmax = inf; end
   %% get tcd data only before this time 
   ind = find(t<tmax); 
   laca = laca(ind); 
   raca = raca(ind); 
   lmca = lmca(ind); 
   rmca = rmca(ind); 
   
   %% find max velocity
   try
   tcdMax(i,1) = max([laca raca lmca rmca]); 
   disp([sid(i) tcdMax(i,1)])
   catch
   end
end