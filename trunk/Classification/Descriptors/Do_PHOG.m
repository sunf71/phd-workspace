function PHOG_result=Do_PHOG(im,descriptor_name,image_dir)
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
image=imread(im);
bin = 20;
angle = 360;
L=1;
roi = [1;size(image,1);1;size(image,2)];

%%%%%%%%% Compute P HOG uptill L %%%%%%%%%
p = anna_phog(image,bin,angle,L,roi);

descriptor_points=p;



% %%%% compute PHOG %%%%%
% p1 = anna_phog(im,bin,angle,L,roi);
% 
% 
% descriptor_points=p1;
% 
% L=1;
% p2= anna_phog(im,bin,angle,L,roi);
% 
% descriptor_points=[descriptor_points;p2];
% 
% L=2;
% p3= anna_phog(im,bin,angle,L,roi);
% 
% descriptor_points=[descriptor_points;p3];
% 
% L=3;
% p4= anna_phog(im,bin,angle,L,roi);
% descriptor_points=[descriptor_points;p4];
% descriptor_points=descriptor_points./(eps+ones(size(descriptor_points,1),1)*sum(descriptor_points));

PHOG_result=descriptor_points;
save ([image_dir,'/',descriptor_name],'descriptor_points')