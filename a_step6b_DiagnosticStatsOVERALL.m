%% Stacked Probability Analysis for Patient State Transitions
% This script generates stacked probability plots showing transitions between
% different patient states (baseline, alarm, DCI) for various risk scores.
%
% States are defined as:
% - State 1: Baseline state
% - State 2: Alarm state (EEG deterioration)
% - State 3: Transition from Alarm to DCI
% - State 4: Direct transition from Baseline to DCI
%
% The script analyzes three risk groups:
% - Risk Score 1 (Low risk)
% - Risk Score 2.5 (Medium risk)
% - Risk Score 4 (High risk)

clear all; 
clc; 
format compact;

%% Initialize Data
% Import and prepare patient data
rPath = '/usr/local/bin/R';
T = fcnGetReadyForOverallStats_v2(rPath);
T = T(1:103,:);  % Analyze first 103 patients

%% Analysis Functions
function stats_out = plotRiskGroup(filename, plotTitle, textLocations)
    % Generates stacked probability plot for a specific risk group
    %
    % Parameters:
    %   filename: CSV file containing probability data
    %   plotTitle: Title for the output figure
    %   textLocations: Structure with x,y coordinates for text labels
    %
    % Returns:
    %   stats_out: Statistics calculated from the probability curves
    
    % Read and process probability data
    [time, pstate1, pstate2, pstate3, pstate4] = fcnReadStackedProbTable(filename);
    [stats, pstate1, pstate2, pstate3, pstate4, time] = fcnGetStateTrajectories(filename);
    [stats_out, pstate1, pstate2, pstate3, pstate4, Time] = fcnGetStatsFromOverallCurves(time, pstate1, pstate2, pstate3, pstate4);
    
    % Create visualization
    figure(1); 
    clf;
    fcnMakeStackedProbPlot(pstate1, pstate2, pstate3, pstate4, Time);
    
    % Add state labels
    text(textLocations.baseline(1), textLocations.baseline(2), 'Baseline');
    text(textLocations.alarm(1), textLocations.alarm(2), 'Alarm');
    text(textLocations.alarmDCI(1), textLocations.alarmDCI(2), 'Alarm --> DCI');
    text(textLocations.baselineDCI(1), textLocations.baselineDCI(2), 'Baseline --> DCI');
    
    % Format plot
    set(gca, 'LineWidth', 1.2);
    title(plotTitle);
    
    % Save figure
    filename_out = ['FigStacked' plotTitle];
    print(filename_out, '-dpng', '-r300');
end

%% Analyze Risk Score 1 (Low Risk)
textLocations.baseline = [3, 0.4];
textLocations.alarm = [8.5, 0.7];
textLocations.alarmDCI = [12.5, 0.83];
textLocations.baselineDCI = [15, 0.975];

stats1 = plotRiskGroup('risk_score1.csv', 'Risk1From1', textLocations);

%% Analyze Risk Score 2.5 (Medium Risk)
textLocations.baseline = [2, 0.4];
textLocations.alarm = [8, 0.6];
textLocations.alarmDCI = [13, 0.8];
textLocations.baselineDCI = [15, 0.97];

statsA = plotRiskGroup('risk_score2p5.csv', 'AllRisksFrom1', textLocations);

%% Analyze Risk Score 4 (High Risk)
textLocations.baseline = [3, 0.2];
textLocations.alarm = [6, 0.35];
textLocations.alarmDCI = [9.5, 0.7];
textLocations.baselineDCI = [15, 0.97];

stats4 = plotRiskGroup('risk_score4.csv', 'Risk4From1', textLocations);

%% Save Analysis Results
% Save statistics for all risk groups for further analysis
save('OVERALLSTATS.mat', 'stats1', 'stats4', 'statsA');

%% Helper Function Documentation
% fcnReadStackedProbTable: Reads probability data from CSV file
% fcnGetStateTrajectories: Processes raw probability data into state trajectories
% fcnGetStatsFromOverallCurves: Calculates summary statistics from probability curves
% fcnMakeStackedProbPlot: Creates stacked probability visualization