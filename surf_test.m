original = rgb2gray (imread('Intel RealSense D435I_2023_10_13_19_51_08.png'));
next = rgb2gray (imread('Intel RealSense D435I_2023_10_13_19_51_17.png'));

ptsOriginal = detectSURFFeatures(original);
ptsNext = detectSURFFeatures(next);

[featuresOriginal, validPtsOriginal] = extractFeatures(original,ptsOriginal);
[featuresNext, validPtsNext] = extractFeatures(next,ptsNext);

indexPairs = matchFeatures(featuresOriginal,featuresNext);
matchedOriginal = validPtsOriginal(indexPairs(:,1));
matchedNext = validPtsNext(indexPairs(:,2));

figure;
showMatchedFeatures(original,next,matchedOriginal,matchedNext,'montage');

[tform,inlierNext,inlierOriginal] = estimateGeometricTransform (matchedNext,matchedOriginal,'similarity');

figure;
showMatchedFeatures(original,next,inlierOriginal,inlierNext,'montage');
title('Matching point (inliers only)');
legend ('ptsOriginal','ptsNext');

Tinv = tform.invert.T;
ss = Tinv(2,1);
sc = Tinv(1,1);
scaleRecovered = sqrt(ss*ss+sc*sc);
thetaRecovered = atan2(ss,sc)*180/pi;

outputView = imref2d(size(original));
recovered = imwarp(next,tform,'OutputView',outputView);
figure;
imshowpair(original,recovered,'montage');