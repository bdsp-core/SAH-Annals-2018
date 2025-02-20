clear all; clc; format compact

% load TableData.mat %TableOfEEGChangesAndDCIExamChangesS4
load TableData2
% T = TableOfEEGChangesAndDCIExamChangesS4; 
T = TableOfEEGChangesAndDCIExamChangesS1; 

%               slowing	adr	rav	focalEDs	bihemEDs	lrda	lpds	gpds															
% decLOC																							
% focalWeakness																							
% aphasia																							
% newImaging																							
% noDCI		

disp('******************'); 
disp('******************'); 
disp('******************'); 
disp('******************'); 
disp('numbers for true positive dci'); 
disp('number with dci (should be 50)');  
pos = (T.slowing|T.adr|T.rav|T.lpd|T.lrda|T.gpd|T.sharpsSpikes);
ndci = sum((T.focalweakness | T.aphasia | T.decLOC | T.newimaginginfarct).*pos);
disp(ndci)

% number with focal weakness in isolation
disp('number with focal weakness in isolation:'); 
n1 = sum((T.focalweakness & ~T.aphasia & ~T.decLOC & ~T.newimaginginfarct).*pos);
disp([n1 n1/ndci])

% number with decLOC weakness in isolation
disp('number with decLOC in isolation:'); 
n2=sum((~T.focalweakness & ~T.aphasia & T.decLOC & ~T.newimaginginfarct).*pos);
disp([n2 n2/ndci])

% number with aphasia in isolation
disp('number with aphasia in isolation:'); 
n3=sum((~T.focalweakness & T.aphasia & ~T.decLOC & ~T.newimaginginfarct).*pos);
disp([n3 n3/ndci])

% number with imaging in isolation
disp('number with imaging only dci:'); 
n4=sum((~T.focalweakness & ~T.aphasia & ~T.decLOC & T.newimaginginfarct).*pos);
disp([n4 n4/ndci])

% number with two findings: 
% focal + decLOC
disp('number with focal weakness + decLOC:'); 
n12 = sum((T.focalweakness & ~T.aphasia & T.decLOC & ~T.newimaginginfarct).*pos);
disp([n12 n12/ndci])

% focal + aphasia
disp('number with focal weakness + aphasia :'); 
n13 = sum((T.focalweakness & T.aphasia & ~T.decLOC & ~T.newimaginginfarct).*pos);
disp([n13 n13/ndci])

% % focal + imaging
% disp('number with focal weakness + imaging:'); 
% n14 = sum(T.focalweakness & ~T.aphasia & ~T.decLOC & T.newimaginginfarct);
% disp([n14 n14/ndci])

% imaging + clinical
disp('number with focal weakness + imaging:'); 
n15 = sum( (T.focalweakness & ~T.decLOC & ~T.aphasia & T.newimaginginfarct).*pos);
disp([n15 n15/ndci])

disp('number with focal weakness + decLOC + imaging:'); 
n16 = sum((T.focalweakness & T.decLOC & ~T.aphasia & T.newimaginginfarct).*pos);
disp([n16 n16/ndci])

disp(n1+n2+n3+n4+n12+n13+n15+n16)


%% number with dci
disp('******************'); 
disp('******************'); 
disp('******************'); 
disp('******************'); 
disp('numbers for all dci'); 
disp('number with dci (should be 52)');  
ndci = sum(T.focalweakness | T.aphasia | T.decLOC | T.newimaginginfarct);
disp(ndci )

% number with focal weakness in isolation
disp('number with focal weakness in isolation:'); 
n1 = sum(T.focalweakness & ~T.aphasia & ~T.decLOC & ~T.newimaginginfarct);
disp([n1 n1/ndci])

% number with decLOC weakness in isolation
disp('number with decLOC in isolation:'); 
n2=sum(~T.focalweakness & ~T.aphasia & T.decLOC & ~T.newimaginginfarct);
disp([n2 n2/ndci])

% number with aphasia in isolation
disp('number with aphasia in isolation:'); 
n3=sum(~T.focalweakness & T.aphasia & ~T.decLOC & ~T.newimaginginfarct);
disp([n3 n3/ndci])

% number with imaging in isolation
disp('number with imaging only dci:'); 
n4=sum(~T.focalweakness & ~T.aphasia & ~T.decLOC & T.newimaginginfarct);
disp([n4 n4/ndci])

% number with two findings: 
% focal + decLOC
disp('number with focal weakness + decLOC:'); 
n12 = sum(T.focalweakness & ~T.aphasia & T.decLOC & ~T.newimaginginfarct);
disp([n12 n12/ndci])

% focal + aphasia
disp('number with focal weakness + aphasia :'); 
n13 = sum(T.focalweakness & T.aphasia & ~T.decLOC & ~T.newimaginginfarct);
disp([n13 n13/ndci])

% % focal + imaging
% disp('number with focal weakness + imaging:'); 
% n14 = sum(T.focalweakness & ~T.aphasia & ~T.decLOC & T.newimaginginfarct);
% disp([n14 n14/ndci])

% imaging + clinical
disp('number with focal weakness + imaging:'); 
n15 = sum( T.focalweakness & ~T.decLOC & ~T.aphasia & T.newimaginginfarct);
disp([n15 n15/ndci])

disp('number with focal weakness + decLOC + imaging:'); 
n16 = sum( T.focalweakness & T.decLOC & ~T.aphasia & T.newimaginginfarct);
disp([n16 n16/ndci])


disp(n1+n2+n3+n4+n12+n13+n15+n16)



%% true positives: should be 50
dci = (T.focalweakness | T.aphasia | T.decLOC | T.newimaginginfarct);
pos = (T.slowing|T.adr|T.rav|T.lpd|T.lrda|T.gpd|T.sharpsSpikes);
tp = dci.*pos; 
disp([sum(pos) sum(dci) sum(tp)]); 

% decLOC + imaging
% disp('number with focal weakness + imaging:'); 
% n15 = sum(T.focalweakness & T.aphasia & ~T.decLOC & ~T.newimaginginfarct);
% disp(n15)


%%

decLOC = 100*[sum(T.decLOC & T.slowing) sum(T.decLOC & T.adr) sum(T.decLOC & T.rav) ...
    sum(T.decLOC & T.sharpsSpikes & T.focalIICA) sum(T.decLOC & T.sharpsSpikes & ~T.focalIICA) ...
    sum(T.decLOC & T.lrda) sum(T.decLOC & T.lpd) sum(T.decLOC & T.gpd)]/sum(T.decLOC) 

fWeak = 100*[sum(T.focalweakness & T.slowing) sum(T.focalweakness & T.adr) ...
    sum(T.focalweakness & T.rav) sum(T.focalweakness & T.sharpsSpikes & T.focalIICA) ...
    sum(T.focalweakness & T.sharpsSpikes & ~T.focalIICA) sum(T.focalweakness & T.lrda) ...
    sum(T.focalweakness & T.lpd) sum(T.focalweakness & T.gpd)]/sum(T.focalweakness)

aphasia = 100*[sum(T.aphasia & T.slowing)    sum(T.aphasia & T.adr) sum(T.aphasia & T.rav) ...
    sum(T.aphasia & T.sharpsSpikes & T.focalIICA) sum(T.aphasia & T.sharpsSpikes & ~T.focalIICA)...
    sum(T.aphasia & T.lrda) sum(T.aphasia & T.lpd) sum(T.aphasia & T.gpd)]/sum(T.aphasia)

newImaging = 100*[sum(T.newimaginginfarct & T.slowing)   sum(T.newimaginginfarct & T.adr) ...
    sum(T.newimaginginfarct & T.rav) sum(T.newimaginginfarct & T.sharpsSpikes & T.focalIICA) ...
    sum(T.newimaginginfarct & T.sharpsSpikes & ~T.focalIICA) sum(T.newimaginginfarct & T.lrda) ...
    sum(T.newimaginginfarct & T.lpd) sum(T.newimaginginfarct & T.gpd)]/sum(T.newimaginginfarct)

T2 = ~T.newimaginginfarct& ~T.aphasia & ~T.focalweakness& ~T.decLOC ; 
noDCI = 100*[sum(T2 & T.slowing)    sum(T2 & T.adr) sum(T2 & T.rav) ...
    sum(T2 & T.sharpsSpikes & T.focalIICA) sum(T2 & T.sharpsSpikes & ~T.focalIICA) ...
    sum(T2 & T.lrda) sum(T2 & T.lpd) sum(T2 & T.gpd)]/sum(T2)

v1 = [sum(T.decLOC) sum(T.focalweakness) sum(T.aphasia) sum(T.newimaginginfarct) sum(T2)]'

disp('**********'); 
v = [decLOC; fWeak; aphasia; newImaging; noDCI];
v = [v1 v]

%% both focal and global decline
ndci = sum( T.focalweakness | T.aphasia | T.decLOC | T.newimaginginfarct)
s12 = sum(T.focalweakness & T.decLOC & ~T.aphasia)
s13 = sum(T.focalweakness & T.aphasia & ~T.decLOC)
s1 = sum(T.focalweakness & ~T.decLOC & ~T.aphasia)
s2 = sum(T.decLOC & ~ T.focalweakness & ~T.aphasia)
s3 = sum(T.aphasia & ~T.focalweakness & ~T.decLOC)

disp('dci total, focal wk, decLOC, aphasia, wk+decLOC, wk+aphasia'); 
disp([ndci s1 s2 s3 s12 s13])
disp(100*[ndci s1 s2 s3 s12 s13]/ndci)
disp(sum(100*[s1 s2 s3 s12 s13]/ndci))

epis = sum(T.gpd | T.lpd | T.sharpsSpikes | T.lrda)
epis2 = sum(T.new | T.incFreq | T.infPrev)

bg = sum(T.adr |T.rav | T.slowing)
bg1 = sum(T.adr & ~T.rav)
bg2 = sum(T.rav & ~T.adr)
bg12 = sum(T.adr & T.rav)

%% make a matrix, separate global and focal findings
% slowing    adr    rav    focalBG    BGnew    Bginc    
% sharpsSpikes    lpd    lrda    gpd    focalIICA    
% new   incFreq    infPrev    
% decLOC    focalweakness    aphasia  newimaginginfarct    
% BGbihembihem    BGfocalfocal    EPISfocalfocal EPISbihembilat    

% nonfocal: 
% ~focalBG x rav, adr, slowing; ~focalIICA x sharpsSpikes, gpd
f1 = ~T.focalBG .*T.rav.*dci; 
f2 = ~T.focalBG .*T.adr.*dci; 
f3 = ~T.focalBG .*T.slowing.*dci
f4 = ~T.focalIICA .*T.sharpsSpikes.*dci;
f5 = T.gpd.*dci; 

% focal
% focalBG x rav, adr, slowing; focalIICA x sharpsSpikes, lpd, lrda
f6 = T.focalBG .* T.rav.*dci;
f7 = T.focalBG .* T.adr.*dci; 
f8 = T.focalBG .* T.slowing.*dci; 
f9 = T.focalIICA .* T.sharpsSpikes.*dci; 
f10 = T.lpd.*dci; 
f11 = T.lrda.*dci; 

L = {'RAV-B' 'ADR-B' 'SLO-B' 'SS-B' 'GPD' 'RAV-F' 'ADR-F' ...
    'SLO-F' 'SS-F' 'LPD' 'LRDA'};

f = [f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11];

% colors for bars
c = 'bbbbbrrrrrr';
c = [0 0 0 0 0 1 1 1 1 1 1];

%% for paragraph about figure 3
disp('***************')
disp('***************')


% number with decLOC with focal abnormalities
fa = ( (T.focalBG .* T.rav.*dci) | (T.focalBG .* T.adr.*dci) | (T.focalBG .* T.slowing.*dci) | (T.focalIICA .* T.sharpsSpikes.*dci) | (T.lpd.*dci) | (T.lrda.*dci)); 
R1 = sum(T.decLOC.*fa); D1 = sum(T.decLOC); 
R2 = sum(T.focalweakness.*fa); D2 = sum(T.focalweakness); 
R3 = sum(T.aphasia.*fa); D3 = sum(T.aphasia); 
R4 = sum(T.newimaginginfarct.*fa); D4 = sum(T.newimaginginfarct); 

disp(sprintf('decLOC   + focal abnl: %0.2f [%0.2f%%] of the %0.0f', R1, R1/D1*100, D1)); 
disp(sprintf('weakenss + focal abnl: %0.2f [%0.2f%%] of the %0.0f', R2, R2/D2*100, D2)); 
disp(sprintf('aphasia  + focal abnl: %0.2f [%0.2f%%] of the %0.0f', R3, R3/D3*100, D3)); 
disp(sprintf('imaging  + focal abnl: %0.2f [%0.2f%%] of the %0.0f', R4, R4/D4*100, D4)); 

disp('***************')
disp('***************')


%% number based on epileptiforms
disp('***************')
disp('number based on epis'); 
epi = (T.lpd|T.lrda|T.gpd|T.sharpsSpikes).*dci;
disp(sum(epi)); 
epiNew = epi.*T.new;
disp('number of epis new'); 
disp([sum(epiNew) sum(epiNew)/sum(epi)])
epiInc = epi.*T.incFreq; 
disp('number of epis inc freq'); 
disp([sum(epiInc) sum(epiInc)/sum(epi)])
epiPrev = epi.*T.infPrev;
disp('number of epis inc prev'); 
disp([sum(epiPrev) sum(epiPrev)/sum(epi)])


%% 
% new
% incr freq
% inc prev

%% among those with decLOC: get number wieh each 
ind = find(T.decLOC); 
r1 = sum(repmat(T.decLOC,1,11).*f); 
r2 = sum(repmat(T.focalweakness,1,11).*f); 
r3 = sum(repmat(T.aphasia,1,11).*f); 
r4 = sum(repmat(T.newimaginginfarct,1,11).*f); 
r = [r2; r1; r4; r3];
den = [ sum(T.focalweakness) sum(T.decLOC) sum(T.newimaginginfarct) sum(T.aphasia) ];

T = {'Focal weakness (n=27)' 'Decreased LOC (n=22)' 'New infarct on CT/MRI (n=6)' 'Aphasia (n=5)' }

%%
disp('*************************'); 
disp('*************************'); 
disp('Report epis preceding DCI findings');
ntp = sum(tp); 
for i = 1:4
    disp('*************'); 
   disp(T{i});    
   disp('focal'); 
   disp([sum(r(i,6:11)) den(i) sum(r(i,6:11))/den(i)*100])
end
disp('*************************'); 
disp('*************************'); 

%% based on epis
disp('*************')
disp('based on epis')




%%
imagesc(r); colormap hot; colorbar
figure(1); clf; 
yL = {'% with Decreased LOC' '% with Focal Weakness' '% with Aphasia' '% with infarct on CT/MRI'}
for i = 1:4; 
    subplot(4,1,i);
    x = 1:11; 
    h = r(i,:);
    y=h/sum(h)*100
    for j = 1:11; 
        % bar(x(j),y(j),c(j)); hold on
        if c(j)==0;     
             bar(x(j),y(j),'k','facea',0.4); hold on
%              vals = repelem(x(j),y(j)); % Repeats element of x1(i), y1(i) times (for each i)
%              h = histogram(vals);
%              h.FaceAlpha = 0.2;
        else
             bar(x(j),y(j),'k'); hold on
%              vals = repelem(x(j),y(j)); % Repeats element of x1(i), y1(i) times (for each i)
%              h = histogram(vals);
%              h.FaceAlpha = 0.2;
        end
            
    end
    
    t=title(T{i});
    set(t, 'horizontalAlignment', 'left')
    set(t, 'units', 'normalized')
    h1 = get(t, 'position')
    set(t, 'position', [0 h1(2) h1(3)])
    
    ylim([0 30]);
    text(x(h>0),y(h>0)',num2str(h(h>0)','%0.0f'),... 
        'HorizontalAlignment','center',... 
        'VerticalAlignment','bottom')
    box off; 
    set(gca,'tickdir','out');
    if i<4; set(gca,'xtick',''); end
    ylabel('%')
    if i==4; 
        set(gca,'xtick',1:11); 
        set(gca,'xticklabel',L);
        ax = gca; 
        ax.XTickLabelRotation=45;
    end
end
set(gcf,'color','w')

%% more stats
disp('**********************')
for i = 1:4; 
    d = sum(r(i,:)); % what is d?: sum of r...
    f = sum(r(i,1:5)');
    g = sum(r(i,6:11)');
    disp([d f g f/d g/d])
end

%%
set(gcf,'PaperPositionMode','auto')
print -dpng -r600 FigEEG_DCI_Associations