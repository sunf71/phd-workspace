function [svm_score,best_CV]=Do_Classifiy_libSVM_pascal2009_11_channel(opts,classification_opts,rng,c,g)

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
 labels=getfield(load(opts.labels),'labels');
 nclasses=opts.nclasses;
 counter=1;
 
 
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
  
histogram1=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist'); % CA
histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist'); %sift small
histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist'); % oppsift
histogram4=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name4]),'All_hist');
histogram5=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name5]),'All_hist');
histogram6=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name6]),'All_hist');
histogram7=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name7]),'All_hist');
histogram8=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name8]),'All_hist');
histogram9=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name9]),'All_hist');
histogram10=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name10]),'All_hist');
% histogram11=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name11]),'All_hist');
   
   
% 
 histogram=[(0.25).*histogram1;(0.15).*histogram2;(0.03).*histogram3;(0.07).*histogram4;(0.2).*histogram5;(0.03).*histogram6;(0.1).*histogram7;(0.03).*histogram8;(0.01).*histogram9;(0.07).*histogram10];

 histogram_train=histogram(:,trainset>0);
 histogram_test=histogram(:,testset>0);
 
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
 test_truth=zeros(size(labels,1),1);
 a=(testset.*(labels(:,i)==1))>0;
 bcd=find(a==1);
 test_truth(bcd,:)=1;
 test_truth=test_truth(testset>0,:);
 
 %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
   switch (classification_opts.num_histogram)
       case 1
            %%%%%%% Cross Validation %%%%%%%%
%             [best_C,best_CV]=Do_CV_libSVM(histogram_train',train_truth);

              best_C=c;
              best_G=g;
%             [predict_label,svm_score,prob_out]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);            
              [predict_label,svm_score,prob_out]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G);            
              prob_class=prob_out(:,1);
            
            %%%%% save the probabilities with the class name to the results folder 
            fid=fopen(sprintf(opts.clsrespath,cls),'w');
            imgset='test';
            [ids,gt]=textread(sprintf(opts.clsimgsetpath,cls,imgset),'%s %d');
            for jk=1:length(ids)
                fprintf(fid,'%s %f\n',ids{jk},prob_class(jk));
            end
            fclose(fid);
            
%             [recall,prec,ap]=VOCevalcls(opts,cls,true);
%             clas_score{counter}=ap
%             class_ap{i}=ap
           
   end %%%% end switch 
end    %%%% end for

