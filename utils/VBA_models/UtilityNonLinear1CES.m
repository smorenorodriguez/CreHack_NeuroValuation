function Likeability=UtilityNonLinear1CES(x,param,u,xx)

originality=u(1,:);
efficiency=u(2,:);


alpha=1./(1+exp(-param(1))); %forcing alpha to be btw 0 and 1 bc we want to use it for (1-alpha just below)
curvature=param(2);

Likeability  = ([alpha*originality.^curvature]+[(1-alpha)*efficiency.^curvature]).^(1/curvature) ;
% curvature > 1 <=> exponentiel => préférence concave, préfèrent les extremes
% curvature < 1 => convexe, préfèrent les compromis·
% =1 => modèle linéaire