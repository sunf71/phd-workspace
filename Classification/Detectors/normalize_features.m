% function [patches]=normalize_features(opts,detector_file,imIndex,patch_size)
function [patches]=normalize_features(im,points,patch_size,scale_magnif)

% function normalizes patches to patch_size x patch_size
%
% input:
%              im_name      : name of image
%              detector_file: file containing detector_file
% output:
%              patches    : matrix of p x n x 3, with ( n = patch_size x patch_size ) of RGB-channels values patch
%                             and p is the number of patches.

% image_dir=sprintf('%s/%s/',opts.localdatapath,num2string(imIndex,3));                       % location detector
% im=read_image_db(opts,imIndex);
% points=getfield(load(sprintf('%s/%s',image_dir,detector_file)),'points');

points(:,3)=scale_magnif*points(:,3);

points_left=ones(size(points,1),1);         % a mask of feature_points which still have to be processed
points_index=(1:size(points,1));            % an index to the features
                              
counter=0;

patches =zeros(size(points,1),patch_size*patch_size,3);
while(sum(points_left))                     % as long as there are still points left to process
    counter=counter+1;
    selected_points = (1.5 * points(:,3) < patch_size *counter) & points_left;        % select points to process (selection is based on size)
    index = points_index(selected_points);
    
    for ii=1:numel(index)    
        x=points(index(ii),1);y=points(index(ii),2);s=points(index(ii),3);
        patch = fastAffineTransform( im, y-s,x-s , y+s, x-s, y-s, x+s, patch_size, patch_size, 'linear' );        % normalize patch
        patches(index(ii),:,1)=reshape(patch(:,:,1),patch_size*patch_size,1);
        patches(index(ii),:,2)=reshape(patch(:,:,2),patch_size*patch_size,1);
        patches(index(ii),:,3)=reshape(patch(:,:,3),patch_size*patch_size,1);        
        % imshow(patches{index(ii)/255}); % check patches
    end
        
    points_left=points_left - selected_points;
    if(sum(points_left))
       im=color_gauss(im,1,0,0);                                                % smooth image before rescaling larger patches to avoid aliasing
    end
end
