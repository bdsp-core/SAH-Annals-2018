clear; clc; format compact;

%% Setup and Data Import
% This script formats data for a Cox proportional hazards model with time‐dependent covariates.
% Each row in the final Cox matrix has the format:
%   [sid, t1, t2, alarmStatus, DINDstatus, riskScore]
%
% Key date variables are stored as datetime values, and durations are computed in days.
% The input Excel file is imported using the function fcnImportAnalysisData_v2.

% Specify the Excel file name (full path can be included in the import function if desired)
fileName = 'sah_data_MASTER_FOR_ANALYSIS_v5.xlsx'; 

% Import the data and select the first 103 rows
T = fcnImportAnalysisData_v2();
T = T(1:103,:);

%% Extract and Compute Key Variables
% Subject identifiers and key event dates are extracted from the table.
sid = T.sidList;        % Subject IDs
dob = T.tob;            % Date of birth (datetime)
rs  = T.riskScore;      % Risk score

% Determine the earlier event between 'newEpis' and 'backgroundDecline'
minAlarm = min(T.newEpis, T.backgroundDecline);

% Compute the alarm time as the number of days from dob to the earlier alarm event.
% If either date is missing, the result is NaN, which we then convert to Inf.
alarm_time = days(minAlarm - dob);
alarm_time(isnan(alarm_time)) = Inf;

% Compute DIND event time (days from dob to DIND event)
dind_time = days(T.dci - dob);
dind_time(isnan(dind_time)) = Inf;

% Define subjects as censored if their DIND time exceeds 999 days.
censored = dind_time > 999;

% Compute the EEG end time (days from dob to eegEnd)
end_time = days(T.eegEnd - dob);

%% Sanity Check Calculations
% These calculations provide summary statistics for quality control.
tp = sum(alarm_time < dind_time & dind_time < 999);      % True positives
tn = sum(alarm_time > 22 & dind_time > 999);              % True negatives
Fp = sum(alarm_time < Inf & dind_time > 999);             % False positives
fn = sum(alarm_time > 22 & dind_time < 999);              % False negatives

se = tp / (tp + fn);  % Sensitivity
fp = Fp / (Fp + tn);  % False positive rate
sp = 1 - fp;          % Specificity
pv = tp / (tp + Fp);  % Positive predictive value
np = tn / (tn + fn);  % Negative predictive value

fprintf('Sanity Check:\n');
fprintf('  True positives: %d\n', tp);
fprintf('  True negatives: %d\n', tn);
fprintf('  Sensitivity: %.2f\n', se);
fprintf('  Specificity: %.2f\n', sp);

%% Determine Last Observation Time per Subject
% For each subject, define last_time as:
%   - the EEG end time if the subject is censored, or
%   - the DIND event time if not censored.
last_time = zeros(size(end_time));
censoredIdx = find(censored);
nonCensoredIdx = find(~censored);
last_time(censoredIdx) = end_time(censoredIdx);
last_time(nonCensoredIdx) = dind_time(nonCensoredIdx);

%% Build the Cox Proportional Hazards Matrix
% For each subject, the observation period is broken into intervals defined by:
%   0 (baseline), alarm time, and the last time.
% For each interval, alarmStatus and DINDstatus indicate whether the corresponding event
% occurred by the end of the interval.

ct = 0;  % Counter for rows in Cox_mat
for j = 1:size(T,1)
    % Ensure overall end_time for subject j is at least as large as any event time.
    if dind_time(j) < Inf
        end_time(j) = max(end_time(j), dind_time(j));
    end
    if alarm_time(j) < Inf
        end_time(j) = max(end_time(j), alarm_time(j));
    end
    % Store summary times for each subject: [sid, alarm_time, dind_time, end_time]
    TIMES(j,:) = [sid(j), alarm_time(j), dind_time(j), end_time(j)];
    
    % Create time breakpoints for intervals.
    % Always include 0 (baseline) and any finite event times.
    eventTimes = [alarm_time(j), last_time(j)];
    finiteTimes = sort([0, eventTimes(eventTimes < Inf)]);
    
    % Generate start-stop pairs for intervals
    startStop = [finiteTimes(1:end-1)', finiteTimes(2:end)'];
    
    % For each interval, record the subject ID, interval start (t1), interval end (t2),
    % alarmStatus (true if alarm occurs on or before t2),
    % DINDstatus (true if DIND event occurs on or before t2),
    % and risk score.
    for i = 1:size(startStop,1)
        t1 = startStop(i,1);
        t2 = startStop(i,2);
        alarmStatus = alarm_time(j) <= t2;
        DINDstatus  = dind_time(j) <= t2;
        ct = ct + 1;
        Cox_mat(ct,:) = [sid(j), t1, t2, alarmStatus, DINDstatus, rs(j)];
    end
end

disp('Cox Matrix:');
disp(Cox_mat);

% Save the Cox matrix and the TIMES summary to a MAT-file.
save('CoxMatrix.mat', 'Cox_mat', 'TIMES');

%% Prepare and Export DIND Times for Old Cases
% For each subject, if a DIND event occurred (i.e. dind_time is finite),
% convert the duration (in days) to a date string; otherwise, leave it blank.
dind = cell(length(sid), 1);
for i = 1:length(sid)
    if ~isinf(dind_time(i))
        dind{i} = datestr(dind_time(i));
    else
        dind{i} = '';
    end
end

% Create a table with subject IDs and their corresponding DIND times,
% and write it to a CSV file.
T_out = table(sid, dind);
writetable(T_out, 'dindTimesOldCases.csv');
