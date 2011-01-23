function []=Do_assignment_saliency_Pascal(opts,assignment_opts)
if nargin<2
    assignment_opts=[];
end
display('Computing Assignments');
if ~isfield(assignment_opts,'LBP_flag');           assignment_opts.LBP_flag=0;                     end
if ~isfield(assignment_opts,'LBP_option');         assignment_opts.LBP_option='LBP';               end  %%% optins are : 'LBP_Var', 'LBP_Rot','LBP_Joint','LBP'
if ~isfield(assignment_opts,'type');               assignment_opts.type='hard';                    end
if ~isfield(assignment_opts,'vocabulary_name');    assignment_opts.vocabulary_name='Unknown';      end
if ~isfield(assignment_opts,'descriptor_name');    assignment_opts.descriptor_name='Unknown';      end

if(assignment_opts.LBP_flag)
           if ~isfield(assignment_opts,'name');    assignment_opts.name=assignment_opts.LBP_option; end
else
           if ~isfield(assignment_opts,'name');    assignment_opts.name=strcat(assignment_opts.type,assignment_opts.vocabulary_name); end
end

%if ~isfield(assignment_opts,'detector_type');      assignment_opts.detector_type='Grid';                                              end
%if ~isfield(assignment_opts,'descriptor_type');    assignment_opts.descriptor_type='SIFT';                                            end
%if ~isfield(assignment_opts,'vocabulary_type');    assignment_opts.vocabulary_type='Kmeans';                                          end
%if ~isfield(assignment_opts,'vocabulary_size');    assignment_opts.vocabulary_size=50;                                                end

try
    assignment_opts2=getfield(load([opts.data_assignmentpath,'/',assignment_opts.name,'_settings']),'assignment_opts');
    if(isequal(assignment_opts,assignment_opts2))
        display('Recomputing assignments for this settings');
    else
        display('Overwriting assignment with same name, but other Assignment settings !!!!!!!!!!');
    end
end

load(opts.image_names);
labels=getfield(load(opts.labels),'labels');
load(opts.data_locations);
nimages=opts.nimages;

%%%%%%%%% for only grid detector %%%%%
% grid_points1=getfield(load([opts.data_assignmentpath,'/','KmeansSIFT_Dorko_Grid_Dorko300_grid_points']),'grid_points_all'); 
%%%%%%%%% for normal 3 combined detectors %%%%%%%%
% grid_points1=getfield(load([opts.data_assignmentpath,'/','KmeansSIFT_Dorko_HarrLap300_all_points']),'grid_points_all');

 for i=1:nimages %%%%%%%% Outer loop of total number of images 
%      if(labels(i,19)==1)
i
                    display('Start computing bottom-up saliency');
                    %%%% load the Detected Points %%%%%%
                    points_out=load([data_locations{i},'/',assignment_opts.detector_name]);
                    points_det1 = getfield(points_out,'detector_points'); 
                    points_out_det2=load([data_locations{i},'/',assignment_opts.detector_name2]);
                    points_det2 = getfield(points_out_det2,'detector_points'); 
                    points_out_det3=load([data_locations{i},'/',assignment_opts.detector_name3]);
                    points_det3 = getfield(points_out_det3,'detector_points'); 
                    points_out_det4=load([data_locations{i},'/',assignment_opts.detector_name4]);
                    points_det4 = getfield(points_out_det4,'detector_points'); 
                    points_out_det5=load([data_locations{i},'/',assignment_opts.detector_name5]);
                    points_det5 = getfield(points_out_det5,'detector_points'); 
%                     %%%%%%%%%%%%% combine all points %%%%%%%%%%%%%
                     All_points=[points_det1(:,1:2);points_det2(:,1:2);points_det3(:,1:2);points_det4(:,1:2);points_det5(:,1:2)];
                     grid_points=floor(All_points);
                     size(All_points)
                     

%                     grid_points=grid_points1{i};
                    %%%% load the image and compute Saliency Map based on Boosting 
                    im=sprintf('%s/%s',opts.imgpath,image_names{i});
                    im=imread(im);
%                     put(im,1)
                    im=im2double(im);
                   simg1=BoostScript(im);       %%%%% saliency based on boosting
%                     simg1=saliencyimage(im,1.5); %%%%%saliency based on natural image statistics
                    a=max(simg1(:));
                    sal_im1=simg1./a;
                    test2=reshape(sal_im1,size(sal_im1,1)*size(sal_im1,2),1);
                    index2=sub2ind([size(sal_im1,1),size(sal_im1,2)],grid_points(:,2),grid_points(:,1));
                    patch_im=test2(index2,:);
                    patch_saliency_all{i}=patch_im;
                 
% put(simg1,2)
% put(sal_im1,3)
%      end    
                       
 end
%  save ([opts.data_assignmentpath,'/','ikmeansSIFT_Dorko_Grid_Dorko12000_saliency_points_10001_13704'],'patch_saliency_all');
save ([opts.data_assignmentpath,'/','fastkmeansSIFT_Dorko_LoG_MS1200_aib300_saliency_points'],'patch_saliency_all');
 display('saliency of all images saved');
 pause