function [svm_score,valid_score]=Do_Classifiy(opts,classification_opts)

if nargin<2
    classification_opts=[];
end
display('Computing Classification');
if ~isfield(classification_opts,'assignment_name');       classification_opts.assignment_name='Unknown';       end
if ~isfield(classification_opts,'assignment_name');       classification_opts.assignment_name2='Unknown';      end
if ~isfield(classification_opts,'assignment_name');       classification_opts.assignment_name3='Unknown';      end
if ~isfield(classification_opts,'hist_combine_flag');     classification_opts.num_histogram='Unknown';         end
if ~isfield(classification_opts,'kernel_option');         classification_opts.kernel_option='Unknown';         end  %%% optins are : 'LBP_Var', 'LBP_Rot','LBP_Joint','LBP'
if ~isfield(classification_opts,'kernel');                classification_opts.kernel='Unknown';                end
if ~isfield(classification_opts,'perclass_images');       classification_opts.perclass_images='Unknown';       end
if ~isfield(classification_opts,'num_train_images');      classification_opts.num_train_images='Unknown';                 end


 %%%%%%%%% Load the Dataset Settings %%%%%%%%%%%
 load(opts.trainset)
 load(opts.testset)
 nclasses=opts.nclasses;
%  nimages=opts.nimages;
 
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
 histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
 histogram_train=histogram(:,trainset>0);
 histogram_test=histogram(:,testset>0);
 
 
 %%%%%%%%% for Training and Test GroundTruth %%%%%%%%%%%%%
 % For Training Set 
 train_truth=[];
     for jj=1:nclasses
        train_truth=[train_truth; jj*ones(classification_opts.num_train_images,1)];
     end
 %%% for groundTruth test
num_test=(classification_opts.perclass_images)-(classification_opts.num_train_images);
[xx,test_truth]=ndgrid(1:num_test,1:nclasses);

 %%%%%%%%%%%%% Do Classification %%%%%%%%%
 [svm_score,valid_score]=Do_SVM(histogram_train,histogram_test,train_truth,test_truth,classification_opts.kernel_option,classification_opts.kernel,nclasses,classification_opts.num_histogram); 

