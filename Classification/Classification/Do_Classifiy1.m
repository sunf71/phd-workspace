function [svm_score,class_score,valid_score]=Do_Classifiy1(opts,classification_opts)

if nargin<2
    classification_opts=[];
end
display('Computing Classification');
if ~isfield(classification_opts,'assignment_name');       classification_opts.assignment_name='Unknown';       end
if ~isfield(classification_opts,'assignment_name2');       classification_opts.assignment_name2='Unknown';      end
if ~isfield(classification_opts,'assignment_name3');       classification_opts.assignment_name3='Unknown';      end
if ~isfield(classification_opts,'num_histogram');         classification_opts.num_histogram='Unknown';         end
if ~isfield(classification_opts,'kernel_option');         classification_opts.kernel_option='Unknown';         end  %%% optins are : 'LBP_Var', 'LBP_Rot','LBP_Joint','LBP'
if ~isfield(classification_opts,'kernel');                classification_opts.kernel='Unknown';                end
if ~isfield(classification_opts,'perclass_images');       classification_opts.perclass_images='Unknown';       end
if ~isfield(classification_opts,'num_train_images');      classification_opts.num_train_images='Unknown';      end


 %%%%%%%%% Load the Dataset Settings %%%%%%%%%%%
 load(opts.trainset)
 load(opts.testset)
 nclasses=opts.nclasses;
%  nimages=opts.nimages;
 
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
 histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),classification_opts.histogram1_name);
 
 %%%%%%%%%%% Normalize If reuqired %%%%%%%%
%  histogram=normalize(histogram,2);
%  histogram=normalize(histogram,1);
 
 %%%%%%%%%% Divide into test and train histograms %%%%%%%%%%%%
 histogram_train=histogram(:,trainset>0);
 histogram_test=histogram(:,testset>0);
 
 
 %%%%%%%%% for Training and Test GroundTruth %%%%%%%%%%%%%
 % For Training Set 
 train_truth=[];
     for jj=1:nclasses
        train_truth=[train_truth; jj*ones(classification_opts.num_train_images,1)];
     end
 %%%%%%%%% for groundTruth test %%%%%%%%%%%%%%%%%%%
num_test=(classification_opts.perclass_images)-(classification_opts.num_train_images);
[xx,test_truth]=ndgrid(1:num_test,1:nclasses);



 %%%%%%%%%%%%% Do Classification %%%%%%%%%
   switch (classification_opts.num_histogram)
       case 1
            %%%%%%% Cross Validation %%%%%%%%
               [c,lambda,valid_score]=cross_validate(histogram_train',train_truth,nclasses,classification_opts.kernel,classification_opts.kernel_option,classification_opts.verbose); 
            
           [svm_score,class_score]=Do_SVM(histogram_train,histogram_test,train_truth,test_truth,classification_opts.kernel_option,classification_opts.kernel,nclasses,c,lambda,classification_opts.verbose); 
       case 2
           %%%%%%%%% Load the Second Histogram %%%%%%%%%%
            histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),classification_opts.histogram1_name);
            histogram_total=[histogram;histogram2];
            
           %%%%%%%%% Normalize the histogram_total %%%%%%% 
%              histogram_total=normalize(histogram_total,2);
%              histogram_total=normalize(histogram_total,1);
            
            %%%%%%%%% Get the training set from total histogram for Cross_validation and Alpha Tuning %%%%%%%%%%%%%%%%%%
            histogram_train=histogram_total(:,trainset>0);
            
            %%%%%%%%% Cross-Validation %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [c,lambda,valid_score]=cross_validate(histogram_train',train_truth,nclasses,classification_opts.kernel,classification_opts.kernel_option,classification_opts.verbose);
            
            %%%%%%%%% Tuning the Alpha between Histogram 1 and histogram 2 %%%%%%%%%%%%%%%
            [histogram_train,histogram_weight,alpha]=learn_alpha(histogram_train',histogram_total,c,lambda,train_truth,nclasses,classification_opts.kernel,classification_opts.kernel_option,classification_opts.verbose,1,size(histogram,1),size(histogram,1)+1,size(histogram2,1)+size(histogram,1));             
            
            %%%%%%%%% The output of first alpha tuning (histogram_train) should be normalized.%%%%%%%%%
            %%%%%%%%% Note that the alpha tuning (histogram_train) gives output which is a transpose of the original histogram. 
            %%%%%%%%% So the normalization should be in 2nd direction.%%%%%%%%%%%.
             
%              histogram_train=normalize(histogram_train,2);
%              histogram_weight=normalize(histogram_weight,1);
            
            %%%%%%%%% Do the final Cross-Validation %%%%%%%%%%%%%%%
            [c1,lambda1,valid_score]=cross_validate(histogram_train,train_truth,nclasses,classification_opts.kernel,classification_opts.kernel_option,classification_opts.verbose);
            
            %%%%%%%%% divide the histogram into train and test %%%%%%%%
            histogram_train_final=histogram_weight(:,trainset>0);
            histogram_test_final=histogram_weight(:,testset>0);
            
            %%%%%%%%% Complete the final SVM_Score %%%%%%%%%%%%%%%%
            [svm_score,class_score]=Do_SVM(histogram_train_final,histogram_test_final,train_truth,test_truth,classification_opts.kernel_option,classification_opts.kernel,nclasses,c1,lambda1,classification_opts.verbose); 
       case 3
              %%%%%%%%% Load the Third Histogram %%%%%%%%%%
            histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),classification_opts.histogram1_name);
            histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),classification_opts.histogram3_name);
            histogram_total=[histogram;histogram2;histogram3];
            
            %%%%%%%%% Normalize the histogram_total %%%%%%% 
%             histogram_total=normalize(histogram_total,2);
%             histogram_total=normalize(histogram_total,1);
            
            %%%%%%%%% Get the training set from total histogram for Cross_validation and Alpha Tuning %%%%%%%%%%%%%%%%%%
            histogram_train=histogram_total(:,trainset>0);
            
            %%%%%%%%% Cross-Validation %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [c,lambda,valid_score]=cross_validate(histogram_train',train_truth,nclasses,classification_opts.kernel,classification_opts.kernel_option,classification_opts.verbose);
            
            %%%%%%%%% Tuning the first Alpha between Histogram 1 and histogram 2 %%%%%%%%%%%%%%%
            [histogram_train,histogram_weight,alpha]=learn_alpha(histogram_train',histogram_total,c,lambda,train_truth,nclasses,classification_opts.kernel,classification_opts.kernel_option,classification_opts.verbose,1,size(histogram,1),size(histogram,1)+1,size(histogram2,1)+size(histogram,1));
            
            %%%%%%%%% The output of first alpha tuning (histogram_train) should be normalized.%%%%%%%%%
            %%%%%%%%% Note that the alpha tuning (histogram_train) gives output which is a transpose of the original histogram. 
            %%%%%%%%% So the normalization should be in 2nd direction. %%%%%%%%%%%.
%               histogram_train=normalize(histogram_train,2); 
            

            %%%%%%%%% The 2nd alpha tuning between histgoram1,2 and histogram 3 %%%%%%%%%%
            [histogram_train,histogram_weight,alpha2]=learn_alpha(histogram_train,histogram_weight,c,lambda,train_truth,nclasses,classification_opts.kernel,classification_opts.kernel_option,classification_opts.verbose,1,size(histogram2,1)+size(histogram,1),size(histogram2,1)+size(histogram,1)+1,size(histogram2,1)+size(histogram,1)+size(histogram3,1));
            
            %%%%%%%%% Normalize the histogram_train again as it is weighted now. Also normalize the complete 'histogram_weight %%%%%%%%% 
%              histogram_train=normalize(histogram_train,2);  
%              histogram_weight=normalize(histogram_weight,1); 
            
            %%%%%%%%% Do the final Cross-Validation %%%%%%%%%%%%%%%
            [c1,lambda1,valid_score]=cross_validate(histogram_train,train_truth,nclasses,classification_opts.kernel,classification_opts.kernel_option,classification_opts.verbose);
            
            %%%%%%%%% divide the histogram into train and test %%%%%%%%
            histogram_train_final=histogram_weight(:,trainset>0);
            histogram_test_final=histogram_weight(:,testset>0);
            
            %%%%%%%%% Complete the final SVM_Score %%%%%%%%%%%%%%%%
            [svm_score,class_score]=Do_SVM(histogram_train_final,histogram_test_final,train_truth,test_truth,classification_opts.kernel_option,classification_opts.kernel,nclasses,c1,lambda1,classification_opts.verbose); 
   end
 end

