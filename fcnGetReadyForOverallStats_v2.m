function T = fcnGetReadyForOverallStats_v2(rPath)
% fcnGetReadyForOverallStats - Prepares data for overall statistical analysis
%
% Parameters:
%   rPath: Full path to R executable (e.g., '/usr/local/bin/R' or 'C:\Program Files\R\R-4.3.2\bin\R')
%          If not provided, will attempt to find R automatically
%
% This function:
% 1. Recreates analysis table from master data
% 2. Prepares bootstrap data
% 3. Executes R script for state transition analysis
% 4. Computes statistics for different risk scores
%
% Returns:
%   T: Table containing prepared data for analysis
%
% Example usage:
%   T = fcnGetReadyForOverallStats('/usr/local/bin/R')
%   T = fcnGetReadyForOverallStats('C:\Program Files\R\R-4.3.2\bin\R')

%% Validate or find R path
if nargin < 1 || isempty(rPath)
    % Try to find R automatically
    if ispc
        [status, result] = system('where R');
    else
        [status, result] = system('which R');
    end
    
    if status == 0
        rPath = strtrim(result);
        fprintf('Found R at: %s\n', rPath);
    else
        error('R path not provided and R not found in system PATH. Please provide R path.');
    end
else
    % Verify provided R path exists
    if ~exist(rPath, 'file')
        error('Provided R path does not exist: %s', rPath);
    end
    fprintf('Using provided R path: %s\n', rPath);
end

%% Generate and save bootstrap sample
T = fcnRecreateTable2FromMaster();
dataFile = 'tabledata2.csv';

% Import bootstrap source data
[sid, natime, nastat, ndtime, ndstat, risk] = fcn_importSourceTableForBootstrap(dataFile);
T0 = table(sid, natime, nastat, ndtime, ndstat, risk);

% Save table for R processing
writetable(T0, 'tabledataBootstrapSeSpPpNp.txt', 'Delimiter', '\t');

%% Execute R script
% Construct R command
if ispc
    rCmd = sprintf('"%s" CMD BATCH mState_Overall.R outputForDebugging.txt', rPath);
else
    % Add quotes around the R path specifically
    rCmd = sprintf('"%s" CMD BATCH mState_Overall.R outputForDebugging.txt', rPath);
end

% Execute R script
fprintf('Executing R script with command: %s\n', rCmd);
[status, result] = system(rCmd);

if status ~= 0
    warning('R script execution failed with output:');
    disp(result);
    error('Failed to execute R script. Check R installation and script path.');
end

%% Calculate statistics for each risk score
try
    % Risk score 1 (low risk)
    stats1 = fcnGetSixStats('risk_score1.csv');
    
    % Risk score 2.5 (medium risk)
    statsA = fcnGetSixStats('risk_score2p5.csv');
    
    % Risk score 4 (high risk)
    stats4 = fcnGetSixStats('risk_score4.csv');
    
    % Save computed statistics
    save('computed_stats.mat', 'stats1', 'statsA', 'stats4');
    fprintf('Statistics computed and saved successfully.\n');
catch ME
    error('Failed to compute statistics: %s', ME.message);
end

end