% written by SMR
% last update 22/05/2024

clear
close all
clc
addpath([pwd '/utils'])
sub_to_include=[1:21 24:40]; % exclusions: 22=claustrophobia -> no MRI 23=MRI technical issue -> no MRI

%% A: LIKEABILITY RATING IN FUNCTION OF FREQUENCY
% _________________________________________________________________________
% 1. prepare figure A

% store variables/participant
for n=1:length(sub_to_include)
    if sub_to_include(n)<10
        name_participant=['B_0' num2str(sub_to_include(n))];
    else
        name_participant=['B_' num2str(sub_to_include(n))];
    end
    [FGAT, Ratings]=get_CreHackData(name_participant);

    %log transformation
    Ratings.frequency_dictaverf(find(Ratings.frequency_dictaverf==-1))=NaN; 
    Ratings_frequency_dictaverf=log(Ratings.frequency_dictaverf);
    Ratings_frequency_dictaverf(isinf(Ratings_frequency_dictaverf))=-8;
    % bin data
    Ratings_likeability=Ratings.likeability(Ratings.is_first_resp==0);
    Ratings_frequency_dictaverf=Ratings_frequency_dictaverf(Ratings.is_first_resp==0);
    [like_binned(:,n), freq_binned(:,n)]=do_bin_fixed_val(Ratings_likeability,Ratings_frequency_dictaverf,linspace(-8,0,10));
    % regression
    model=fitlm(Ratings_frequency_dictaverf,Ratings_likeability);
    reglin_dictaverf(n,:)=model.Coefficients.Estimate;
    % regression for second level
    model=fitlm(nanzscore(Ratings_frequency_dictaverf),nanzscore(Ratings_likeability));
    zsreglin_dictaverf(n,:)=model.Coefficients.Estimate;
end
mean_reglin_dictaverf=nanmean(reglin_dictaverf);
[fit,alpha,delta]=do_CES_fit(sub_to_include);


%%
% _________________________________________________________________________
% 2. print figure A

figure
set(gcf,'color','white')
hold on
x=[min(freq_binned(:))-2,max(freq_binned(:))+2];
y=mean_reglin_dictaverf(2)*x+mean_reglin_dictaverf(1);
[~,p]=ttest(zsreglin_dictaverf);
if p<0.05
    plot(x,y,'Color','k')
else
    plot(x,y,'--','Color', 'k')
end
scatter_double_bars(freq_binned',like_binned','k');
ylim([0, 100]);
xlabel('FREQUENCY');
ylabel('LIKEABILITY RATING')
title({'EFFECT OF ASSOCIATION FREQUENCY ON LIKEABILITY RATING'})
set(gca,'FontSize',14,'XTick',[],'Ytick',[],'Ydir','normal')
% add relationship for extreme participants
[~,n_lowest_alpha]=min(alpha);
[~,n_highest_alpha]=max(alpha);
y=reglin_dictaverf(n_lowest_alpha,2)*x+reglin_dictaverf(n_lowest_alpha,1);
plot(x,y,'--','LineWidth',2,'Color', rgb('Red'));
y=reglin_dictaverf(n_highest_alpha,2)*x+reglin_dictaverf(n_highest_alpha,1);
plot(x,y,'--','LineWidth',2,'Color', rgb('Gold'));
hold off


%% B: CORRELATION BETWEEN ALPHA AND LIKEABILITY-FREQUENCY SLOPE
% _________________________________________________________________________
% 1. prepare figure A

% store variables/participant
for n=1:length(sub_to_include)
    if sub_to_include(n)<10
        name_participant=['B_0' num2str(sub_to_include(n))];
    else
        name_participant=['B_' num2str(sub_to_include(n))];
    end
    [FGAT, Ratings]=get_CreHackData(name_participant);
    Ratings.frequency_dictaverf(find(Ratings.frequency_dictaverf==-1))=NaN; %unknown associations used to get a frequency of -1, here we switch it to NaNs to avoid skewing our mean
    Ratings_frequency_dictaverf=log(Ratings.frequency_dictaverf);
    Ratings_frequency_dictaverf(isinf(Ratings_frequency_dictaverf))=-8;
    model=fitlm(nanzscore(Ratings_frequency_dictaverf(Ratings.is_first_resp==0)),nanzscore(Ratings.likeability(Ratings.is_first_resp==0)));
    slope_freq_lik(n,1)=model.Coefficients.Estimate(2);
end

% 2. print figure B

figure
set(gcf,'color','white')
hold on
[r,p]=corr(alpha,slope_freq_lik);
model=fitlm(alpha,slope_freq_lik);
beta=model.Coefficients.Estimate;
x=[min(alpha)-0.1,max(alpha)+0.1];
y=beta(2)*x+beta(1);
if p<0.05
    plot(x,y,'Color','k')
else
    plot(x,y,'--','Color', 'k')
end
scatter(alpha,slope_freq_lik,100,'k', 'filled');
%ylim([0, 100]);
ylabel('LIKEABILITY-FREQUENCY SLOPE');
xlabel('ALPHA')
title({'CORRELATION BETWEEN ALPHA', 'AND LIKEABILITY-FREQUENCY SLOPE'})
set(gca,'FontSize',14,'Ydir','normal')
hold off

