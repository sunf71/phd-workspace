function [svm_score,best_CV]=Do_Classifiy_libSVM_multilayer1(opts,classification_opts)
%%% for more than 2 descriptors 

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
 labels=getfield(load(opts.labels),'labels');
%  nimages=opts.nimages;
 
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
   histogram1=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
             histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
             
%                  histogram2=normalize(histogram2,2);
%                  histogram2=normalize(histogram2,1);
%%% 3rd histogram %%%
histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');

%%% 4th histogram %%%
histogram4=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name4]),'All_hist');

 %%%%%% Separate the training and test histograms %%%%%                             
 histogram_trainf1=histogram1(:,trainset>0);
 histogram_testf1=histogram1(:,testset>0);
 
 histogram_trainf2=histogram2(:,trainset>0);
 histogram_testf2=histogram2(:,testset>0);
 
 %% to add 3rd descriptor %%%
 histogram_trainf3=histogram3(:,trainset>0);
 histogram_testf3=histogram3(:,testset>0);
 
 %% to add 4th descriptor %%%
 histogram_trainf4=histogram4(:,trainset>0);
 histogram_testf4=histogram4(:,testset>0);
 
 
 
 for i=1:nclasses  %% Loop over number of classes 
 
 %  %%%%%%%%% for Training  GroundTruth %%%%%%%%%%%%%
train_truth=zeros(size(labels,1),1);
a=(trainset.*(labels(:,i)==1))>0;
bcd=find(a==1);
train_truth(bcd,:)=1;
train_truth=train_truth(trainset>0,:);

%  %%%%%%%%%%%% for groundTruth test %%%%%%%%%%%%%%%%%%%
test_truth=zeros(size(labels,1),1);
a=(testset.*(labels(:,i)==1))>0;
bcd=find(a==1);
test_truth(bcd,:)=1;
test_truth=test_truth(testset>0,:);
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% First Level of Classification %%%%%%%%%%%%%%%%%%%%%%%%%%
   
          %%%%%% Feature Descriptor 1 %%%%%%%%%%%%%
            %%%% To compute Training Vector %%%%%%%
            [best_C,best_CV]=Do_CV_libSVM(histogram_trainf1',train_truth);
            [svm_scoref1,accuracyf1,dec_valf1]=Do_libSVM(histogram_trainf1',histogram_trainf1',train_truth,train_truth,best_C); 
            
          %%%%%% To Compute Test Vector %%%%%%%
            [svm_scoref1_test,accuracyf1_test,dec_valf1_test]=Do_libSVM(histogram_trainf1',histogram_testf1',train_truth,test_truth,best_C);  
          
          %%%%%%%%% Feature Descriptor 2 %%%%%%%%%%%%%%%
             %%%% To compute Training Vector %%%%%%%
            [best_C,best_CV]=Do_CV_libSVM(histogram_trainf2',train_truth);
            [svm_scoref2,accuracyf2,dec_valf2]=Do_libSVM(histogram_trainf2',histogram_trainf2',train_truth,train_truth,best_C);            
         
          %%%%%%%%%% To Compute Test vector %%%%%%%%%
           [svm_scoref2_test,accuracyf2_test,dec_valf2_test]=Do_libSVM(histogram_trainf2',histogram_testf2',train_truth,test_truth,best_C);  
           
%           %%%%%%%%%% Store Train Vector for both features %%%%%%%%%%% 
%             class_prob1_train{i}=[dec_valf1,dec_valf2];
%             
%             %%% Store test Vector for both Features %%%%
%             class_prob1_test{i}=[dec_valf1_test,dec_valf2_test];
            
            
            %%%%%%%%% Feature Descriptor 3 %%%%%%%%%%%%%%%
             %%%% To compute Training Vector %%%%%%%
            [best_C,best_CV]=Do_CV_libSVM(histogram_trainf3',train_truth);
            [svm_scoref3,accuracyf3,dec_valf3]=Do_libSVM(histogram_trainf3',histogram_trainf3',train_truth,train_truth,best_C);            
         
          %%%%%%%%%% To Compute Test vector %%%%%%%%%
           [svm_scoref3_test,accuracyf3_test,dec_valf3_test]=Do_libSVM(histogram_trainf3',histogram_testf3',train_truth,test_truth,best_C);  
           
           
           
            %%%%%%%%% Feature Descriptor 4 %%%%%%%%%%%%%%%
             %%%% To compute Training Vector %%%%%%%
             [best_C,best_CV]=Do_CV_libSVM(histogram_trainf4',train_truth);
             [svm_scoref4,accuracyf4,dec_valf4]=Do_libSVM(histogram_trainf4',histogram_trainf4',train_truth,train_truth,best_C);            
%          
%           %%%%%%%%%% To Compute Test vector %%%%%%%%%
            [svm_scoref4_test,accuracyf4_test,dec_valf4_test]=Do_libSVM(histogram_trainf4',histogram_testf4',train_truth,test_truth,best_C);  
           
           
           
           
          %%%%%%%%%% Store Train Vector for both features %%%%%%%%%%% 
            class_prob1_train{i}=[dec_valf1,dec_valf2,dec_valf3,dec_valf4];
            
            %%% Store test Vector for both Features %%%%
            class_prob1_test{i}=[dec_valf1_test,dec_valf2_test,dec_valf3_test,dec_valf4_test];
            
            
            
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Second Level of Classification %%%%%%%%%%%%%%%%%%%%%%%%%%   
 
            %%%%%% Feature Descriptor 1 %%%%%%%%%%%%%
                %%%% To compute Training Vector %%%%%%%
            [best_C,best_CV]=Do_CV_libSVM(class_prob1_train{i},train_truth);
            [svm_scoref1_stage2,accuracyf1_stage2,dec_valf1_stage2]=Do_libSVM(class_prob1_train{i},class_prob1_train{i},train_truth,train_truth,best_C); 
  
            %%%%%% To Compute Test Vector %%%%%%%
            [svm_scoref1_test_stage2,accuracyf1_test_stage2,dec_valf1_test_stage2]=Do_libSVM(class_prob1_train{i},class_prob1_test{i},train_truth,test_truth,best_C);
 
            %%%%%% Save the second stage vectors %%%%
            class_prob2_train{i}=dec_valf1_stage2;
            
            %%%%%% Save the test vector of second stage %%%%%%%
            class_prob2_test{i}=dec_valf1_test_stage2;
 
 end

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Final Stage of classification %%%%%%%%%%%%%%%%%%%%%%%%
 [max1,labels_index]=max(labels,[],2);
 train_truth_final=labels_index(trainset>0);
 test_truth_final=labels_index(testset>0);
 
 final_train=[class_prob2_train{:}];
 final_test=[class_prob2_test{:}];
 
 [best_C,best_CV]=Do_CV_libSVM_final(final_train,train_truth_final);
 [svm_score]=Do_libSVM_final(final_train,final_test,train_truth_final,test_truth_final,best_C);