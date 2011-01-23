function descriptor_points= Do_GIST_BOW(im,descriptor_name,image_dir,points,scale_magnif,normalize_patch_size)
im=imread(im);
image=im2double(im);
orientationsPerScale = [8 8 4];
numberBlocks = 4;
s=normalize_patch_size;
% I=zeros(s*s,3);

% descriptor_points1=zeros(size(points,1),960);

% if(size(im,1)>size(im,2))
%         
%         image = imresize(im, [size(im,1) size(im,1)]);
% else
%         image = imresize(im, [size(im,2) size(im,2)]);
% end

patches_out=normalize_features1(image,points,normalize_patch_size,scale_magnif);
% tic;
% for i=1:size(patches_out,2)
%     
% I(:,:)=patches_out(:,i,:);
% reshape_patch=reshape(I,s,s,3);
% G = createGabor(orientationsPerScale, s);
% 
% % Computing gist requires 1) prefilter image, 2) filter image and collect
% % output energies
% 
% output = prefilt(reshape_patch, 4);
% g = gistGabor(output, numberBlocks, G);
% 
% descriptor_points1(i,:)=g;
% end
% toc;
% descriptor_points=descriptor_points1;
% 
%  save ([image_dir,'/',descriptor_name],'descriptor_points');

tic;
%%%%%%%%%%%%%%%% faster Version %%%%%%%%%%%%%%%
new_dim=reshape(patches_out,[size(patches_out,1) size(patches_out,3) size(patches_out,2)]);
reshape_patch1234=reshape(new_dim,s,s,3,size(new_dim,3));
G = createGabor(orientationsPerScale, s);
output = prefilt(reshape_patch1234, 4);
g = gistGabor(output, numberBlocks, G);
descriptor_points=g';
toc;
save ([image_dir,'/',descriptor_name],'descriptor_points');