% written by SMR
% last update 22/05/2024

clear
close all
clc
addpath([pwd '/utils'])
sub_to_include=[1:21 24:40]; % exclusions: 22=claustrophobia -> no MRI 23=MRI technical issue -> no MRI
use_pink_coloramp=1;

%% A-left: FD proportions
% _________________________________________________________________________
% 1. prepare figure A-left

% initialize heatmap
PropDist  = zeros(length(sub_to_include),11,11,62);
PropFirst = zeros(length(sub_to_include),11,11,62);

% store proportion/participant
for n=1:length(sub_to_include)
    if sub_to_include(n)<10
        name_participant=['B_0' num2str(sub_to_include(n))];
    else
        name_participant=['B_' num2str(sub_to_include(n))];
    end
    [FGAT, Ratings]=get_CreHackData(name_participant);

    for wi=1:sum(FGAT.condition==1)
        if ~isnan(FGAT.adequacy(wi))
            PropFirst(n,round(FGAT.adequacy(wi)/10)+1,round(FGAT.originality(wi)/10)+1,wi)=1;
        end
        if ~isnan(FGAT.adequacy(wi+sum(FGAT.condition==1)))
            PropDist(n,round(FGAT.adequacy(wi+sum(FGAT.condition==1))/10)+1,round(FGAT.originality(wi+sum(FGAT.condition==1))/10)+1,wi)=1;
        end
    end
end

% average proportions across trials (4th dimension)
PropDist=nanmean(PropDist,4);
PropFirst=nanmean(PropFirst,4);
squeezedProp=squeeze(nanmean(PropDist-PropFirst,1));

% _________________________________________________________________________
% 2. print figure A-left
figure
imagesc(0:10:100,0:10:100,squeezedProp)
hold on
% do custom colormap
do_colormap_FirstDistant(squeezedProp)
load('utils/colormap_FirstDistant.mat')
colormap(colormap_FirstDistant)
c=colorbar;
c.Ticks = [-0.14, -0.1, -0.06, -0.02, 0, 0.02];
c.Label.String = 'DISTANT-FIRST PROPORTION';
c.Label.FontSize=14;
% labels
xlabel('ORIGINALITY RATING')
ylabel('ADEQUACY RATING')
set(gca,'FontSize',14,'Xtick',[0,100],'Ytick',[0,100],'Ydir','normal')
title({'PROPORTION OF FGAT ANSWERS','IN FUNCTION OF ORIGINALITY AND ADEQUACY'})
set(gcf,'color','white')
hold off
% =========================================================================

%% A-right: LIKEABILITY AND FGAT RT
% _________________________________________________________________________
% 1. prepare figure A-right

% store variables/participant
for n=1:length(sub_to_include)
    if sub_to_include(n)<10
        name_participant=['B_0' num2str(sub_to_include(n))];
    else
        name_participant=['B_' num2str(sub_to_include(n))];
    end
    [FGAT, Ratings]=get_CreHackData(name_participant);

    % 1) First responses

    % do bins for first RT
    [RTBinFL(n,:),LikbinFRT(n,:),countLF(n,:)] = do_bin_fixed_val(FGAT.RT_answer(FGAT.condition==1),FGAT.likeability(FGAT.condition==1),0:10:100);

    % Data fit
    model = fitlm([FGAT.likeability(FGAT.condition==1)],[FGAT.RT_answer(FGAT.condition==1)]);
    betasLikeFRT(n,:)=model.Coefficients.Estimate;

    % Z-scored statistics for second level
    model=fitlm(nanzscore([FGAT.likeability(FGAT.condition==1)]),nanzscore([FGAT.RT_answer(FGAT.condition==1)]));
    zsbetasLikeFRT(n)=model.Coefficients.Estimate(2);

    % 2) Distant responses

    % do bins for distant RT
    [RTBinDL(n,:),LikbinDRT(n,:),countLD(n,:)]=do_bin_fixed_val(FGAT.RT_answer(FGAT.condition==2),FGAT.likeability(FGAT.condition==2),0:10:100);

    % Data fit
    model = fitlm([FGAT.likeability(FGAT.condition==2)],[FGAT.RT_answer(FGAT.condition==2)]);
    betasLikeDRT(n,:)=model.Coefficients.Estimate;

    % Z-scored statistics for second level
    model=fitlm(nanzscore([FGAT.likeability(FGAT.condition==2)]),nanzscore([FGAT.RT_answer(FGAT.condition==2)]));
    zsbetasLikeDRT(n)=model.Coefficients.Estimate(2);

end
mean_betasLikeDRT=nanmean(betasLikeDRT);
mean_betasLikeFRT=nanmean(betasLikeFRT);

% _________________________________________________________________________
% 2. print figure A-right

figure
set(gcf,'color','white')
hold on
yyaxis right;
ax=gca;
ax.YColor=[0.7, 0.7, 0.7];
set(gca,'FontSize',14,'Ytick',[0,2,4,6,8,10],'Ydir','normal')
bar(nanmean(LikbinFRT),nanmean(countLF),'FaceAlpha',0.2,'FaceColor',rgb('LimeGreen'),'EdgeAlpha',0)
bar(nanmean(LikbinDRT),nanmean(countLD),'FaceAlpha',0.2,'FaceColor',rgb('DarkTurquoise'),'EdgeAlpha',0)
ylabel('NUMBER OF RESPONSES');
x=[min(LikbinDRT(:)),max(LikbinDRT(:))];
y=mean_betasLikeDRT(2)*x+mean_betasLikeDRT(1);
[~,p]=ttest(zsbetasLikeDRT);
yyaxis left;
ax=gca;
ax.YColor=[0,0,0];
set(gca,'FontSize',14,'XTick',[],'Ytick',[0,2,4,6,8,10],'Ydir','normal')
if p<0.05
    plot(x,y,'Color', rgb('DarkTurquoise'))
else
    plot(x,y,'--','Color', rgb('DarkTurquoise'))
end
scatter_double_bars(LikbinDRT,RTBinDL,rgb('DarkTurquoise'));
clear x y
x=[min(LikbinFRT(:)),max(LikbinFRT(:))];
y=mean_betasLikeFRT(2)*x+mean_betasLikeFRT(1);
[~~,p]=ttest(zsbetasLikeFRT);
if p<0.05
    plot(x,y,'Color', rgb('LimeGreen'))
else
    plot(x,y,'--','Color', rgb('LimeGreen'))
end
scatter_double_bars(LikbinFRT,RTBinFL,rgb('LimeGreen'));
ylabel('FGAT RESPONSE TIME (s)');
xlabel('LIKEABILITY RATING')
title({'EFFECT OF LIKEABILITY','ON FGAT RESPONSE TIME'})
hold off

%% B-left: PARTICIPANTS heatmap
% _________________________________________________________________________
% 1. prepare figure B-left

%store variable/participant
for n=1:length(sub_to_include)
    if sub_to_include(n)<10
        name_participant=['B_0' num2str(sub_to_include(n))];
    else
        name_participant=['B_' num2str(sub_to_include(n))];
    end
    [FGAT, Ratings]=get_CreHackData(name_participant);
    
    % create data heatmap
    heat=create_heatmap(Ratings.likeability,Ratings.adequacy,Ratings.originality,0:10:100);
    heat_all(n,1:10,1:10) = heat;
end
% _________________________________________________________________________
% 2. print figure B-left

figure;
set(gcf,'color','white')
imagesc(0:10:100,0:10:100,flip(squeeze(nanmean(heat_all,1))))
colormap(gca,'hot');
if use_pink_coloramp
    load('utils/colormap_likeability_heatmap.mat')
    colormap(colormap_likeability_heatmap)
end
h = colorbar;
h.FontSize=14;
title(h, 'LIKEABILITY RATING');
ylabel('ADEQUACY RATING');
xlabel('ORIGINALITY RATING');
set(gca,'FontSize',14,'Xtick',[],'Ytick',[])


%% B-right: FIT heatmap
% _________________________________________________________________________
% 1. prepare figure B-right

% fit the CES model to the data
[fit,alpha,delta]=do_CES_fit(sub_to_include);
mean_alpha=nanmean(alpha);
mean_delta=nanmean(delta);

% create fit heatmap
dimension=1:2;
fakeX=[];
ii=0;
for i=1:100
    for j=1:100
        ii=ii+1;
        fakeX(ii,1)=i;
        fakeX(ii,2)=j;
    end
end
u=fakeX(:,dimension)';
fake_rating=([mean_alpha*u(1,:).^mean_delta]+[(1-mean_alpha)*u(2,:).^mean_delta]).^(1/mean_delta);
heatFake = accumarray([fakeX(:,1) fakeX(:,2)],fake_rating,[],@nanmean,NaN);

% _________________________________________________________________________
% 2. print figure B-right

figure;
set(gcf,'color','white')
contourf(heatFake',15)
colormap('hot')
if use_pink_coloramp
    load('utils/colormap_likeability_heatmap.mat')
    colormap(colormap_likeability_heatmap)
end
ylabel('Adequacy');
xlabel('Originality');
set(gca,'FontSize',14,'Xtick',[0,100],'Ytick',[0,100])
h=colorbar;
title(h, 'SV');
title('FIT')



















