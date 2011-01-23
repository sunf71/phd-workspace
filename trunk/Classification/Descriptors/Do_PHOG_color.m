function PHOG_result=Do_PHOG_color(im,descriptor_name,image_dir,points_detect,scale_magnif,normalize_patch_size)

%%%%%%%%%%%%%%  Read Image and Convert into Patches   %%%%%%%%%%%%%%%%%
im=imread(im);
im=im2double(im);
patches_out=normalize_features1(im,points_detect,normalize_patch_size,scale_magnif);

%%%%%%%%%%%%%% parameter settings %%%%%%%%%%%%%

bin = 10;
angle = 360;
L=1;
s=normalize_patch_size;
roi = [1;s;1;s];

I=zeros(s*s,3);

for i=1:size(patches_out,1)
    I(:,:)=patches_out(:,i,:);
%   descriptors(i,:) = anna_phog(reshape(I,s,s,3),bin,angle,L,roi);
     descriptors(i,:) = anna_phog_hsv(reshape(I,s,s,3),bin,angle,L,roi);
%     descriptors(i,:) = anna_phog_opp(reshape(I,s,s,3),bin,angle,L,roi);    
end

descriptor_points=descriptors;
PHOG_result=descriptor_points;
save ([image_dir,'/',descriptor_name],'descriptor_points')