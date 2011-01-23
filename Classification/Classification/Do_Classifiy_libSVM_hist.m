function [svm_score,best_CV]=Do_Classifiy_libSVM_hist(opts,classification_opts,histogram)

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
     %histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
    %histogram1=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name1]),'All_hist');
%   histogram=histogram(9601:12000,:);
%   histogram1=sqrt(histogram1);
%   histogram=histogram(1:24000,:); histogram=histogram./0.5;
%   histogram=histogram1;
%       histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
%     histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
%     histogram4=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name4]),'All_hist');
%      histogram5=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name5]),'All_hist');
%       histogram6=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name6]),'All_hist');
     
%     histogram2=histogram2(1:12800,:); histogram2=histogram2./0.5;
%     histogram2=histogram2(1:12800,:); histogram2=histogram2./0.5;
%             histogram=[(0.9).*histogram1;(0.05).*histogram2;(0.05).*histogram3];
%   histogram=[(0.4).*histogram1;(0.14).*histogram2;(0.46).*histogram3];
    %histogram=[(0.5).*histogram1;(0.35).*histogram2;(0.15).*histogram3];%%%% events weighting
%       histogram=[(0.6).*histogram1;(0.4).*histogram2];%%%% scenes weighting
%     histogram=[(0.5).*histogram1;(0.5).*histogram2];
%%%% This one 
%      histogram=[(0.1).*histogram1;(0.33).*histogram2;(0.47).*histogram3;(0.4).*histogram4]; 
%       histogram=[(0.4).*histogram1;(0.6).*histogram2];
%  histogram=[(0.4).*histogram1;(0.55).*histogram2;(0.38).*histogram3;(0.04).*histogram4];  %%%% Weighting that gave 90.63 in butterflies

% histogram=[(0.55).*histogram1;(0.45).*histogram2;(0.4).*histogram3;(0.45).*histogram4;(0.01).*histogram5];
% histogram=[(0.55).*histogram1;(0.45).*histogram2;(0.42).*histogram3;(0.45).*histogram4;(0.3).*histogram5];

% histogram=[(0.4).*histogram1;(0.35).*histogram2;(0.2).*histogram3];
%       histogram=histogram(1:19200,:);
%      histogram=histogram./0.5;
%   histogram=normalize(histogram,1);
%    histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
%   histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
%                                                      histogram2=normalize(histogram2,2);
%                                                  histogram2=normalize(histogram2,1);
%                    histogram1=normalize(histogram1,2);
%                histogram1=normalize(histogram1,1);
%               histogram=sqrt(histogram);
%        histogram1=histogram1.*0.5; histogram3=histogram3/2;
%  histogram2=histogram2/0.25; histogram3=histogram3/0.5;
%                                                     histogram=[histogram1;histogram2;histogram3];

%                                            histogram=normalize(histogram,2);
%                       histogram=sqrt(normalize(histogram,1));
  
%          histogram=histogram(932:end,:);
 histogram_train=histogram(:,trainset>0);
 histogram_test=histogram(:,testset>0);
 
    [max1,labels_index]=max(labels,[],2);
   train_truth=labels_index(trainset>0);
   test_truth=labels_index(testset>0);
% train_truth=zeros(1050,1);
% train_truth(501:end,:)=1;
% test_truth=ones(170,1);

  size(histogram_train)
  size(histogram_test)
%  %%%%%%%%% for Training and Test GroundTruth %%%%%%%%%%%%%
%  % For Training Set 
%  train_truth=[];
%      for jj=1:nclasses
%         train_truth=[train_truth; jj*ones(classification_opts.num_train_images,1)];
%      end
%  %%%%%%%%%%%% for groundTruth test %%%%%%%%%%%%%%%%%%%
% num_test=(classification_opts.perclass_images)-(classification_opts.num_train_images);
% test_truth=[];
% %  [xx,test_truth12]=ndgrid(1:num_test,1:nclasses);
%      for jj=1:nclasses
%         test_truth=[test_truth; jj*ones(num_test,1)];
%      end

size(histogram)
 %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
   switch (classification_opts.num_histogram)
       case 1
            %%%%%%% Cross Validation %%%%%%%%
                 %%% uncomment next line for intersection kernel %%%
%                       [best_C,best_CV]=Do_CV_libSVM_fast(histogram_train',train_truth); 
%                           [best_C,best_CV]=Do_CV_libSVM_ikmmulti(histogram_train',train_truth);
%                        [best_C,best_CV]=Do_CV_libSVM(histogram_train',train_truth);
                               [best_C,best_G,best_CV]=Do_CV_libSVM_chisq(histogram_train',train_truth);
%  
%                                            best_C=4;
%                                  best_G=0.1;
               %%% uncomment next line for intersection kernel %%%
%                  [predict_labels,svm_score]=Do_libSVM_fast_multi(histogram_train',histogram_test',train_truth,test_truth,best_C);
%                      [predict_labels,svm_score]=Do_libSVM(histogram_train',histogram_test',train_truth,test_truth,best_C);
                      [predict_labels,svm_score]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G); 
       case 2   
           %%%%%%%%% Load the Second Histogram %%%%%%%%%%
            histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'all_hist1');
            
            %%%% only uncomment if combining late and early fusion %%%
%               histogram=normalize(histogram,2);
%               histogram=normalize(histogram,1);

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

 











