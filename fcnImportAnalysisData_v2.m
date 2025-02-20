function T = fcnImportAnalysisData_v2

%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: /Users/bwestove/cdac Dropbox/brandon westover/bdsp_publication_workingFolder/NewCode_03_15_2016/sah_data_MASTER_FOR_ANALYSIS_v5.xlsx
%    Worksheet: MSM_Data
%
% Auto-generated by MATLAB on 20-Feb-2025 10:28:08

%% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 38);

% Specify sheet and range
opts.Sheet = "MSM_Data";
opts.DataRange = "A2:AL112";

% Specify column names and types
opts.VariableNames = ["sidList", "age", "gender", "hh", "mfs", "coiling", "riskScore", "tob", "eegStart", "eegEnd", "backgroundDecline", "newEpis", "dci", "tcdMaxBeforeDCI", "eegEndToDci", "durationOfEEG", "sahToDci", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "sidFellDCI", "FirstFellowDIND", "DCIdiscrepency", "RecommendedNewDatetime", "DCIType", "ImpactOnAnalysis", "Typediscrepency", "Reasondiscrepency", "VarName31", "FellowDINDType12", "FirstFellowDINDExcludedwhenNoDCI", "FirstExcludedDINDType", "ExclusionType", "ExclusionOther", "ImpersistenInsigniftDIND", "ImpersistentType"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "categorical", "double", "datetime", "datetime", "datetime", "datetime", "datetime", "datetime", "double", "double", "double", "double", "double", "string", "string", "string", "string", "double", "datetime", "double", "datetime", "categorical", "string", "categorical", "string", "string", "double", "datetime", "double", "double", "string", "datetime", "double"];

% Specify variable properties
opts = setvaropts(opts, ["VarName19", "VarName20", "VarName21", "VarName22", "ImpactOnAnalysis", "Reasondiscrepency", "VarName31", "ExclusionOther"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["coiling", "VarName19", "VarName20", "VarName21", "VarName22", "DCIType", "ImpactOnAnalysis", "Typediscrepency", "Reasondiscrepency", "VarName31", "ExclusionOther"], "EmptyFieldRule", "auto");

% Import the data
sahdataMASTERFORANALYSISv5 = readtable("/Users/bwestove/cdac Dropbox/brandon westover/bdsp_publication_workingFolder/NewCode_03_15_2016/sah_data_MASTER_FOR_ANALYSIS_v5.xlsx", opts, "UseExcel", false);

T = sahdataMASTERFORANALYSISv5; 

%% Clear temporary variables
clear opts