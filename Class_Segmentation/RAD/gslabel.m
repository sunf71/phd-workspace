function labIm = gslabel(im)
% This function will get a gray scale image and label it in the same way
% that bwlabel will do but instead will look at the connected pixels of
% the same value
%
% USAGE:
% labelledIm = gslabel(grayScaleImage);

    labIm = zeros(size(im, 1), size(im, 2));
    unQ = unique(im(:));

    for pVal = 1:length(unQ)
        pIm = (im == unQ(pVal));
        labPIm = bwlabel(pIm);
        labPIm = labPIm + max(labIm(:));
        labPIm = labPIm .* pIm;
        labIm = max(labIm, labPIm);
    end

end