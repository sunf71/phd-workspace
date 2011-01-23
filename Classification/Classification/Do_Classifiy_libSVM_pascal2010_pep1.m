function [svm_score,best_CV]=Do_Classifiy_libSVM_pascal2010_pep1(opts,classification_opts,rng)

% if nargin<2
%     classification_opts=[];
% end
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
 load(opts.image_names)
 load(opts.testset)
 labels=getfield(load(opts.labels),'labels');
 nclasses=opts.nclasses;
 counter=1;
 
 
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
  histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
  size(histogram)
%      histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
%      size(histogram2)
%    histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
%    size(histogram3)
%     histogram4=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name4]),'All_hist');
%     size(histogram4)
%     histogram5=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name5]),'All_hist');
%     size(histogram5)
%     histogram6=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name6]),'All_hist');
%     size(histogram6)
%    histogram7=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name7]),'All_hist');
%    size(histogram7)
%     histogram8=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name8]),'All_hist');
% size(histogram8)
%       histogram=[histogram1;histogram2;histogram3;histogram4];
%     histogram=[histogram2(:,1:19740);histogram3(:,1:19740);histogram1(:,1:19740);histogram4(:,1:19740);histogram5(:,1:19740);histogram6(:,1:19740);histogram7(:,1:19740);histogram8(:,1:19740)];
%     clear histogram1 histogram2 histogram3 histogram4 
% histogram=[(0.9).*histogram1;(0.1).*histogram2];
size(histogram)
 histogram_train=histogram(:,trainset>0);
  histogram_test=histogram(:,10104:end);
%   histogram_test=histogram(:,testset>0);
 size(histogram_train)
size(histogram_test)
 
for i=rng
    cls=opts.classes{i};
% cls=opts.classes{classification_opts.pascal_cls};
 
%  %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
%  histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
% 
%  histogram_train=histogram(:,trainset>0);
%  histogram_test=histogram(:,testset>0);

%  %%%%%%%%% for Training  GroundTruth %%%%%%%%%%%%%
 train_truth=zeros(size(labels,1),1);
 a=(trainset.*(labels(:,i)==1))>0;
 bcd=find(a==1);
 train_truth(bcd,:)=1;
 train_truth=train_truth(trainset>0,:);

%  %%%%%%%%%%%% for groundTruth test %%%%%%%%%%%%%%%%%%%
 test_truth=zeros(size(histogram_test,2),1);
%  test_truth=zeros(size(labels,1),1);
%  a=(testset.*(labels(:,i)==1))>0;
%  bcd=find(a==1);
%  test_truth(bcd,:)=1;
%  test_truth=test_truth(testset>0,:);
 
 %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
  clear histogram
            %%%%%%% Cross Validation %%%%%%%%
%                     [best_C,best_CV]=Do_CV_libSVM_fast(histogram_train',train_truth);
% [best_C,best_CV]=Do_CV_libSVM_pascal_ikm(histogram_train',train_truth);
%  [best_C,best_G,best_CV]=Do_CV_libSVM_chisq(histogram_train',train_truth);
                       best_C=2000;
                       best_G=0.1;
%           [predict_labels,svm_score,prob_out]=Do_libSVM(histogram_train',histogram_test',train_truth,test_truth,best_C);

%               [predict_label,svm_score,prob_out]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);            
           [predict_labels,accuracy, prob_out]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G);   

           prob_class=prob_out(:,2);
            size(prob_class)
            %%%%% save the probabilities with the class name to the results folder 
            
            fid=fopen(sprintf(opts.clsrespath,cls),'w');
           counter=10104;
            for jk=1:length(prob_class)
                a1=image_names{counter};
                idst=a1(1:end-4); 
                fprintf(fid,'%s %f\n',idst,prob_class(jk));
                counter=counter+1;
            end
            fclose(fid);
            display('class done');
%             fid=fopen(sprintf(opts.clsrespath,cls),'w');
%             imgset='val';
%             [ids,gt]=textread(sprintf(opts.clsimgsetpath,cls,imgset),'%s %d');
%             for jk=1:length(ids)
%                 fprintf(fid,'%s %f\n',ids{jk},prob_class(jk));
%             end
%             fclose(fid);
            
%              [recall,prec,ap]=VOCevalcls(opts,cls,true);
%              clas_score{counter}=ap
%              class_ap{i}=ap
           
   
end    %%%% end for

