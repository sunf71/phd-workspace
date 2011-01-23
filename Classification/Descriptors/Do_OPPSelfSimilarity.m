function descriptor_points=Do_OPPSelfSimilarity(im,descriptor_name,image_dir)

im=imread(im);
im=im2double(im);
[O1,O2,O3]=RGB2O(im);
%%
im=O1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%% For the First Channel %%%%%%%%%%%%%%%%%
parms.size=5;
parms.coRelWindowRadius=20;
parms.numRadiiIntervals=3;
parms.numThetaIntervals=10;
parms.varNoise=25*3*36;
parms.autoVarRadius=1;
parms.saliencyThresh=0; % I usually disable saliency checking
parms.nChannels=1;

radius=(parms.size-1)/2; % the radius of the patch
marg=radius+parms.coRelWindowRadius;

[allXCoords,allYCoords]=meshgrid([marg+1:5:size(im,2)-marg],...
                                 [marg+1:5:size(im,1)-marg]);

allXCoords=allXCoords(:)';
allYCoords=allYCoords(:)';

% display('Computing self similarity descriptors\n');
[resp,drawCoords,salientCoords,uniformCoords]=ssimDescriptor(im ,parms ,allXCoords ,allYCoords);
descriptor_points=resp;

%%
im=O2;
[resp,drawCoords,salientCoords,uniformCoords]=ssimDescriptor(im ,parms ,allXCoords ,allYCoords);
descriptor_points2=resp;
 descriptor_points=[descriptor_points;descriptor_points2];
%%
im=O3;
[resp,drawCoords,salientCoords,uniformCoords]=ssimDescriptor(im ,parms ,allXCoords ,allYCoords);
descriptor_points3=resp;
descriptor_points=[descriptor_points;descriptor_points3]/3;
descriptor_points=descriptor_points./(eps+ones(size(descriptor_points,1),1)*sum(descriptor_points));
descriptor_points=descriptor_points';
 save ([image_dir,'/',descriptor_name],'descriptor_points')


