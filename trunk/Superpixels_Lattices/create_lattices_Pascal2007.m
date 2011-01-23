function create_lattices_Pascal2007(width, height)

load('../image_names.mat');

for image_index = 9028:length(image_names)
    image_name = image_names{image_index};
    resImgName = ['../superpixelLattices_Results/' ...
        image_name(1:end-4) '_SP_w(' num2str(width) ')_h(' num2str(height) ').mat'];
    if exist(resImgName, 'file') == 2
        continue;
    end
    
    image_index
    
    img = rgb2gray(imread(['../JPEGImages/' image_name]));
    create_lattice(img, width, height, resImgName);
end