function [svm_score,best_CV]=Do_Classifiy_libSVM_demping(opts,classification_opts)

if nargin<2
    classification_opts=[];
end
display('Computing Classification');
if ~isfield(classification_opts,'assignment_name');       classification_opts.assignment_name='Unknown';       end
if ~isfield(classification_opts,'assignment_name2');       classification_opts.assignment_name2='Unknown';      end
if ~isfield(classification_opts,'assignment_name3');       classification_opts.assignment_name3='Unknown';      end
if ~isfield(classification_opts,'num_histogram');         classification_opts.num_histogram='Unknown';         end
% if ~isfield(classification_opts,'kernel_option');         classification_opts.kernel_option='Unknown';         end  
% if ~isfield(classification_opts,'kernel');                classification_opts.kernel='Unknown';                end
if ~isfield(classification_opts,'perclass_images');       classification_opts.perclass_images='Unknown';       end
if ~isfield(classification_opts,'num_train_images');      classification_opts.num_train_images='Unknown';                 end


 %%%%%%%%% Load the Dataset Settings %%%%%%%%%%%
 load(opts.trainset)
 load(opts.testset)
 nclasses=opts.nclasses;
%  nimages=opts.nimages;
 trainset1=trainset;
 testset1=trainset;
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
 histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
 trainset1(21:25,:)=0;trainset1(61:65,:)=0;trainset1(101:105,:)=0;trainset1(141:145,:)=0;trainset1(181:185,:)=0;
 trainset1(221:225,:)=0;trainset1(261:265,:)=0;trainset1(301:305,:)=0;trainset1(341:345,:)=0;trainset1(381:385,:)=0;
 
 
 testset1(1:20,:)=0;testset1(41:60,:)=0;testset1(81:100,:)=0;testset1(121:140,:)=0;testset1(161:180,:)=0;
 testset1(201:220,:)=0;testset1(241:260,:)=0;testset1(281:300,:)=0;testset1(321:340,:)=0;testset1(361:380,:)=0;
 
 trainset2=[trainset1(1:25,:);trainset1(41:65,:);trainset1(81:105,:);trainset1(121:145,:);trainset1(161:185,:);trainset1(201:225,:);trainset1(241:265,:);trainset1(281:305,:);trainset1(321:345,:);trainset1(361:385,:)];
 testset2=[testset1(1:25,:);testset1(41:65,:);testset1(81:105,:);testset1(121:145,:);testset1(161:185,:);testset1(201:225,:);testset1(241:265,:);testset1(281:305,:);testset1(321:345,:);testset1(361:385,:)];

 histogram_train=histogram{6}(:,trainset2>0);
 histogram_test=histogram{6}(:,testset2>0);
 
 
 %%%%%%%%% for Training and Test GroundTruth %%%%%%%%%%%%%
 % For Training Set 
 train_truth=[];
     for jj=1:nclasses
        train_truth=[train_truth; jj*ones(classification_opts.num_train_images,1)];
     end
 %%%%%%%%%%%% for groundTruth test %%%%%%%%%%%%%%%%%%%
num_test=(classification_opts.perclass_images)-(classification_opts.num_train_images);
test_truth=[];
% [xx,test_truth]=ndgrid(1:num_test,1:nclasses);
     for jj=1:nclasses
        test_truth=[test_truth; jj*ones(num_test,1)];
     end


 %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
   switch (classification_opts.num_histogram)
       case 1
            %%%%%%% Cross Validation %%%%%%%%
             [best_C,best_CV]=Do_CV_libSVM(histogram_train',train_truth);
            [svm_score]=Do_libSVM(histogram_train',histogram_test',train_truth,test_truth,best_C);            
       
    end

