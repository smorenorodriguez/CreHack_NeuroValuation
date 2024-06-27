% written by SMR
% last update: 28/05/2024

clear
close all
clc

addpath([pwd '/utils'])
sub_to_include=[1:21 24:40]; % exclusions: 22=claustrophobia -> no MRI 23=MRI technical issue -> no MRI

%% -------------------------------------------------------------------------
% I. COMPARING ORIGINALITY AND ADEQUACY RATINGS
disp('I. COMPARING ORIGINALITY AND ADEQUACY RATINGS')
disp(' ')

% load data and store variables/participant
for n=1:length(sub_to_include)
    if sub_to_include(n)<10
        name_participant=['B_0' num2str(sub_to_include(n))];
    else
        name_participant=['B_' num2str(sub_to_include(n))];
    end
    [FGAT, Ratings]=get_CreHackData(name_participant);

    % store variables/participant
    originality_first(n)=mean(Ratings.originality(Ratings.is_first_resp==1));
    originality_distant(n)=mean(Ratings.originality(Ratings.is_first_resp==0));
    adequacy_first(n)=mean(Ratings.adequacy(Ratings.is_first_resp==1));
    adequacy_distant(n)=mean(Ratings.adequacy(Ratings.is_first_resp==0));
    difference_originality(n)=abs(originality_distant(n)-originality_first(n));
    difference_adequacy(n)=abs(adequacy_distant(n)-adequacy_first(n));
    dictaverf_first(n)=mean(FGAT.frequency_dictaverf(FGAT.condition==1));
    dictaverf_distant(n)=mean(FGAT.frequency_dictaverf(FGAT.condition==2));
end

% 1. Ratings mean and SEM
ratings={originality_first,originality_distant,adequacy_first,adequacy_distant};
fields={'originality first','originality distant','adequacy first','adequacy distant'};
disp('1. Ratings mean and SEM')
for i=1:length(ratings)
    disp('____________')
    disp(' ')
    disp(fields{i})
    [mean_ratings(i),sem_ratings(i)]=mean_sem_disp(ratings{i});
end

% 2. Difference in distant-first gaps, between originality and adequacy
disp('________________________')
disp(' ')
disp('2. Difference distant-first gaps, between originality and adequacy')
disp(' ')
ttest_displayed(difference_originality-difference_adequacy);
disp('________________________')

% 3. Difference in frequency, between distant and first
disp(' ')
disp('3. Difference in frequency, between distant and first')
disp(' ')
ttest_displayed(dictaverf_distant-dictaverf_first);
disp(' ')
disp('=====================================================================')
disp(' ')

%% -------------------------------------------------------------------------
% II. EFFECT OF LIKEABILITY RATINGS ON RESPONSE TIMES
disp('II. EFFECT OF LIKEABILITY RATINGS ON RESPONSE TIMES')
disp(' ')

% load data and store variables/participant
for n=1:length(sub_to_include)
    if sub_to_include(n)<10
        name_participant=['B_0' num2str(sub_to_include(n))];
    else
        name_participant=['B_' num2str(sub_to_include(n))];
    end
    [FGAT, Ratings]=get_CreHackData(name_participant);

    % store variables/participant
    [RT_FGAT1(:,n), RATINGS_FGAT1(:,n),count1(:,n)]=do_bin_fixed_val([FGAT.RT_answer(FGAT.condition==1)],[FGAT.likeability(FGAT.condition==1)],linspace(0,100,11));
    model=fitlm(nanzscore([FGAT.likeability(FGAT.condition==1)]),nanzscore([FGAT.RT_answer(FGAT.condition==1)]));
    FGAT1_RT_RATING_reg(n)=model.Coefficients.Estimate(2);
    [RT_FGAT2(:,n), RATINGS_FGAT2(:,n),count2(:,n)]=do_bin_fixed_val([FGAT.RT_answer(FGAT.condition==2)],[FGAT.likeability(FGAT.condition==2)],linspace(0,100,11));
    model=fitlm(nanzscore([FGAT.likeability(FGAT.condition==2)]),nanzscore([FGAT.RT_answer(FGAT.condition==2)]));
    FGAT2_RT_RATING_reg(n)=model.Coefficients.Estimate(2);
end

% 1. Linear regression of RT in FGAT against Likeability ratings
disp('1. Linear regression of RT in FGAT against Likeability ratings')
disp(' ')
disp('FGAT1 beta')
[mean_regr.FGAT1,sem_regr.FGAT1]=mean_sem_disp(FGAT1_RT_RATING_reg);
ttest_displayed(FGAT1_RT_RATING_reg);
disp('____________')
disp(' ')
disp('FGAT2 beta')
[mean_regr.FGAT2,sem_regr.FGAT2]=mean_sem_disp(FGAT2_RT_RATING_reg);
ttest_displayed(FGAT2_RT_RATING_reg);
disp('________________________')
disp(' ')

% 2. Effect of likeability ratings on "distant” versus “first” RT - i.e. βdistant-βfirst'
disp('2. Effect of likeability ratings on “distant” versus “first” RT - i.e. βdistant-βfirst')
disp(' ')
ttest_displayed(FGAT1_RT_RATING_reg-FGAT2_RT_RATING_reg);
disp(' ')
disp('=====================================================================')
disp(' ')

%% -------------------------------------------------------------------------
% III. LIKEABILITY RATINGS IN FUNCTION OF ORIGINALITY AND ADEQUACY RATINGS
disp('III. LIKEABILITY RATINGS IN FUNCTION OF ORIGINALITY AND ADEQUACY RATINGS')
disp(' ')

[fit,alpha,delta]=do_CES_fit(sub_to_include);

% 1. Fit of the CES on the data
disp('1. Fit of the CES on the data')
disp(' ')
disp('r^2')
[CES.mean_fit,CES.sem_fit]=mean_sem_disp(fit);
ttest_displayed(fit);
disp('________________________')
disp(' ')

% 2. Parameters estimates
disp('2. Parameters estimates')
disp(' ')
disp('alpha')
[CES.mean_alpha,CES.sem_alpha]=mean_sem_disp(alpha);
ttest_displayed(alpha-0.5);
disp('____________')
disp(' ')
disp('delta')
[CES.mean_delta,CES.sem_delta]=mean_sem_disp(delta);
ttest_displayed(delta-1);
disp('________________________')
disp(' ')

% 3. Interindividual differences in alpha
disp('3. Interindividual differences in alpha')
disp(' ')
CES.alpha_coeff_variation=std(alpha)/CES.mean_alpha;
disp(['coefficient of variation : ' num2str(CES.alpha_coeff_variation)])
disp('____________')
disp(' ')

%Effect of response frequency on likeability ratings
disp('Effect of response frequency on likeability ratings')
% load data and store variables/participant
for n=1:length(sub_to_include)
    if sub_to_include(n)<10
        name_participant=['B_0' num2str(sub_to_include(n))];
    else
        name_participant=['B_' num2str(sub_to_include(n))];
    end
    [FGAT, Ratings]=get_CreHackData(name_participant);

    % store variables/participant
    Ratings.frequency_dictaverf(find(Ratings.frequency_dictaverf==-1))=NaN; %unknown associations used to get a frequency of -1, here we switch it to NaNs to avoid skewing our mean
    Ratings_frequency_dictaverf=log(Ratings.frequency_dictaverf);
    Ratings_frequency_dictaverf(isinf(Ratings_frequency_dictaverf))=-8;
    model=fitlm(nanzscore(Ratings_frequency_dictaverf(Ratings.is_first_resp==0)),nanzscore(Ratings.likeability(Ratings.is_first_resp==0)));
    slope_freq_lik(n,1)=model.Coefficients.Estimate(2);
end
[mean_slope_freq_lik,sem_slope_freq_lik]=mean_sem_disp(slope_freq_lik);
ttest_displayed(slope_freq_lik);
disp('____________')
disp(' ')

% Effect of alpha on the relationship between response frequency and likeability ratings
disp('Effect of alpha on the relationship between response frequency and likeability ratings')
model=fitlm(alpha,slope_freq_lik);% useless?
reglin_slopealpha=model.Coefficients.Estimate;% useless?
[coef, pval]=corr(alpha,slope_freq_lik);
disp(['r=' num2str(coef)])
disp(['p=' num2str(pval)])
disp(' ')
disp('=====================================================================')
disp(' ')
%% -------------------------------------------------------------------------
% IV. CANONICAL CORRELATION BETWEEN CREATIVE ABILITIES AND EVALUATION PATTERNS
disp('IV. CANONICAL CORRELATION BETWEEN CREATIVE ABILITIES AND EVALUATION PATTERNS')
disp(' ')

%% 1. get creative abilities scores

% save scores into a structure :
% creativity_scores = struct with fields:
%     mean_ICAA: [40×1 double]
%           CAT: [40×1 double]
%      drawings: [40×1 double]
%       fluency: [40×1 double]

% load scores
load('/Users/sarah.moreno/ownCloud/Documents/PhD/CreHack/OPEN_SCIENCE/data/creativity_scores.mat','creativity_scores')

%% 2. do canonical correlation

% store variables
evaluation_vars = [alpha,delta];
creativity_vars = [creativity_scores.mean_ICAA,...
    creativity_scores.CAT,...
    creativity_scores.drawings,...
    creativity_scores.fluency];
evaluation_vars = rmmissing(evaluation_vars);
creativity_vars = rmmissing(creativity_vars);
all_variables   = nanzscore([evaluation_vars,creativity_vars]);
evaluation_indices=1:2;
creativity_indices=3:6;

% canonical correlation: main coeff and pval
[A,B,r,U,V,stats]=canoncorr(creativity_vars,evaluation_vars);
disp('first canonical variable')
disp(['r = ' num2str(r(1))]);
disp(['p = ' num2str(stats.p(1))]);
disp(' ')
disp('second canonical variable')
disp(['r = ' num2str(r(2))]);
disp(['p = ' num2str(stats.p(2))]);

% canonical correlation: loadings' coeff and pval
for i=1:length(evaluation_indices)
    [rA(i,1),rA(i,2)]=corr(all_variables(:,evaluation_indices(i)),U(:,1));
end
for i=1:length(creativity_indices)
    [rB(i,1),rB(i,2)]=corr(all_variables(:,creativity_indices(i)),V(:,1));
end

% make sure we're seeing coeffs in a direction that makes sense
c=0; 
for i=1:length(rB) % count how many scores are negative
    if rB(i,1)<0
        c=c+1;
    end
end
if c>ceil(length(rB)/2) % if more than half of the scores are negative, then change direction
    rB(:,1)=-rB(:,1);
    rA(:,1)=-rA(:,1);
end

disp('____________')
disp(' ')
disp('CREATIVITY SCORES loadings coeff and pval:')
disp(' ')
disp(['ICAA:        r = ' num2str(rB(1,1)) '   p = ' num2str(rB(1,2))])
disp(['CAT:         r = ' num2str(rB(2,1)) '   p = ' num2str(rB(2,2))])
disp(['drawings:    r = ' num2str(rB(3,1)) '   p = ' num2str(rB(3,2))])
disp(['fluency:     r = ' num2str(rB(4,1)) '   p = ' num2str(rB(4,2))])
disp(' ')
disp('EVALUATION PARAMETERS loadings coeff and pval:')
disp(' ')
disp(['alpha:       r = ' num2str(rA(1,1)) '   p = ' num2str(rA(1,2))])
disp(['delta:       r = ' num2str(rA(2,1)) '  p = ' num2str(rA(2,2))])












