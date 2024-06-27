function scatter_double_bars(x,y,varargin)
if nargin>2
    col=varargin{1};
else
    col='k';
end
 
    scatter(nanmean(x),nanmean(y),80,col,'filled','s')
hold on
errorbar(nanmean(x),nanmean(y),nanstd(y)/sqrt(length(y(:,1))-1),'.','color',col)
hold on
herrorbar(nanmean(x),nanmean(y),nanstd(x)/sqrt(length(x(:,1))-1),nanstd(x)/sqrt(length(x(:,1))-1),'.k')
hold on
scatter(nanmean(x),nanmean(y),80,col,'filled','o','MarkerEdgeColor',col)