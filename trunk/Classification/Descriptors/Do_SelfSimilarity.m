function descriptor_points=Do_SelfSimilarity(im,descriptor_name,image_dir)

im=imread(im);
im=im2double(im);
parms.size=5;
parms.coRelWindowRadius=40;
parms.numRadiiIntervals=3;
parms.numThetaIntervals=10;
parms.varNoise=25*3*36;
parms.autoVarRadius=1;
parms.saliencyThresh=0; % I usually disable saliency checking
parms.nChannels=size(im,3);

radius=(parms.size-1)/2; % the radius of the patch
marg=radius+parms.coRelWindowRadius;

[allXCoords,allYCoords]=meshgrid([marg+1:5:size(im,2)-marg],...
                                 [marg+1:5:size(im,1)-marg]);

allXCoords=allXCoords(:)';
allYCoords=allYCoords(:)';

% display('Computing self similarity descriptors\n');
[resp,drawCoords,salientCoords,uniformCoords]=ssimDescriptor(im ,parms ,allXCoords ,allYCoords);
descriptor_points=resp';
 save ([image_dir,'/',descriptor_name],'descriptor_points')


