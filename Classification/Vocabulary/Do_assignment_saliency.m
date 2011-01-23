function []=Do_assignment_saliency(opts,assignment_opts)
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
load(opts.data_locations);
nimages=opts.nimages;

%%%%%%%%% for only grid detector %%%%%
% grid_points1=getfield(load([opts.data_assignmentpath,'/','KmeansSIFT_Dorko_Grid_Dorko300_grid_points']),'grid_points_all'); 
%%%%%%%%% for normal 3 combined detectors %%%%%%%%
% grid_points1=getfield(load([opts.data_assignmentpath,'/','KmeansSIFT_Dorko_HarrLap300_all_points']),'grid_points_all');

 for i=2:nimages %%%%%%%% Outer loop of total number of images 
                    i
                    %%%% load the Detected Points %%%%%%
                     points_out_det=load([data_locations{i},'/',assignment_opts.detector_name]);
                     detector_points = getfield(points_out_det,'detector_points');
                     grid_points=[detector_points(:,1) detector_points(:,2)];
                     grid_points=floor(grid_points);

%                     grid_points=grid_points1{i};
                    %%%% load the image and compute Saliency Map based on Boosting 
                    im=sprintf('%s/%s',opts.imgpath,image_names{i});
                    im=imread(im);
                    im=im2double(im);
                   simg1=BoostScript(im);       %%%%% saliency based on boosting
%                     simg1=saliencyimage(im,1.5); %%%%%saliency based on natural image statistics
                    a=max(simg1(:));
                    sal_im1=simg1./a;
                    test2=reshape(sal_im1,size(sal_im1,1)*size(sal_im1,2),1);
                    index2=sub2ind([size(sal_im1,1),size(sal_im1,2)],grid_points(:,2),grid_points(:,1));
                    patch_im=test2(index2,:);
                    patch_saliency_all{i}=patch_im;

                   
                       
 end
 save ([opts.data_assignmentpath,'/','KmeansSIFT_Dorko_Grid_Dorko1300_aib300_saliency_points'],'patch_saliency_all');
 display('saliency of all images saved');
 pause