function PHOG_result=Do_PHOG_Patch(im)
% %%%% Parameter settings %%%%
% image=imread(im);
% bin = 8;
% angle = 360;
% L=3;
% roi = [1;size(image,1);1;size(image,2)];
% 
% %%%% compute PHOG %%%%%
% p = anna_phog(im,bin,angle,L,roi);
% 
% 
% descriptor_points=p;
% PHOG_result=descriptor_points;
% save ([image_dir,'/',descriptor_name],'descriptor_points')



%%%% Parameter settings %%%%
image=im;
bin = 10;
angle = 360;
L=2;
roi = [1;size(image,1);1;size(image,2)];

%%%%%%%%% Compute P HOG uptill L %%%%%%%%%
p = Patch_anna_phog(image,bin,angle,L,roi);

descriptor_points=p;





PHOG_result=descriptor_points;
