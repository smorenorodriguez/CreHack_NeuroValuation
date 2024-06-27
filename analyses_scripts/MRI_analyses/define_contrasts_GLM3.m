function Contrasts_model11(options)

%% CONTRASTS DEFINITION SCRIPT 
% -----------------------------------------------------------------------
% Script created by A. Lopez-Persem on 23/02/2022
% This script is a template for contrasts definition in CreHack B.
% The number of cells per contrast should correspond to the number of
% sessions included in the analyses
% The number of item within each cell should correspond to the number of
% regressors of interest per session. 
% In this template, we have : 
% contrasts.NAME_CONTRAST = {[eventFGAT1 pmodFGAT1];...
%                            [eventFGAT2 pmodFGAT2];...
%                            [eventRTG   pmodRTG];...
%                            [eventCHOICE pmod1CHOICE pmod2CHOICE]};
% If we have several events in the model, contrasts should be defined as: 
% contrasts.NAME_CONTRAST = {[event1FGAT1 pmodEvent1FGAT1 event2FGAT1 pmodEvent2FGAT1 ];...
%                            ...
% -----------------------------------------------------------------------

% Define contrast folder
rootModelContrast=[options.rootContrasts 'model' options.modelName filesep];
mkdir(rootModelContrast)

% Parametric contrasts
contrasts.Adeq              = {[0 1];[0 1] ;[0 1];[0 1 0]};
contrasts.AdeqFGAT          = {[0 1];[0 1] ;[0 0];[0 0 0]};
contrasts.AdeqFGAT1         = {[0 1];[0 0] ;[0 0];[0 0 0]};
contrasts.AdeqFGAT2         = {[0 0];[0 1] ;[0 0];[0 0 0]};
contrasts.AdeqFGAT2vsFGAT1  = {[0 -1];[0 1] ;[0 0];[0 0 0]};
contrasts.AdeqFGAT1vsFGAT2  = {[0 1];[0 -1] ;[0 0];[0 0 0]};
contrasts.AdeqFGAT2neg      = {[0 0];[0 -1] ;[0 0];[0 0 0]};
contrasts.AdeqRTG           = {[0 0];[0 0]  ;[0 1];[0 0 0]};

% Save contrasts with their names
list=fieldnames(contrasts);
for c=1:length(list)
    eval([list{c} '=contrasts.' list{c}]);
    save([rootModelContrast list{c} '.mat'],list{c})
end

clear contrasts
