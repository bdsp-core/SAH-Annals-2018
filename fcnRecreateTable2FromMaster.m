function T=fcnRecreateTable2FromMaster
%% Make histogram for patients with eventual DINDs after alarms of time to DIND

% load CoxMatrix.mat % format: TIMES(j,:)=[sid(j) alarm_time(j) dind_time(j) end_time(j)];
% load LR_mats1;
% rs=LR_X(:,1); % has risk score

%% get data from sah_new_ptsList_EEGannotations.xlsx
%folderPath = 'C:\Users\mw110\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Data_DoNotShare';
% folderPath = 'D:\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Data_DoNotShare';
% [a,b,c]=xlsread([folderPath '\sah_new_ptsList_EEGannotations.xlsx'],'AllCasesCombined');

pathName = 'C:\Users\mw110\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
pathName = 'C:\Users\mbwes\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
pathName = 'C:\Users\emily_000\Dropbox (SAH MONITORING)\0_Work\Administrative\Mentoring_And_Colleagues\EricRosenthal\Clin Neurophys Predict DIND\';
fileName = 'sah_data_MASTER_FOR_ANALYSIS_v5.xlsx'; 

T = fcnImportAnalysisData_v2();
T = T(1:103,:);

%%
sid = T.sidList; 
target = ~isnat(T.dci); % 1 = had dci, 0 = did not have dci

age = T.age; 
Gender = T.gender;
HH  = T.hh;
mFS  = T.mfs; %% check ! do I have FS or mFS?
coil = T.coiling == 'Coil'; 
tStart = datenum(T.eegStart) - datenum(T.tob);
eegDuration = datenum(T.eegEnd) - datenum(T.eegStart);
tob = datenum(T.tob); 
bgAlarm = datenum(T.backgroundDecline)-tob;
epAlarm = datenum(T.newEpis)-tob;
anyAlarm = min(bgAlarm,epAlarm)
dci = datenum(T.dci)-tob;

E = datenum(T.eegEnd)-tob;
S = sid; 
D = dci; 
A = anyAlarm;
rs = T.riskScore;


% S = a(:,1); 
% tob = fcnGetDatenums(b(2:end,2)); 
% E = fcnGetDatenums(b(2:end,4)) - tob; 
% A1 = fcnGetDatenums(b(2:end,5)) - tob; % any background worsening
% A2 = fcnGetDatenums(b(2:end,6)) - tob; % any new epis
% D  = fcnGetDatenums(b(2:end,8)) - tob; % dci time
% A = min([A1 A2]')'; % any EEG deterioration

% TIMES = [S A D E];
% data = [S A D E A1 A2 rs]; 
% dataNames = {'sid' 'anyAlarm' 'dci' 'endEEG' 'backgroundWorse' 'newEpis'};
% 
% save DataTimesForTable data dataNames %% use this to build all tables

%%
% ind=find(TIMES(:,4)>21); TIMES(ind,4)=23;
% S=TIMES(:,1); % subject ID
% A=TIMES(:,2); % alarm time -- relative to tob
% D=TIMES(:,3); % dci time -- relative to tob
% E=TIMES(:,4); % end of eeg -- relative to tob

disp([A D E])

%% get data ready for mstate analysis
ct=0; 
for j=1:length(S); 
    sid=S(j); 
    risk=rs(j); 
    % get maximum time
    mx=E(j); 
    if ~isinf(A(j)); mx=max(A(j),mx); end
    if ~isinf(D(j)); mx=max(D(j),mx); end
    
    if A(j)<inf; 
        natime=A(j);
        nastat=1; 
    else
        natime=mx; 
        nastat=0; 
    end
    if D(j)<inf; 
        ndtime=D(j); 
        ndstat=1; 
    else
        ndtime=mx;
        ndstat=0; 
    end
    
    % in our model dind/dci is the absorbing state
    if ndtime<natime;
        natime=ndtime; 
        nastat=0; 
    end
    
    % mstate seems to want natime to be less that ndtime even when no event occurs
    if natime>=ndtime
        natime=ndtime+.1; 
    end
    
    if ndstat==0
        ndtime=22; 
    end
    if nastat==0; 
        natime=ndtime;
    end
    
    ct=ct+1; 
    row(ct,:)=[sid natime nastat ndtime ndstat risk];
end

%% SOME SUMMARY STATS
e=row(:,5); 
% proportion of high risk guys with events
hr=sum(rs>2 & e)/sum(rs>2)*100; disp(hr)
lr=sum(rs==1 & e)/sum(rs<=1)*100; disp(lr)
lr=sum(rs==2 & e)/sum(rs==2)*100; disp(lr)
lr=sum(rs==3 & e)/sum(rs==3)*100; disp(lr)
lr=sum(rs==4 & e)/sum(rs==4)*100; disp(lr)

% how many dinds occured before alarms
sum(row(:,5)==1 & row(:,3)==0)
ind=find(A>D)
disp([A(ind) D(ind)])

fcnWriteDataToTxtFile(row); 