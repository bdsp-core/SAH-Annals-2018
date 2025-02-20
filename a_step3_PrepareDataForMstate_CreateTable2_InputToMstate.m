%% EEG Analysis for Delayed Cerebral Ischemia (DCI) Prediction
% This script analyzes EEG data from subarachnoid hemorrhage (SAH) patients to study 
% the relationship between EEG changes and delayed cerebral ischemia (DCI).
%
% The script processes patient data including:
% - EEG monitoring periods
% - Background activity deterioration
% - New epileptiform abnormalities
% - DCI occurrence
% - Risk scores
%
% Data is prepared for multi-state analysis to evaluate progression from:
% - Initial state
% - EEG alarm state (background deterioration or new epileptiform activity)
% - DCI state (considered absorbing state in the model)

clear all; 
clc; 
format compact;

%% Import and Process Patient Data
% Import data from master analysis spreadsheet using custom import function
T = fcnImportAnalysisData_v2();
T = T(1:103,:);  % Analyze first 103 patients

% Extract key patient characteristics
sid = T.sidList;                              % Subject IDs
target = ~isnat(T.dci);                       % DCI occurrence (true/false)
age = T.age;                                  % Patient age
Gender = T.gender;                            % Patient gender
HH = T.hh;                                    % Hunt-Hess grade
mFS = T.mfs;                                  % Modified Fisher Score
coil = strcmpi(T.coiling, 'Coil');           % Treatment type (coiling vs. clipping)

%% Calculate Time Intervals (in days)
% All times are relative to time of birth (tob)
tStart = days(T.eegStart - T.tob);            % Time to EEG monitoring start
eegDuration = days(T.eegEnd - T.eegStart);    % Duration of EEG monitoring
bgAlarm = days(T.backgroundDecline - T.tob);  % Time to background deterioration
epAlarm = days(T.newEpis - T.tob);           % Time to new epileptiform activity
anyAlarm = min(bgAlarm, epAlarm);            % Time to first EEG alarm
dci = days(T.dci - T.tob);                   % Time to DCI
E = days(T.eegEnd - T.tob);                  % Time to EEG monitoring end

% Consolidate key variables
S = sid;                                      % Subject IDs
D = dci;                                      % DCI times
A = anyAlarm;                                 % Alarm times
rs = T.riskScore;                            % Risk scores

%% Prepare Data for Multi-state Analysis
ct = 0;
row = zeros(length(S), 6);  % Preallocate results matrix

% Process each patient's data
for j = 1:length(S)
    sid = S(j);
    risk = rs(j);
    
    % Determine maximum observation time
    mx = E(j);
    if ~isinf(A(j)); mx = max(A(j), mx); end
    if ~isinf(D(j)); mx = max(D(j), mx); end
    
    % Process alarm times and states
    if A(j) < inf
        natime = A(j);
        nastat = 1;
    else
        natime = mx;
        nastat = 0;
    end
    
    % Process DCI times and states
    if D(j) < inf
        ndtime = D(j);
        ndstat = 1;
    else
        ndtime = mx;
        ndstat = 0;
    end
    
    % Adjust for DCI as absorbing state
    if ndtime < natime
        natime = ndtime;
        nastat = 0;
    end
    
    % Ensure alarm time precedes DCI time for model consistency
    if natime >= ndtime
        natime = ndtime + 0.1;
    end
    
    % Set final times for non-events
    if ndstat == 0
        ndtime = 999;
    end
    if nastat == 0
        natime = ndtime;
    end
    
    % Store processed data
    ct = ct + 1;
    row(ct,:) = [sid natime nastat ndtime ndstat risk];
end

%% Calculate Summary Statistics
% Calculate DCI rates by risk score
disp('DCI rates by risk score:')
for risk_level = 1:4
    events = sum(rs == risk_level & row(:,5));
    total = sum(rs == risk_level);
    rate = (events/total) * 100;
    fprintf('Risk score %d: %.1f%% (%d/%d)\n', risk_level, rate, events, total);
end

% Identify DCI events that preceded EEG alarms
early_dci = sum(row(:,5) == 1 & row(:,3) == 0);
fprintf('\nDCI events before EEG alarm: %d\n', early_dci);

% Display cases where DCI preceded alarm
ind = find(A > D);
if ~isempty(ind)
    fprintf('Cases with DCI before alarm (Alarm time, DCI time):\n');
    disp([A(ind) D(ind)]);
end

% Write processed data to file
fcnWriteDataToTxtFile(row);