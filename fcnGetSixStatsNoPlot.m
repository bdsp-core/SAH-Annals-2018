function stats = fcnGetSixStatsNoPlot(pstate1,pstate2,pstate3,pstate4,time); 

%% return: se, fpr, ppv, npv, pre-test prop p0, ari [absolute risk increase]

%% interpolate
[~,pstate1] = fcnInterpolateProbCurves(time,pstate1); pstate1(1:2) = 1; 
[~,pstate2] = fcnInterpolateProbCurves(time,pstate2); pstate2(1) = 0; 
[~,pstate3] = fcnInterpolateProbCurves(time,pstate3); pstate3(1) = 0; 
[time,pstate4] = fcnInterpolateProbCurves(time,pstate4); pstate4(1)=0; 

% figure(1); clf; plot(time,pstate2); 

%% stacked probs -- overall -- from state1
% figure(1); clf; 
[t,y1,y2,y3,y4]=fcnMakeGetColorsNoPlot(pstate1,pstate2,pstate3,pstate4,time); 
% text(2,.4,'Baseline'); 
% text(8,0.6,'Alarm');
% text(13,0.8,'Alarm --> DCI')
% text(15,0.97,'Baseline --> DCI');
% set(gca, 'LineWidth', 1.2)
% fname='FigStackedAllRisksFrom1'; 

%% get se, sp, ppv, npv
red = y4-y3; red = red(end); 
pink = y3-y2; pink = pink(end); 
yellow = y2-y1; yellow = yellow(end); 
green = y1; green = green(end); 

%% get se, sp, ppv, npv
se = pink/(pink+red); % fraction of true events detected = pink / pink + red
fp = yellow/(yellow+green); % fraction of non-dci with alarms = yellow / yellow+pink
pp = pink/(pink+yellow); % fraction of alarms with true events = pink / pink+yellow
np = green/(green+red); % fraction of non-alarms with no events = green / green + red
p0 = pink+red; % pre-test probability of dci
ari = pp-p0; % post-test prob - pretest prob with alarm -- absolute risk increase
ard = p0-(1-np); % pre-test prob - posttest prob without alamr -- absolute risk decrease
lrp = se/fp; 
lrn = (1-se)/(1-fp);
sp = 1-fp; 
dor = lrp/lrn;
nnt = 1/ari;

% order of stats
%statsNames = {'Se' 'Sp' 'LR+' 'LR-' 'DOR' 'ARI' 'ARD' 'NNT' 'PTP' 'PPV' 'NPV'};
stats = [se sp lrp lrn dor ari ard nnt p0 pp np];
