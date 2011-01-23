%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This function returns an image where every isolated segment has a 
%  different value. Hence, instead of having a value for the chromaticity
%  of a segment, we have a value where spatial coherence is involved.
%
%  CALL: 
%    imRegions = labelIsolatedSegments ( segmentedImage )
%
%  INPUT: 
%   segmentedImage: segmented or fusioned image.
%
%  OUTPUT:
%   imRegions: An image with the same number of segments of segmentImage,
%   but having the segments labeled by its spatial positions instead of by
%   its chromaticity. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function imRegions=labelIsolatedSegments(segmentedImage)

numOfRegions = 0;
imRegions = zeros(size(segmentedImage));
cols = sort(unique(segmentedImage));

if min(cols)==0
    indexIni=2;
else
    indexIni=1;
end


for i = indexIni:numel(cols)
  [imTmp l] = bwlabeln(segmentedImage == cols(i));
  imTmp(imTmp>0)=imTmp(imTmp>0)+numOfRegions;
  numOfRegions = numOfRegions+l;
  imRegions = imRegions+imTmp;
end