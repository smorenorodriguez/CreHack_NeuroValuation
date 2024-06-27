function [dim, options]=prepare_inversion_observation(y,u_c,muPrior,VarPrior,Data_type,dispo,verb)
% Data_type = 0: continuous, 1: binomial, 2:categorial


Ntrials=length(y);

%%
nb_param=length(muPrior);
%% Definition of model options

dim = struct('n',0,...  % number of hidden states
    'p',size(y,1),... % total output dimension
    'n_theta',0,... % number of evolution parameters
    'n_phi', nb_param,... % number of observation parameters
    'n_t',Ntrials); % number of trials
% options.inF = []; % Extra information for Evolution functions
% options.inG = []; % Extra information for Observation functions
options.DisplayWin = dispo; % Display setting
options.GnFigs = 0; % Plotting option
options.isYout = zeros(length(Data_type),Ntrials); % vector of the size of y, 1 if trial out
options.isYout(isnan(y(1,:)) | isnan(sum(u_c,1)))=1;

options.verbose=verb;
for t=1:length(Data_type)
sources(t)=struct('out',t,'type',Data_type(t));
end
options.sources=sources;
%% Definition of priors

% Priors on parameters (mean and Covariance matrix)

% Observation parameters :
priors.muPhi = muPrior;
priors.SigmaPhi = VarPrior;


options.priors = priors;