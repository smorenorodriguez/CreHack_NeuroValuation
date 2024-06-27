% written by SMR
% last update 28/05/2024

clear
close all
clc
addpath([pwd '/utils'])
sub_to_include=[1:21 24:40]; % exclusions: 22=claustrophobia -> no MRI 23=MRI technical issue -> no MRI

%% do CES fit
[fit,alpha,delta]=do_CES_fit(sub_to_include);

%% do canonical correlation

% save scores into a structure :
% creativity_scores = struct with fields:
%     mean_ICAA: [40×1 double]
%           CAT: [40×1 double]
%      drawings: [40×1 double]
%       fluency: [40×1 double]

% load scores
load('/Users/sarah.moreno/ownCloud/Documents/PhD/CreHack/OPEN_SCIENCE/data/creativity_scores.mat','creativity_scores')

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



%% do figure

f=figure;
set(gcf,'color','white')

subplot(3,3,[1 2 4 5])
scatter(U(:,1),V(:,1),100,[0.4392 0.8039 0.2784],'filled','MarkerEdgeColor',[0.4392 0.8039 0.2784],'LineWidth',1)
lsline
xlabel('Canonical Variable 2')
ylabel('Canonical Variable 1')
set(gca,'FontSize',14)

subplot(3,3,[3 6])
barh(rB(:,1),'FaceColor','#70CD47','EdgeColor','#70CD47','LineWidth',1)
set(gca,'YtickLabel',{'ICAA', 'CAT', 'drawings', 'associative fluency task'},'YAxisLocation','right')
xlabel('correlation coefficient')
xlim([-.05 1])
set(gca,'FontSize',14)

subplot(3,3,[7 8])
bar(rA(:,1),'FaceColor','#70CD47','EdgeColor','#70CD47','LineWidth',1)
set(gca,'XtickLabel',{'alpha', 'delta'},'YAxisLocation','right')
ylim([-.05 1])
set(gca,'FontSize',14)
ylabel('correlation coefficient')

