function [svm_score,best_CV]=Do_Classifiy_libSVM_Inria2(opts,classification_opts,assignment_opts)

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
 
 %%
 train_truth=zeros(size(labels,1),1);
a=(trainset.*(labels(:,2)==1))>0;
bcd=find(a==1);
train_truth(bcd,:)=1;
train_truth=train_truth(trainset>0,:);
 
 [max1,labels_index]=max(labels,[],2);
%    train_truth=labels_index(trainset>0);
    test_truth=labels_index(testset>0);

  size(histogram_train)
  size(histogram_test)


size(histogram)
 %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
   switch (classification_opts.num_histogram)
       case 1
            %%%%%%% Cross Validation %%%%%%%%
                 
%    [best_C,best_CV]=Do_CV_libSVM_ikmmulti(histogram_train',train_truth);
%    [predict_labels,svm_score]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);

                       
 %%       Preparing the test image histograms for Inria data set
 display('starting making windows in negative windows');
 
  load(opts.image_names);
  load(opts.data_locations);
  nimages=opts.nimages;
  count_it=1;
  patch_step=7;
      for ijk=15723:nimages
          ijk
          count_it=count_it+1;
%             if(count_it>197)
                patch_step=8;
%             end
            im=imread(sprintf('%s/%s',opts.imgpath,image_names{ijk}));
            index=getfield(load([data_locations{ijk},'/',classification_opts.assignment_name]),'assignments');
            
            All_hist=Convert_Image_Hist_Inria3(opts,assignment_opts,index,im,patch_step,data_locations{ijk});
      end
                    display('patch construction done');
                    pause
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
%        case 3
%               %%%%%%%%% Load the Second Histogram %%%%%%%%%%
%             %%%%%%%%% Load the Second Histogram %%%%%%%%%%
%             histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'all_hist1');
%             histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
%                 histogram=normalize(histogram,2);
%                 histogram=normalize(histogram,1);
%             
%             histogram_total=[histogram;histogram2;histogram3];
%             histogram_train=histogram_total(:,trainset>0);
%             [best_C,best_CV]=Do_CV_libSVM(histogram_train',train_truth);
%             [alpha,histogram_train,histogram_weight,best_C1]=Do_learn_alpha_libSVM1(histogram_train',histogram_total,train_truth,best_C,1,size(histogram,1),size(histogram,1)+1,size(histogram2,1)+size(histogram,1),trainset);
%             
%             %%%% Do with second and third feature %%%%%%%
%              [alpha2,histogram_train,histogram_weight,best_C1]=Do_learn_alpha_libSVM1(histogram_train,histogram_weight,train_truth,best_C,1,size(histogram2,1)+size(histogram,1),size(histogram2,1)+size(histogram,1)+1,size(histogram2,1)+size(histogram,1)+size(histogram3,1),trainset);
% %             [histogram_train,histogram_weight,alpha2]=learn_alpha(histogram_train,histogram_weight,c,lambda,train_truth,nclasses,classification_opts.kernel,classification_opts.kernel_option,classification_opts.verbose,1,size(histogram2,1)+size(histogram,1),size(histogram2,1)+size(histogram,1)+1,size(histogram2,1)+size(histogram,1)+size(histogram3,1));
%             
%             histogram_train_final=histogram_weight(:,trainset>0);
%             histogram_test_final=histogram_weight(:,testset>0);
% %              [best_C1,best_CV1]=Do_CV_libSVM(histogram_train_final',train_truth);
%             [svm_score]=Do_libSVM(histogram_train_final',histogram_test_final',train_truth,test_truth,best_C1);
   end
end

 











