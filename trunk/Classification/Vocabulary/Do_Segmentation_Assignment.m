function []=Do_Segmentation_Assignment(opts,assignment_opts)

load(opts.image_names);
load(opts.data_locations);
nimages=opts.nimages;

%%%%%%%% Load the image_names for Segmentation only images %%%%%%%%%%%%%%%%
load('/home/fahad/Datasets/Pascal_2007_Segmentation/VOCdevkit/VOC2007/Labels/image_names_seg.mat');
seg_im_locations=zeros(9963,1);
for itk=1:length(image_names_seg)
    a=image_names_seg{itk};
    ftt=strcmp(image_names,a);
    abc=find(ftt>0);
    seg_im_locations(abc,:)=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% vl_setup
%% Load Vocabulary
vocabulary=getfield(load([opts.data_vocabularypath,'/',assignment_opts.vocabulary_name]),'voc');
vocabulary=double(vocabulary');

%% Do Assignment
 for i=580:5000
     i
     %%%%%%%%%%%%%%%%% Load the Feature Descriptor %%%%%%%%%%%%%%%
     points_out=load([data_locations{i},'/',assignment_opts.descriptor_name]);
     feat_points = getfield(points_out,'descriptor_points');
     
     %%%%%%%%%%%%%%%% Load the Feature Detector %%%%%%%%%%%%%%%%
     points_out=load([data_locations{i},'/',assignment_opts.detector_name]);
     det_points = getfield(points_out,'detector_points');
     
     %%%%%%%%%%%%%%% Load Quick Shift segmentation Structure %%%%%%
     points_out=load([data_locations{i},'/',assignment_opts.features_seg_type]);
     seg_points = getfield(points_out,'segs');
     
     %%%%%%%%%%%%%%% Load Image for height and width %%%%%%%%%%%%%%
     imageread=imread(sprintf('%s/%s',opts.imgpath,image_names{i}));
     [m n p]      = size(imageread);    
     
     %%%%%%%%%%%%%% First extract the indexes from VOC and features (whole image) %%%%%%%%%%%%%%
     [minz index]=min(distance(double(feat_points),vocabulary),[],2);
     
     index_im=zeros(size(imageread,1),size(imageread,2));
     index_im(det_points(:,2)+(det_points(:,1)-1)*size(imageread,1))=index;
     
     %%%%%%%%%%%%%% Compute Histogram for all the super pixels %%%%%%%%%%%%%%
     SPhist=zeros(length(seg_points),assignment_opts.vocabulary_size);
     for ij=1:length(seg_points)
         
        histT=hist(index_im(seg_points(ij).ind),(0:assignment_opts.vocabulary_size));
        SPhist(ij,:) = histT(2:end);
     
%      index((det_points(:,1) > x_lo) & (det_points(:,1) <= x_hi) & ...
%                 (det_points(:,2) > y_lo) & (det_points(:,2) <= y_hi));
     end
     
     %%%%%%%%%%%%%% Get the bounding box information %%%%%%%%%%%%%%%%
     a=image_names{i};
     a=a(1:end-4);
     rec=PASreadrecord(sprintf(opts.annotationpath,a));
     %%%%%%%%%%%%%% Ground-truth of superpixels from Detection %%%%%%%%%%%%%%
     GT_det=LabelSP_detection(seg_points,rec,opts);
     
     %%%%%%%%%%%%%% Ground-truth of super-pixel from Segmentation %%%%%%%%%
     %%% The Ground-truth information is provided only for the segmentation images %%%
     if(seg_im_locations(i)==1)
         Seg_im=imread(sprintf(opts.seg.clsimgpath,a));
         GT_seg=LabelSP_segmentation(seg_points, Seg_im);
         
     else
         GT_seg=zeros(1,length(seg_points));
     end
         
     %%%%%%%%%%%%% for image segmentation labels %%%%%%%%%%%%%%%%
     ff=hist(GT_det(:),(1:21))>0;
     GT_cls=ff(1:end-1);
     
     %%%%%%%%%%%% Save the whole structure in each Image folder %%%%%%%%%%%%
     feat.hist=SPhist;
     feat.GT.det=GT_det;
     feat.GT.seg=GT_seg;
     feat.GT.cls=GT_cls;
     
     image_dir=data_locations{i};
     save ([image_dir,'/',a],'feat')

 end
 display('Structure Saved for all images');
 pause