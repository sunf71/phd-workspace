function [predict_label,svm_score,prob_out]=Do_Classifiy_libSVM_pascal2007_GroupSensitive(opts,classification_opts,rng)

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
 load(opts.testset)
 labels=getfield(load(opts.labels),'labels');
 nclasses=opts.nclasses;
%  nimages=opts.nimages;
counter=1;
 
%% only now
% histogram=ones(1000,9963);
% rng=nclasses;
          %histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'hist_final');
           histogram1=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'hist_final');
               histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'hist_final');
                histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'hist_final');
%              histogram4=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name4]),'hist_final');
%           size(histogram)
          display('classification.. started')
%         histogram=sqrt(histogram);
%         histogram=normalize(histogram,2);
%         histogram=normalize(histogram,1);
             histogram=[(0.8).*histogram1;(0.1).*histogram2;(0.1).*histogram3];
% histogram=[(0.4).*histogram1;(0.1).*histogram2;(0.1).*histogram3;(0.4).*histogram4];
          
%%        
%             histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
%               histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
%         histogram4=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name4]),'All_hist');
%         histogram5=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name5]),'All_hist');
%       histogram6=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name6]),'All_hist');
% % % %    histogram6=[(0.9).*histogram2;(0.1).*histogram5];
%           histogram=[(0.1).*histogram1;(0.35).*histogram2;(0.05).*histogram3;(0.3).*histogram4;(0.2).*histogram5];
%               histogram=[(0.8).*histogram1;(0.1).*histogram2;(0.1).*histogram3];
for i=rng
    cls=opts.classes{i};
% cls=opts.classes{classification_opts.pascal_cls}; 
 %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
 
%    histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
 
 %%%% try to see what happens if i do fusion %%%%%
%          histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
%        histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
% %       histogram=[(0.7).*histogram1;(0.3).*histogram2];
%          histogram=[histogram1;histogram2];

%%%%%% prepare group sensitive combinations %%%%%%%%
parent_class=17;
group_class=[10 8 12 13];

%% Positive and negative histograms and train_truth (Training)
a_pos=(trainset.*(labels(:,parent_class)==1))>0;
hist_train_pos_index=find(a_pos==1);

tot_neg_train=[];
for ikt=1:length(group_class)
   a_neg=(trainset.*(labels(:,group_class(ikt))==1))>0;
   hist_train_neg_index=find(a_neg==1);
   tot_neg_train=[tot_neg_train;hist_train_neg_index];
end
   tot_train_hist_index=[hist_train_pos_index;tot_neg_train];
   tot_train_hist_index=unique(tot_train_hist_index);
   %%%%% Training histogram %%%%
   histogram_train=histogram(:,tot_train_hist_index);
   %%%%% training Truth %%%%%%%
   train_truth=zeros(size(histogram_train,2),1);
   train_truth(1:length(hist_train_pos_index),:)=1;
   
%% Positive and negative histograms and Test_truth (Testing)
% a_pos=(testset.*(labels(:,parent_class)==1))>0;
% hist_test_pos_index=find(a_pos==1);
% 
% tot_neg_test=[];
% for ikt=1:length(group_class)
%    a_neg=(testset.*(labels(:,group_class(ikt))==1))>0;
%    hist_test_neg_index=find(a_neg==1);
%    tot_neg_test=[tot_neg_test;hist_test_neg_index];
% end
%    tot_test_hist_index=[hist_test_pos_index;tot_neg_test];
%    tot_test_hist_index=unique(tot_test_hist_index);
%    %%%%% Training histogram %%%%
%    histogram_test=histogram(:,tot_test_hist_index);
%    %%%%% training Truth %%%%%%%
%    test_truth=zeros(size(histogram_test,2),1);
%    test_truth(1:length(hist_test_pos_index),:)=1;
 
% %  %%%%%%%%% for Training  GroundTruth %%%%%%%%%%%%%
% train_truth=zeros(size(labels,1),1);
% a=(trainset.*(labels(:,i)==1))>0;
% bcd=find(a==1);
% train_truth(bcd,:)=1;
% train_truth=train_truth(trainset>0,:);
histogram_test=histogram(:,testset>0);
% %  %%%%%%%%%%%% for groundTruth test %%%%%%%%%%%%%%%%%%%
test_truth=zeros(size(labels,1),1);
a=(testset.*(labels(:,i)==1))>0;
bcd=find(a==1);
test_truth(bcd,:)=1;
test_truth=test_truth(testset>0,:);


 %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
%    switch (classification_opts.num_histogram)
%        case 1
            %%%%%%% Cross Validation %%%%%%%%
            size(histogram)
            size(histogram_train)
            size(histogram_test)
           
%                          [best_C,best_CV]=Do_CV_libSVM_pascal(histogram_train',train_truth);
%% to be used
%                             [best_C,best_CV]=Do_CV_libSVM_pascal_ikm(histogram_train',train_truth);

%                          [best_C,best_G,best_CV]=Do_CV_libSVM_chisq(histogram_train',train_truth);
%best_C=1141;
  best_C=20;
%display('fixed c value')
%                             best_C=5000;best_CV=0;
%                           best_G=0.1;
%  best_C=20;best_CV=0;               
                  [predict_label,svm_score,prob_out]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);      
               
%                     [predict_label,svm_score,prob_out]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G);            

                prob_class=prob_out(:,2);         %%%% for all classes its 2 except for chair class where its 1
%                 save -v7.3 '/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Results/VOC2007/sheep' predict_labels
                
            %%%%% save the probabilities with the class name to the results folder 
               fid=fopen(sprintf(opts.clsrespath,cls),'w');
               imgset='test';
               [ids,gt]=textread(sprintf(opts.clsimgsetpath,cls,imgset),'%s %d');
               
             for jk=1:length(ids)
                 fprintf(fid,'%s %f\n',ids{jk},prob_class(jk));
            end
             fclose(fid);
               [recall,prec,ap]=VOCevalcls(opts,cls,true);


  collect_ap{counter}=ap
  %             clas_score{counter}=ap
              class_ap{i}=ap
%   counter=counter+1;           
%    end %%%% end switch 
end    %%%% end for
% ant=collect_ap;
