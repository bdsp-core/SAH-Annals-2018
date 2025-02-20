function [stats,pstate1,pstate2,pstate3,pstate4,Time] = fcnGetStatsFromOverallCurves(time,pstate1,pstate2,pstate3,pstate4); 

%% interpolate
[~,pstate1] = fcnInterpolateProbCurves(time,pstate1); pstate1(1:2) = 1; 
[~,pstate2] = fcnInterpolateProbCurves(time,pstate2); pstate2(1) = 0; 
[~,pstate3] = fcnInterpolateProbCurves(time,pstate3); pstate3(1) = 0; 
[Time,pstate4] = fcnInterpolateProbCurves(time,pstate4); pstate4(1)=0; 

%% stacked probs -- overall -- from state1
[t,y1,y2,y3,y4]=fcnMakeStackedProbPlot_v2(pstate1,pstate2,pstate3,pstate4,Time); 

%% get se, sp, ppv, npv
red = y4-y3; red = red(end); 
pink = y3-y2; pink = pink(end); 
yellow = y2-y1; yellow = yellow(end); 
green = y1; green = green(end); 

se = pink/(pink+red) % fraction of true events detected = pink / pink + red
fp = 1-green/(green+yellow) % fraction of non-dci with alarms = yellow / yellow+pink
pp = pink/(pink+yellow) % fraction of alarms with true events = pink / pink+yellow
np = green/(green+red) % fraction of non-alarms with no events = green / green + red
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
