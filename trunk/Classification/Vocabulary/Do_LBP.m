function descriptor_points=Do_LBP(img,image_dir,LBP_option)
%%% LBP_optins are : 'LBP_Var', 'LBP_Rot','LBP_Joint','LBP'
if(strcmp(LBP_option,'LBP'))
    mapping=getmapping(16,'riu2'); 
    im = imread(img);
    im=im2double(im);
    im=sum(im,3)/3;
    index = lbp(im,2,16,mapping,'h');
    descriptor_points=index;
    
elseif(strcmp(LBP_option,'LBP_Rot'))
 
    %%% Apply mapping %%%%
     mapping1=getmapping(8,'riu2'); 
    
    %%% convert the color image into grey level image %%%%
    im = imread(img);
    im=im2double(im);
    im=sum(im,3)/3;
    
    %% Apply LBP %%%
    index1 = lbp(im,1,8,mapping1,'h');
    
    %% for hybrid assignment we also need the lbp image %%
%     LBP_image=lbp(im,5,8,mapping1,'other');
%     LBP_image=LBP_image(:,:)+1;
    
    %% save the indexes %%%%
     descriptor_points=index1;
     
     
     %%%%% we also need to make the index vector to be used for pcp hybrid %%%%
%      index_image=reshape(LBP_image,size(LBP_image,1)*size(LBP_image,2),1);

elseif(strcmp(LBP_option,'LBP_HF'))
 
    im=imread(img);
    im=im2double(im);
    im=sum(im,3)/3;
    im2=imrotate(im,90);
    mapping=getmaplbphf(8);
    mapping1=getmaplbphf(16);
    
    h=lbp(im2,1,16,mapping1,'h');
    h=h/sum(h);
     histograms(1,:)=h;

    h=lbp(im2,2,8,mapping,'h');
    h=h/sum(h);
    histograms(2,:)=h;
    descriptor_points1=constructhf(histograms,mapping);
     descriptor_points=[descriptor_points1(1,:),descriptor_points1(1,:)];
end

save ([image_dir,'/',LBP_option], 'descriptor_points');
%%%% for hybrid fusion also save the LBP coded image instaead of the LBP hisotgram %%%%%%%
% save ([image_dir,'/','LBP_image'], 'LBP_image'); 

%%%% for hybrid fusion also save the LBP coded image instaead of the LBP hisotgram %%%%%%%
% save ([image_dir,'/','index_image'], 'index_image'); 
