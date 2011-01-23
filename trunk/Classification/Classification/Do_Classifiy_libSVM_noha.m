function [svm_score,best_CV]=Do_Classifiy_libSVM_noha(opts,classification_opts)

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
%  labels=load(opts.labels)
 load(opts.testset)
 nclasses=opts.nclasses;
%  nimages=opts.nimages;
 labels=getfield(load(opts.labels),'labels');
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
 histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
 histogram_train=histogram(:,trainset>0);
 histogram_test=histogram(:,testset>0);
 
 [max1,labels_index]=max(labels,[],2);
 train_truth=labels_index(trainset>0);
 test_truth=labels_index(testset>0);
 
 size(histogram)
 size(histogram_train)
 size(histogram_test)
 
 %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
   switch (classification_opts.num_histogram)
       case 1
            %%%%%%% Cross Validation %%%%%%%%
                 %%% uncomment next line for intersection kernel %%%
%                [best_C,best_CV]=Do_CV_libSVM_fast(histogram_train',train_truth); 
%                [best_C,best_CV]=Do_CV_libSVM_ikmmulti(histogram_train',train_truth);
%% Histogram intersection kernel cross validation
[best_C,best_CV]=Do_CV_libSVM(histogram_train',train_truth);
%% chi square kernel cross validation
%                [best_C,best_G,best_CV]=Do_CV_libSVM_chisq(histogram_train',train_truth);
%% Histogram intersection kernel training and testing
%%% uncomment next line for intersection kernel %%%
 [predict_labels,svm_score]=Do_libSVM_fast_multi_noha(histogram_train',histogram_test',train_truth,test_truth,best_C);
%% Chi square kernel training and testing
%                [predict_labels,svm_score]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G); 
       case 2   
           %%%%%%%%% Load the Second Histogram %%%%%%%%%%
            histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'all_hist1');           
            histogram_total=[histogram;histogram2];
            
            histogram_train=histogram_total(:,trainset>0);
            [best_C,best_CV1]=Do_CV_libSVM(histogram_train',train_truth);
            [alpha,histogram_train,histogram_weight,best_C1,best_CV]=Do_learn_alpha_libSVM1(histogram_train',histogram_total,train_truth,best_C,1,size(histogram,1),size(histogram,1)+1,size(histogram2,1)+size(histogram,1),trainset);
            
            histogram_train_final=histogram_weight(:,trainset>0);
            histogram_test_final=histogram_weight(:,testset>0);
            [best_C1,best_CV1]=Do_CV_libSVM(histogram_train_final',train_truth);
            [predict_labels,svm_score]=Do_libSVM(histogram_train_final',histogram_test_final',train_truth,test_truth,best_C1);
   end
end

 











