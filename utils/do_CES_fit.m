function [fit,alpha,delta]=do_CES_fit(sub_to_include)
% Written by A. Lopez-Persem on 13/10/2022
% Edited by SMR in 2023

% verbalizing options
dispo=0;
verb=0;

% directories
addpath(genpath([pwd]));
model_name='UtilityNonLinear1CES';
dir_name=[pwd '/data/CES_data/'];

% Subjects
if dispo==1
    sub_to_include=1;
    warning('Only fitting first subject to avoid overload, set to zero to fit all subjects')
end


% Prior definition (Goes with model definition)
prior_weigth = 0;
prior_alpha  = 0;
prior_inter  = 0;
prior_diff   = 0;
prior_nonlin = 1;
prior_cst    = 0;
prior_var    = 5;

model_fun_rating = str2func(model_name);

% model definition
prior_rating=[prior_alpha prior_nonlin]';
nb_param_rating  = length(prior_rating);
var_prior_rating = eye(nb_param_rating)*prior_var; % this is if we want the same variance for all params


for n=1:length(sub_to_include)
    %% BEHAVIORAL DATA

    if sub_to_include(n)<10
        PN=['0' num2str(sub_to_include(n))];
    else
        PN=num2str(sub_to_include(n));
    end
    name_participant=['B_' PN];
    load([dir_name name_participant filesep 'CreHack_' name_participant '.mat'])
    Likeability = Ratings.likeability;
    Originality = Ratings.originality;
    Adequacy = Ratings.adequacy;


    %% Definition of model options
    f_name=[];
    g_name=model_fun_rating;
    y=Likeability';
    u_r=[Originality'; Adequacy'];
    Data_type=0;

    muPrior=prior_rating;
    VarPrior=var_prior_rating;
    % preparing the inversion
    [dim, options]=prepare_inversion_observation(y,u_r,muPrior,VarPrior,Data_type,dispo,verb);
    % mu corespond aux param de la fonction utilityNLCES
    % DataType dépend de si c'est rating, choix, autre -> voir dans la fonction


    %% Performing the inversion
    options.figName=model_name(1:end-2);
    [posteriorr,outr] = VBA_NLStateSpaceModel(y,u_r,f_name,g_name,dim,options);
    F_val(n)=outr.F;
    fit(n)=outr.fit.R2;
    % Store CES model parameter values
    posterior_param_rating(n,:)=posteriorr.muPhi;

end


%% PARAMETERS ESTIMATES
%Weight α
posterior_param_rating(:,1)=1./(1+exp(-posterior_param_rating(:,1)));
alpha=posterior_param_rating(:,1);
% Convexity δ
delta=posterior_param_rating(:,2);
