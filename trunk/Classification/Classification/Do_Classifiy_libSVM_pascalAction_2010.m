function [svm_score,best_CV]=Do_Classifiy_libSVM_pascalAction_2010(opts,classification_opts,rng)

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
          histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
          size(histogram)
          display('classification.. started')
%         histogram=sqrt(histogram);
%         histogram=normalize(histogram,2);
%         histogram=normalize(histogram,1);
%         histogram=[histogram2;histogram1];
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

 
  histogram_train=histogram(:,trainset>0);
  histogram_test=histogram(:,testset>0);


% histogram_train=histogram(:,(trainset.*(labels(:,1)==1))>0);
% histogram_test=histogram(:,(testset.*(labels(:,1)==1))>0);
   
 
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


%%%% for train and test truth of pascal %%%%
%  [train_truth,test_truth]=Do_train_test_truth_pascal(opts);



 %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
%    switch (classification_opts.num_histogram)
%        case 1
            %%%%%%% Cross Validation %%%%%%%%
            size(histogram)
            size(histogram_train)
            size(histogram_test)
           
%                          [best_C,best_CV]=Do_CV_libSVM_pascal(histogram_train',train_truth);
%% to be used
                           [best_C,best_CV]=Do_CV_libSVM_pascal_ikm(histogram_train',train_truth);

%                          [best_C,best_G,best_CV]=Do_CV_libSVM_chisq(histogram_train',train_truth);
%best_C=1141;
%best_C=1500;
%display('fixed c value')
%                            best_C=5000;best_CV=0;
%                         best_G=0.1;
%  best_C=20;best_CV=0;               
                [predict_label,svm_score,prob_out]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);      
%               [predict_label,svm_score,prob_out]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G);            

                prob_class=prob_out(:,2);         %%%% for all classes its 2 except for chair class where its 1
                size(prob_class)
            %%%%% save the probabilities with the class name to the results folder 
               fid=fopen(sprintf(opts.clsrespath,cls),'w');
               imgset='val';
               [ids,gt]=textread(sprintf(opts.clsimgsetpath,cls,imgset),'%s %d');
               size(ids)
               pause
             for jk=1:length(ids)
                 fprintf(fid,'%s %f\n',ids{jk},prob_class(jk));
            end
             fclose(fid);
              [recall,prec,ap]=VOCevalcls(opts,cls,true);
%              if i<opts.nclasses
%                 fprintf('press any key to continue with next class...\n');
%                 drawnow;
%                 pause;
%              end %%% end if 

  collect_ap{counter}=ap
  %             clas_score{counter}=ap
             class_ap{i}=ap
%   counter=counter+1;           
%    end %%%% end switch 
end    %%%% end for
% ant=collect_ap;
