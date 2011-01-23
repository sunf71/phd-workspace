function [svm_score,best_CV]=Do_Classifiy_libSVM(opts,classification_opts)

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
 labels=getfield(load(opts.labels),'labels');
 load(opts.trainset)
 load(opts.testset)
 nclasses=opts.nclasses;

 [max1,labels_index]=max(labels,[],2);
 
train_truth=labels_index(trainset>0);
test_truth=labels_index(testset>0);











%  nimages=opts.nimages;
 
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
 histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
%  histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
%  histogram=[(0.1).*histogram1;(0.9).*histogram2];
 

 
%  [max1,max2]=max(labels,[],2);
%  
%  nfold=7;
%  [train_truth,test_truth]=train_test_split(max2,nfold);
  histogram_train=histogram(:,trainset>0);
 histogram_test=histogram(:,testset>0);

%  histogram_train=histogram(:,trainset>0);
%  histogram_test=histogram(:,testset>0);
%  
%  
%  %%%%%%%%% for Training and Test GroundTruth %%%%%%%%%%%%%
%  % For Training Set 
%  train_truth=[];
%      for jj=1:nclasses
%         train_truth=[train_truth; jj*ones(classification_opts.num_train_images,1)];
%      end
%  %%%%%%%%%%%% for groundTruth test %%%%%%%%%%%%%%%%%%%
% num_test=(classification_opts.perclass_images)-(classification_opts.num_train_images);
% test_truth=[];
% % [xx,test_truth]=ndgrid(1:num_test,1:nclasses);
%      for jj=1:nclasses
%         test_truth=[test_truth; jj*ones(num_test,1)];
%      end


 %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
   switch (classification_opts.num_histogram)
       case 1
            %%%%%%% Cross Validation %%%%%%%%
            [best_C,best_G,best_CV]=Do_CV_libSVM_chisq(histogram_train',train_truth);
%               [svm_score]=Do_libSVM_fast_multi(histogram_train',histogram_test',train_truth,test_truth,best_C); 
            [svm_score]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G);
       case 2
%            %%%%%%%%% Load the Second Histogram %%%%%%%%%%
%             histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
%             histogram_total=[histogram;histogram2];
%             histogram_train=histogram_total(:,trainset>0);
%             [best_C,best_CV]=Do_CV_libSVM(histogram_train',train_truth);
%             [alpha,histogram_train,histogram_weight]=Do_learn_alpha_libSVM(histogram_train',histogram_total,train_truth,best_C,1,size(histogram,1),size(histogram,1)+1,size(histogram2,1)+size(histogram,1),trainset);
%             
%             histogram_train_final=histogram_weight(:,trainset>0);
%             histogram_test_final=histogram_weight(:,testset>0);
%             [best_C1,best_CV1]=Do_CV_libSVM(histogram_train_final',train_truth);
%             [svm_score]=Do_libSVM(histogram_train_final',histogram_test_final',train_truth,test_truth,best_C1);


  %%%%%%%%% Load the Second Histogram %%%%%%%%%%
            histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'all_hist1');
            
            %%%% only uncomment if combining late and early fusion %%%
              histogram=normalize(histogram,2);
              histogram=normalize(histogram,1);

            histogram_total=[histogram;histogram2];
            
           
            
            histogram_train=histogram_total(:,trainset>0);
            [best_C,best_CV1]=Do_CV_libSVM(histogram_train',train_truth);
            [alpha,histogram_train,histogram_weight,best_C1,best_CV]=Do_learn_alpha_libSVM1(histogram_train',histogram_total,train_truth,best_C,1,size(histogram,1),size(histogram,1)+1,size(histogram2,1)+size(histogram,1),trainset);
            
            histogram_train_final=histogram_weight(:,trainset>0);
            histogram_test_final=histogram_weight(:,testset>0);
%              [best_C1,best_CV1]=Do_CV_libSVM(histogram_train_final',train_truth);
            [predict_labels,svm_score]=Do_libSVM(histogram_train_final',histogram_test_final',train_truth,test_truth,best_C1);




       case 3
              %%%%%%%%% Load the Second Histogram %%%%%%%%%%
            %%%%%%%%% Load the Second Histogram %%%%%%%%%%
            histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'all_hist1');
            histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
                histogram=normalize(histogram,2);
                histogram=normalize(histogram,1);
            
            histogram_total=[histogram;histogram2;histogram3];
            histogram_train=histogram_total(:,trainset>0);
            [best_C,best_CV]=Do_CV_libSVM(histogram_train',train_truth);
            [alpha,histogram_train,histogram_weight,best_C1]=Do_learn_alpha_libSVM1(histogram_train',histogram_total,train_truth,best_C,1,size(histogram,1),size(histogram,1)+1,size(histogram2,1)+size(histogram,1),trainset);
            
            %%%% Do with second and third feature %%%%%%%
             [alpha2,histogram_train,histogram_weight,best_C1]=Do_learn_alpha_libSVM1(histogram_train,histogram_weight,train_truth,best_C,1,size(histogram2,1)+size(histogram,1),size(histogram2,1)+size(histogram,1)+1,size(histogram2,1)+size(histogram,1)+size(histogram3,1),trainset);
%             [histogram_train,histogram_weight,alpha2]=learn_alpha(histogram_train,histogram_weight,c,lambda,train_truth,nclasses,classification_opts.kernel,classification_opts.kernel_option,classification_opts.verbose,1,size(histogram2,1)+size(histogram,1),size(histogram2,1)+size(histogram,1)+1,size(histogram2,1)+size(histogram,1)+size(histogram3,1));
            
            histogram_train_final=histogram_weight(:,trainset>0);
            histogram_test_final=histogram_weight(:,testset>0);
%              [best_C1,best_CV1]=Do_CV_libSVM(histogram_train_final',train_truth);
            [svm_score]=Do_libSVM(histogram_train_final',histogram_test_final',train_truth,test_truth,best_C1);
           
   end
 end

