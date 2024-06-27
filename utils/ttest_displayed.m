function [te,t,p]=ttest_displayed(varargin)

[~,p,~,stat]=ttest(varargin{:});

df=stat.df;
t=stat.tstat;

te=['t(' num2str(stat.df) ')=' num2str(stat.tstat) ', p=' num2str(p)];
display(['t(' num2str(stat.df) ')=' num2str(stat.tstat) ', p=' num2str(p)]);