clear;clc;format compact;

%% step 1 %% create dataset for table
% required factors for the table 
% age, Hunt Hess, Fisher, presence of EEG alarm(if EEG alarm==1), subtypes
% of presence of EEG alarm, TCD ??, Duration of EEG monitoring, Gender,
% onset of EEG monitoring(days of after SAH monitoring)
ct=0; 
pathName = 'C:\Users\mw110\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
pathName = 'C:\Users\emily_000\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
pathName = 'C:\Users\mbwes\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
fileName = 'sah_data_MASTER_FOR_ANALYSIS_v5.xlsx'; 
T=fcnImportAnalysisData_v2;
T = T(1:103,:); 
% T = T(1:end-7,:);
%T = fcnGetCompleteDataAsTable(pathName,fileName);
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

%% --------------------------------------

% Age, mean + SD	dci 59.9+14.4	no dci 54.5+14.9	p 0.12
a0=age(find(target==0)); a1=age(find(target==1)); 
[h,p]=ttest2(a0,a1,'tail','left');
disp(sprintf('%s: dci: %0.2f +/- %0.2f, noDci: %0.2f +/- %0.2f, p = %0.2f','age', mean(a1), std(a1), mean(a0), std(a0), p));

ct=ct+1; 
stats(ct,:) = [mean(a1) std(a1) mean(a0) std(a0)  p];

%% gender
a0=Gender(find(target==0)); a1=Gender(find(target==1)); 
p0=sum(a0==2)/length(a0)*100;
p1=sum(a1==2)/length(a1)*100;

C1 = [sum(target==1 & Gender==2);  sum(target==1 & Gender==1)];
C2 = [sum(target==0 & Gender==2);  sum(target==0 & Gender==1)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,~] = fishertest(x,'Tail','right','Alpha',0.05);

disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, p = %0.2f','sex', p1, p0, p));

ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];


%% HH>3
p0=sum(HH>3 & target==0)/sum(target==0)*100; % percent 
p1=sum(HH>3 & target==1)/sum(target==1)*100; % percent 

C1 = [sum(target==1 & HH>3);  sum(target==1 & HH<=3)];
C2 = [sum(target==0 & HH>3);  sum(target==0 & HH<=3)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'HH>3','HH<=3'});
[h,p,~] = fishertest(x,'Tail','right','Alpha',0.05);

disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, p = %0.2f','HH>3', p1, p0, p));

ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];


%% modified fisher
ind = find(target==1 & ~isnan(mFS)); a1 = mFS(ind); 
ind = find(target==0 & ~isnan(mFS)); a0 = mFS(ind); 
[h,p]=ttest2(a0,a1,'tail','left');
disp(sprintf('%s: dci: %0.2f +/- %0.2f, noDci: %0.2f +/- %0.2f, p = %0.2f','mFS', mean(a1), std(a1), mean(a0), std(a0), p));

ct=ct+1; 
stats(ct,:) = [mean(a1) std(a1) mean(a0) std(a0) p];

%% coiling
a0=coil(find(target==0)); a1=coil(find(target==1)); 
p0=sum(a0==1)/length(a0)*100;
p1=sum(a1==1)/length(a1)*100;

C1 = [sum(target==1 & coil==1);  sum(target==1 & coil==0)];
C2 = [sum(target==0 & coil==1);  sum(target==0 & coil==0)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,~] = fishertest(x,'Tail','left','Alpha',0.05);
disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, p = %0.2f','coil', p1, p0, p));

ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];


%% risk score
a0=risk(find(target==0)); a1=risk(find(target==1)); 
[h,p]=ttest2(a0,a1,'tail','left');
disp(sprintf('%s: dci: %0.2f +/- %0.2f, noDci: %0.2f +/- %0.2f, p = %0.2f','risk', nanmean(a1), nanstd(a1), nanmean(a0), nanstd(a0), p));

ct=ct+1; 
stats(ct,:) = [mean(a1) std(a1) mean(a0) std(a0) p];

%% starting time 
a0=tStart(find(target==0)); a1=tStart(find(target==1)); 
[h,p]=ttest2(a0,a1);
disp(sprintf('%s: dci: %0.2f +/- %0.2f, noDci: %0.2f +/- %0.2f, p = %0.2f','tStart', mean(a1), std(a1), mean(a0), std(a0), p));

ct=ct+1; 
stats(ct,:) = [mean(a1) std(a1) mean(a0) std(a0)  p];

%% duration of EEG
a0=eegDuration(find(target==0)); a1=eegDuration(find(target==1)); 
[h,p]=ttest2(a0,a1,'tail','left');
disp(sprintf('%s: dci: %0.2f +/- %0.2f, noDci: %0.2f +/- %0.2f, p = %0.2f','eegDays', mean(a1), std(a1), mean(a0), std(a0), p));

ct=ct+1; 
stats(ct,:) = [mean(a1) std(a1) mean(a0) std(a0)  p];

%% risk >2
r = risk>2;
a0=r(find(target==0)); a1=r(find(target==1)); 
p0=sum(a0==1)/length(a0)*100;
p1=sum(a1==1)/length(a1)*100;
C1 = [sum(target==1 & r==1);  sum(target==1 & r==0)];
C2 = [sum(target==0 & r==1);  sum(target==0 & r==0)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,s] = fishertest(x,'Tail','right','Alpha',0.05);
OR = s.OddsRatio;
ciL = s.ConfidenceInterval(1); 
ciU = s.ConfidenceInterval(2); 
disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, OR = %0.2f [%0.2f, %0.2f], p = %0.2f','risk>2', p1, p0, OR, ciL, ciU,p));
ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];

%% eeg alarm
anyAlarm = ~isnan(datenum(T.anyWorse));
a0=anyAlarm(find(target==0)); a1=anyAlarm(find(target==1)); 
p0=sum(a0==1)/length(a0)*100;
p1=sum(a1==1)/length(a1)*100;
C1 = [sum(target==1 & anyAlarm==1);  sum(target==1 & anyAlarm==0)];
C2 = [sum(target==0 & anyAlarm==1);  sum(target==0 & anyAlarm==0)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,s] = fishertest(x,'Tail','right','Alpha',0.05);
OR = s.OddsRatio;
ciL = s.ConfidenceInterval(1); 
ciU = s.ConfidenceInterval(2); 
disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, OR = %0.2f [%0.2f, %0.2f], p = %0.2f','anyAlarm', p1, p0, OR, ciL, ciU,p));
ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];

%% eeg alarm -- background
anyAlarm = ~isnan(datenum(T.backgroundDecline));
a0=anyAlarm(find(target==0)); a1=anyAlarm(find(target==1)); 
p0=sum(a0==1)/length(a0)*100;
p1=sum(a1==1)/length(a1)*100;
C1 = [sum(target==1 & anyAlarm==1);  sum(target==1 & anyAlarm==0)];
C2 = [sum(target==0 & anyAlarm==1);  sum(target==0 & anyAlarm==0)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,s] = fishertest(x,'Tail','right','Alpha',0.05);
OR = s.OddsRatio;
ciL = s.ConfidenceInterval(1); 
ciU = s.ConfidenceInterval(2); 
disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, OR = %0.2f [%0.2f, %0.2f], p = %0.2f','bgAlarm', p1, p0, OR, ciL, ciU,p));
ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];

%% eeg alarm -- rav
% get data from C:\Users\emily_000\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND
% ForTable2 excel file
load BackgroundBreakDownData S
%anyAlarm = ~isnan(datenum(T.backgroundDecline)); %% ones and zeros
anyAlarm = S.rav; 
a0=anyAlarm(find(target==0)); a1=anyAlarm(find(target==1)); 
p0=sum(a0==1)/length(a0)*100;
p1=sum(a1==1)/length(a1)*100;
C1 = [sum(target==1 & anyAlarm==1);  sum(target==1 & anyAlarm==0)];
C2 = [sum(target==0 & anyAlarm==1);  sum(target==0 & anyAlarm==0)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,s] = fishertest(x,'Tail','right','Alpha',0.05);
OR = s.OddsRatio;
ciL = s.ConfidenceInterval(1); 
ciU = s.ConfidenceInterval(2); 
disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, OR = %0.2f [%0.2f, %0.2f], p = %0.2f','RAValarm', p1, p0, OR, ciL, ciU,p));
ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];

%% eeg alarm -- adr
% get data from C:\Users\emily_000\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND
% ForTable2 excel file
load BackgroundBreakDownData S
%anyAlarm = ~isnan(datenum(T.backgroundDecline)); %% ones and zeros
anyAlarm = S.adr; 
a0=anyAlarm(find(target==0)); a1=anyAlarm(find(target==1)); 
p0=sum(a0==1)/length(a0)*100;
p1=sum(a1==1)/length(a1)*100;
C1 = [sum(target==1 & anyAlarm==1);  sum(target==1 & anyAlarm==0)];
C2 = [sum(target==0 & anyAlarm==1);  sum(target==0 & anyAlarm==0)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,s] = fishertest(x,'Tail','right','Alpha',0.05);
OR = s.OddsRatio;
ciL = s.ConfidenceInterval(1); 
ciU = s.ConfidenceInterval(2); 
disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, OR = %0.2f [%0.2f, %0.2f], p = %0.2f','ADRalarm', p1, p0, OR, ciL, ciU,p));
ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];

%% eeg alarm -- slowing
% get data from C:\Users\emily_000\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND
% ForTable2 excel file
load BackgroundBreakDownData S
%anyAlarm = ~isnan(datenum(T.backgroundDecline)); %% ones and zeros
anyAlarm = S.slowing; 
a0=anyAlarm(find(target==0)); a1=anyAlarm(find(target==1)); 
p0=sum(a0==1)/length(a0)*100;
p1=sum(a1==1)/length(a1)*100;
C1 = [sum(target==1 & anyAlarm==1);  sum(target==1 & anyAlarm==0)];
C2 = [sum(target==0 & anyAlarm==1);  sum(target==0 & anyAlarm==0)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,s] = fishertest(x,'Tail','right','Alpha',0.05);
OR = s.OddsRatio;
ciL = s.ConfidenceInterval(1); 
ciU = s.ConfidenceInterval(2); 
disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, OR = %0.2f [%0.2f, %0.2f], p = %0.2f','Slowing_alarm', p1, p0, OR, ciL, ciU,p));
ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];

%% eeg alarm -- ADR or RAV
% get data from C:\Users\emily_000\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND
% ForTable2 excel file
load BackgroundBreakDownData S
%anyAlarm = ~isnan(datenum(T.backgroundDecline)); %% ones and zeros
anyAlarm = (S.adr| S.rav);
a0=anyAlarm(find(target==0)); a1=anyAlarm(find(target==1)); 
p0=sum(a0==1)/length(a0)*100;
p1=sum(a1==1)/length(a1)*100;
C1 = [sum(target==1 & anyAlarm==1);  sum(target==1 & anyAlarm==0)];
C2 = [sum(target==0 & anyAlarm==1);  sum(target==0 & anyAlarm==0)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,s] = fishertest(x,'Tail','right','Alpha',0.05);
OR = s.OddsRatio;
ciL = s.ConfidenceInterval(1); 
ciU = s.ConfidenceInterval(2); 
disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, OR = %0.2f [%0.2f, %0.2f], p = %0.2f','ADR_or_RAV', p1, p0, OR, ciL, ciU,p));
ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];



%% eeg alarm -- epis
anyAlarm = ~isnan(datenum(T.newEpis));
a0=anyAlarm(find(target==0)); a1=anyAlarm(find(target==1)); 
p0=sum(a0==1)/length(a0)*100;
p1=sum(a1==1)/length(a1)*100;
C1 = [sum(target==1 & anyAlarm==1);  sum(target==1 & anyAlarm==0)];
C2 = [sum(target==0 & anyAlarm==1);  sum(target==0 & anyAlarm==0)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,s] = fishertest(x,'Tail','right','Alpha',0.05);
OR = s.OddsRatio;
ciL = s.ConfidenceInterval(1); 
ciU = s.ConfidenceInterval(2); 
disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, OR = %0.2f [%0.2f, %0.2f], p = %0.2f','newEpi', p1, p0, OR, ciL, ciU,p));
ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];

%*****************************************
%% TCD > 200 as alarm
anyAlarm = T.tcdMaxBeforeDCI>200; 
a0=anyAlarm(find(target==0)); a1=anyAlarm(find(target==1)); 
p0=sum(a0==1)/length(a0)*100;
p1=sum(a1==1)/length(a1)*100;
C1 = [sum(target==1 & anyAlarm==1);  sum(target==1 & anyAlarm==0)];
C2 = [sum(target==0 & anyAlarm==1);  sum(target==0 & anyAlarm==0)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,s] = fishertest(x,'Tail','right','Alpha',0.05);
OR = s.OddsRatio;
ciL = s.ConfidenceInterval(1); 
ciU = s.ConfidenceInterval(2); 
disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, OR = %0.2f [%0.2f, %0.2f], p = %0.2f','tcd>200', p1, p0, OR, ciL, ciU,p));
ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];

%*****************************************
%% TCD > 250 as alarm
anyAlarm = T.tcdMaxBeforeDCI>250; 
a0=anyAlarm(find(target==0)); a1=anyAlarm(find(target==1)); 
p0=sum(a0==1)/length(a0)*100;
p1=sum(a1==1)/length(a1)*100;
C1 = [sum(target==1 & anyAlarm==1);  sum(target==1 & anyAlarm==0)];
C2 = [sum(target==0 & anyAlarm==1);  sum(target==0 & anyAlarm==0)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,s] = fishertest(x,'Tail','right','Alpha',0.05);
OR = s.OddsRatio;
ciL = s.ConfidenceInterval(1); 
ciU = s.ConfidenceInterval(2); 
disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, OR = %0.2f [%0.2f, %0.2f], p = %0.2f','tcd>250', p1, p0, OR, ciL, ciU,p));
ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];

%*****************************************
%% TCD > 300 as alarm
anyAlarm = T.tcdMaxBeforeDCI>300; 
a0=anyAlarm(find(target==0)); a1=anyAlarm(find(target==1)); 
p0=sum(a0==1)/length(a0)*100;
p1=sum(a1==1)/length(a1)*100;
C1 = [sum(target==1 & anyAlarm==1);  sum(target==1 & anyAlarm==0)];
C2 = [sum(target==0 & anyAlarm==1);  sum(target==0 & anyAlarm==0)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,s] = fishertest(x,'Tail','right','Alpha',0.05);
OR = s.OddsRatio;
ciL = s.ConfidenceInterval(1); 
ciU = s.ConfidenceInterval(2); 
disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, OR = %0.2f [%0.2f, %0.2f], p = %0.2f','tcd>300', p1, p0, OR, ciL, ciU,p));
ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];


%*****************************************
%*****************************************
%*****************************************
%% Table 3
r = T.riskScore>2; y= target; 
n1 = sum(r & y)/sum(y)*100; 
n0 = sum(r & ~y)/sum(~y)*100; 
[mP, LP, UP, mN, LN,UN]=fcnGetLRPandLRN(r,y);
disp(sprintf('risk>2: dci: %0.2f, no dci:%0.2f, LR+: %0.2f [%0.2f, %0.2f], LR-: %0.2f [%0.2f, %0.2f]',n1,n0,mP,LP,UP,mN,LN,UN))

%% 
disp('********************'); 
ta = T.anyWorse;
ta = datenum(ta); 
sum(~isnan(ta))
dci = datenum(T.dci);


%% eeg alarm
anyAlarm = ~isnan(datenum(T.anyWorse));
a0=anyAlarm(find(target==0)); a1=anyAlarm(find(target==1)); 
p0=sum(a0==1)/length(a0)*100;
p1=sum(a1==1)/length(a1)*100;
C1 = [sum(target==1 & anyAlarm==1);  sum(target==1 & anyAlarm==0)];
C2 = [sum(target==0 & anyAlarm==1);  sum(target==0 & anyAlarm==0)];
x = table(C1,C2,'VariableNames',{'DCI','NoDCI'},'RowNames',{'F','M'});
[h,p,s] = fishertest(x,'Tail','right','Alpha',0.05);
OR = s.OddsRatio;
ciL = s.ConfidenceInterval(1); 
ciU = s.ConfidenceInterval(2); 
disp(sprintf('%s: dci: %0.2f, noDci: %0.2f, OR = %0.2f [%0.2f, %0.2f], p = %0.2f','anyAlarm', p1, p0, OR, ciL, ciU,p));
ct=ct+1; 
stats(ct,:) = [p1 nan p0 nan p];
disp(sprintf('alarms: %0.2f',sum(anyAlarm)))

tp = sum(anyAlarm & target)
tn = sum(~anyAlarm & ~target)
fp = sum(anyAlarm & ~target)
fn = sum(~anyAlarm & target)
se = tp/(tp+fn)
sp = tn/(tn+fp)
pv = tp/(tp+fp)
nv = tn/(tn+fn)

%% binomial fits for eeg alarms

disp('*****************'); 
disp('ANY EEG ALARM');
% sensitivity
n = sum(target); % number of tries -- # true cases
x = sum(target & anyAlarm); % number of successes -- # number of alarms in those cases
[se, pci] = binofit(x,n); 
disp(sprintf('se: %0.2f, [%0.2f, %0.2f]', se, pci(1), pci(2)))

% specificity
n = sum(~target); 
x = sum(~target & ~anyAlarm); 
[sp, pci] = binofit(x,n); 
disp(sprintf('sp: %0.2f, [%0.2f, %0.2f]', sp, pci(1), pci(2)))

% ppv
n = sum(anyAlarm); 
x = sum(target & anyAlarm); 
[sp, pci] = binofit(x,n); 
disp(sprintf('ppv: %0.2f, [%0.2f, %0.2f]', sp, pci(1), pci(2)))

% npv
n = sum(~anyAlarm); 
x = sum(~target & ~anyAlarm); 
[sp, pci] = binofit(x,n); 
disp(sprintf('npv: %0.2f, [%0.2f, %0.2f]', sp, pci(1), pci(2)))

%% latency
disp('**************')
disp('Latency'); 
t = datenum(T.dci)- datenum(T.anyWorse);
disp([nanmedian(t) nanmin(t) nanmax(t)])
disp([nanmedian(t) nanmin(t) nanmax(t)]*24)
disp('n, % cases with >12 hours, >8 hours lead time')
disp([sum(t>12/24) sum(t>12/24)/sum(t>0) sum(t<2/24) sum(t<2/24)/sum(t>0)])

%*************************
disp('*****************'); 
disp('TCD > 200');
tcdAlarm = T.tcdMaxBeforeDCI>200;

% sensitivity
n = sum(target); % number of tries -- # true cases
x = sum(target & tcdAlarm); % number of successes -- # number of alarms in those cases
[se, pci] = binofit(x,n); 
disp(sprintf('se: %0.2f, [%0.2f, %0.2f]', se, pci(1), pci(2)))

% specificity
n = sum(~target); 
x = sum(~target & ~tcdAlarm); 
[sp, pci] = binofit(x,n); 
disp(sprintf('sp: %0.2f, [%0.2f, %0.2f]', sp, pci(1), pci(2)))

% ppv
n = sum(tcdAlarm); 
x = sum(target & tcdAlarm); 
[sp, pci] = binofit(x,n); 
disp(sprintf('ppv: %0.2f, [%0.2f, %0.2f]', sp, pci(1), pci(2)))

% npv
n = sum(~tcdAlarm); 
x = sum(~target & ~tcdAlarm); 
[sp, pci] = binofit(x,n); 
disp(sprintf('npv: %0.2f, [%0.2f, %0.2f]', sp, pci(1), pci(2)))


%%********************************
% tcd >250
% sensitivity
disp('*****************'); 
disp('TCD > 250');
tcdAlarm = T.tcdMaxBeforeDCI>250;

n = sum(target); % number of tries -- # true cases
x = sum(target & tcdAlarm); % number of successes -- # number of alarms in those cases
[se, pci] = binofit(x,n); 
disp(sprintf('se: %0.2f, [%0.2f, %0.2f]', se, pci(1), pci(2)))

% specificity
n = sum(~target); 
x = sum(~target & ~tcdAlarm); 
[sp, pci] = binofit(x,n); 
disp(sprintf('sp: %0.2f, [%0.2f, %0.2f]', sp, pci(1), pci(2)))

% ppv
n = sum(tcdAlarm); 
x = sum(target & tcdAlarm); 
[sp, pci] = binofit(x,n); 
disp(sprintf('ppv: %0.2f, [%0.2f, %0.2f]', sp, pci(1), pci(2)))

% npv
n = sum(~tcdAlarm); 
x = sum(~target & ~tcdAlarm); 
[sp, pci] = binofit(x,n); 
disp(sprintf('npv: %0.2f, [%0.2f, %0.2f]', sp, pci(1), pci(2)))


%%********************************
% tcd >300
% sensitivity
disp('*****************'); 
disp('TCD > 300');
tcdAlarm = T.tcdMaxBeforeDCI>300;

n = sum(target); % number of tries -- # true cases
x = sum(target & tcdAlarm); % number of successes -- # number of alarms in those cases
[se, pci] = binofit(x,n); 
disp(sprintf('se: %0.2f, [%0.2f, %0.2f]', se, pci(1), pci(2)))

% specificity
n = sum(~target); 
x = sum(~target & ~tcdAlarm); 
[sp, pci] = binofit(x,n); 
disp(sprintf('sp: %0.2f, [%0.2f, %0.2f]', sp, pci(1), pci(2)))

% ppv
n = sum(tcdAlarm); 
x = sum(target & tcdAlarm); 
[sp, pci] = binofit(x,n); 
disp(sprintf('ppv: %0.2f, [%0.2f, %0.2f]', sp, pci(1), pci(2)))

% npv
n = sum(~tcdAlarm); 
x = sum(~target & ~tcdAlarm); 
[sp, pci] = binofit(x,n); 
disp(sprintf('npv: %0.2f, [%0.2f, %0.2f]', sp, pci(1), pci(2)))

%% ********************
% find optimal tcd cutoff 

%*****************************************
%% TCD > 250 as alarm
return
th = 100:300; 
for i = 1:length(th); 
    OR(i) = fcnGetTCDPerf(T,target,th(i));
end
