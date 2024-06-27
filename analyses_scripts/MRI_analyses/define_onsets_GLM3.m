function Events_model3(options,sub_nb)
%% EVENTS DEFINITION SCRIPT 
% -----------------------------------------------------------------------
% Script created by A. Lopez-Persem on 23/02/2022
% This script is a template for events definition in CreHack B.
% There is one section per session. If you want to only define stuff for
% one session, you can. 
% names, onsets and durations are cell arrays of type of events
% %ex : names={'cross','cue','press'}
%     onsets={[8 14 ... timeCrossLast trial], [10 16 ... timeCueLasttrial], ...}
%     durations={0,0,0};
% pmod are the parametric modulators: continuous regressors
% %ex : pmod(1).param{1}=[val1 val2 ... valLastTrial] first parametric modulator of onset{1};
%     pmod(1).param{2}=[val1 val2 ... valLastTrial] second parametric modulator of onset{1};
%     pmod(2).param{1}=[val1 val2 ... valLastTrial] first parametric modulator of onset{2};
%     pmod(2).param{2}=[val1 val2 ... valLastTrial] second parametric modulator of onset{2};
% pmod should also contain:
%        - pmod(n).poly{m} % polynomial order of the parametric modulator,
%                            almost always set to 1. 
%        - pmod(n).name{m} % name of the parametric modulator* _
%-----------------------------------------------------------------------

% First create a folder for subject at stake in the OnsetsDef folder
modeldir=[options.rootOnsets    '/model' options.modelName filesep options.study_code sub_nb];
mkdir(modeldir)

% Get Behavioral timing, if there are exceptions for specific subjects, the
% following function should be edited, errors will occur if something is 
% different for a given subejct
[FGAT_1, FGAT_2,RTG_1]=get_taskTimes(options.rootBehavior,sub_nb); % TASK.CleanTimes are timing with T0 removed

%% ADEQ AND ORIG VALUES
[OA_behav]=load([options.ProjectRoot strcat('BEHAVIOR/B_', sub_nb, '/RatingTaskEO_Crehack_B_',sub_nb ,'.mat')]);
Adeq=[OA_behav.Output.RatingTask{:,4,2}]';

%%
% Clear stuffs from previous subjects or sessions
clear names onsets durations to_keep pmod

% default value for event durations, can be adjusted within each session
durationsval=0;


%% -----------------------------------------------------------------------
%% ------------------------   FGAT FIRST ---------------------------------
%% -----------------------------------------------------------------------


% This is for pmod
tt=0;
to_keep=[];
for t=1:length(FGAT_1.CleanTimes.trials_included)
    % Find in rating the FGAT association
    id_rating=find(strcmp(FGAT_1.Output.FGAT_First{FGAT_1.CleanTimes.trials_included(t),1},OA_behav.Output.RatingTask(:,1,1)) &...
                   strcmp(FGAT_1.Output.FGAT_First{FGAT_1.CleanTimes.trials_included(t),4},OA_behav.Output.RatingTask(:,2,1)));
    % If the association has been rated, store it in pmod
    if ~isempty(id_rating)
        tt=tt+1;
        pmod(1).param{1}(tt)=Adeq(id_rating);
        % trace back which trials have been kept. 
        to_keep(tt)=t;
    end
    
end

% Event characteristics
names(1)     = {'cue'};
FGAT1_times = FGAT_1.CleanTimes.SubjectPress(to_keep)-FGAT_1.CleanTimes.cue_onset(to_keep);
durations(1) = {FGAT1_times};
onsets(1)    = {FGAT_1.CleanTimes.cue_onset(to_keep)};
pmod(1).name{1}  = 'AdeqRating'; % name of the parametric modulator
pmod(1).poly{1}  = 1; % polynomial order of the parametric modulator
pmod(1).param{1} = nanzscore(pmod(1).param{1}); % values of the parametric modulator

% Save onsets, names, pmod and durations with the session name
save([modeldir '/FGAT_1.mat'],'names','onsets', 'pmod','durations')

% Clear stuff
clear names onsets durations to_keep pmod


%% -----------------------------------------------------------------------
%% ------------------------   FGAT DIST ----------------------------------
%% -----------------------------------------------------------------------
tt=0;
to_keep=[];
for t=1:length(FGAT_2.CleanTimes.trials_included)
    id_rating=find(strcmp(FGAT_2.Output.FGAT_Distant{FGAT_2.CleanTimes.trials_included(t),1},OA_behav.Output.RatingTask(:,1,1)) &...
                   strcmp(FGAT_2.Output.FGAT_Distant{FGAT_2.CleanTimes.trials_included(t),4},OA_behav.Output.RatingTask(:,2,1)));
    if ~isempty(id_rating)
        tt=tt+1;
        pmod(1).param{1}(tt)=Adeq(id_rating);
        to_keep(tt)=t;
    end
end

FGAT2_times = FGAT_2.CleanTimes.SubjectPress(to_keep)-FGAT_2.CleanTimes.cue_onset(to_keep);
names(1)={'cue'};
onsets(1)={FGAT_2.CleanTimes.cue_onset(to_keep)};
durations(1) = {FGAT2_times};
pmod(1).name{1}='AdeqRating';
pmod(1).poly{1}=1;
pmod(1).param{1}=nanzscore(pmod(1).param{1});
save([modeldir '/FGAT_2.mat'],'names','onsets', 'pmod','durations')


clear names onsets durations to_keep pmod

%% -----------------------------------------------------------------------
%% ------------------------   RATING TASK --------------------------------
%% -----------------------------------------------------------------------

tt=0;
to_keep=[];
for t=1:length(RTG_1.CleanTimes.includedTrials)
    id_rating=find(strcmp(RTG_1.Output.RatingTask{RTG_1.CleanTimes.includedTrials(t),1},OA_behav.Output.RatingTask(:,1,1)) &...
                   strcmp(RTG_1.Output.RatingTask{RTG_1.CleanTimes.includedTrials(t),2},OA_behav.Output.RatingTask(:,2,1)));
    if ~isempty(id_rating)
        tt=tt+1;
        %pmod(1).param{1}(tt)=RTG_1.Output.RatingTask{id_rating,4};
        %pmod(1).param{1}(tt)=Orig(id_rating);
        pmod(1).param{1}(tt)=Adeq(id_rating);
        to_keep(tt)=t;
    end
end

names(1)={'cue'};
onsets(1)={RTG_1.CleanTimes.cue_onset};
RTG_times = RTG_1.CleanTimes.SubjectPress(RTG_1.CleanTimes.includedTrials)-RTG_1.CleanTimes.cue_onset(RTG_1.CleanTimes.includedTrials);
durations(1) = {RTG_times};
% pmod(1).name{1}='OrigRating';
% pmod(1).poly{1}=1;
% pmod(1).param{1}=nanzscore(pmod(1).param{1});
pmod(1).name{1}='AdeqRating';
pmod(1).poly{1}=1;
pmod(1).param{1}=nanzscore(pmod(1).param{1});

save([modeldir '/RTG_1.mat'],'names','onsets', 'pmod','durations')


clear names onsets durations to_keep pmod