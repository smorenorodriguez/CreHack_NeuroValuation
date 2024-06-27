function do_colormap_FirstDistant(squeezedProp)
%written by SMR
%last update 22/05/2024

colormap_FirstDistant = zeros(256, 3);
maxColor=[0,0.8,0.8];
equivColor=[0.4,0.8,0.1];
minColor=[0.2,0.5,0.2];
zeroColor=[1,1,1];
maxFirst=max(max(squeezedProp));
minDist=min(min(squeezedProp));
rangecolormap=linspace(maxFirst,minDist,  256);
idx_equivalentDist=find(abs(rangecolormap+maxFirst)==min(abs(rangecolormap+maxFirst)),1);
idx_zeroProp=find(abs(rangecolormap)==min(abs(rangecolormap)),1);
for i = 1:3
    colormap_FirstDistant(1:idx_zeroProp-2, i) = linspace(maxColor(i), zeroColor(i),idx_zeroProp-2);
    colormap_FirstDistant(idx_zeroProp-1:idx_zeroProp+1,i) = zeroColor(i);
    colormap_FirstDistant(idx_zeroProp+2:idx_equivalentDist,i) = linspace(zeroColor(i), equivColor(i),length(idx_zeroProp+2:idx_equivalentDist));
    colormap_FirstDistant(idx_equivalentDist+1:256,i) = linspace(equivColor(i), minColor(i),length(idx_equivalentDist+1:256));;
end
colormap_FirstDistant=flip(colormap_FirstDistant);
save([pwd '/utils/colormap_FirstDistant.mat'],'colormap_FirstDistant')
