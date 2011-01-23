function []=Do_Detection_Pascal2007(opts,classification_opts)

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
 load(opts.data_locations);
 load(opts.testset)
 load(opts.image_names)
 nimages=opts.nimages;
 labels=getfield(load(opts.labels),'labels');
 nclasses=opts.nclasses;
%  nimages=opts.nimages;
counter=1;
counter_img=1;
parameter_retrain=0;
% counter_rand=1;
counter_retrain=1;
histogram_test=[];
histogram_test_random=[];
histogram_all_retrain=[];
histogram_all_select_random=[];

%% Do the Model Training by Loading the computed Training Histogram Histogram
       best_C=20;
       histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.trainhist_name]),'All_hist');
       train_truth=getfield(load([opts.data_assignmentpath,'/',classification_opts.traintruth_name]),'train_truth');
%        model=Do_Model_train_Det(histogram',train_truth,best_C,parameter_retrain);
%        display('Model Computed');
%        pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initial Model is Trained %%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Do Retraining
if(classification_opts.model_retrain)
    display('Loading the model');
    model=getfield(load('/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Data/Global/BOW_Model'),'model');
    parameter_retrain=1;
    %%%%%%%%% First extract randomely negative sampled histograms for obtaining hard negatives %%%%%%%
    for it=1:nimages
         if(trainset(it)==1)
             if(labels(it,classification_opts.cls_num)==1) 
                 display('not here');
             else
                 it
                 det_points_final=getfield(load([data_locations{it},'/',classification_opts.index_name]),'assignments');
                 imt=sprintf('%s/%s',opts.imgpath,image_names{it});
                 im=imread(imt);
                 windows_all = Do_SlidingWindows(im,classification_opts.optionGenerate,classification_opts);
                 attp=randperm(length(windows_all));
                 select_windows=attp(1:classification_opts.num_neg_samples);
                 select_windows_random=windows_all(select_windows,:);
                 histogram_test_random=Do_ComputeHist_SW(select_windows_random,det_points_final,classification_opts);
    %            histogram_select_random=histogram_test_random(:,select_windows); %%% for selecting random hist
    %            test_truth=zeros(size(histogram_test_random,2),1);
    %            histogram_hard_neg=Do_Model_retrain_Det(histogram_test_random',test_truth,model);
    %            histogram_all_retrain=[histogram_all_retrain;histogram_hard_neg'];
                 histogram_all_select_random=[histogram_all_select_random,histogram_test_random];
             end

         end
    end
    size(histogram_all_select_random)
    %%%%%%%%% Retraining the Model again %%%%%%%%%%%%%%%%
    %%%%%%%%% I retrain not only from hard neg but also from randomly sampled backgrounds
    % histogram_retrain=[histogram;histogram_all_retrain];
    % train_truth_retrain=[train_truth,zeros(size(histogram_all_retrain,2))];
    histogram_retrain=[histogram,histogram_all_select_random];
    size(histogram_retrain)
    z=zeros(size(histogram_all_select_random,2),1);
    train_truth_retrain=[train_truth;z];
    size(train_truth_retrain)
    model=Do_Model_train_Det(histogram_retrain',train_truth_retrain,best_C,parameter_retrain);
    display('Model Retrained');
    pause
end
model=getfield(load('/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Data/Global/BOW_Model_final_retrain'),'model');
%% Do Testing 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Construct Histogram of sliding windows and Test Model %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display('%%%%% STARTING TESTING %%%%%%');
tic;
      for i =5044:5044
          if(testset(i)==1)
%               i=5106;
              
              det_points_final=getfield(load([data_locations{i},'/',classification_opts.index_name]),'assignments');
              imt=sprintf('%s/%s',opts.imgpath,image_names{i});
              im=imread(imt);
%                  img_structure=getfield(load('/home/fahad/Datasets/Inria/Data/Global/Assignment/final_predict'),'img_structure');
              windows = Do_SlidingWindows(im,classification_opts.optionGenerate,classification_opts); 
               windows=[];
               windows=[38 64 457 208];
              for jt=1:1
                      jt
                      bbox_total =  det_points_final(( det_points_final(:,1) > windows(jt,1)) & ( det_points_final(:,1) <= windows(jt,3)) & ...
                                            ( det_points_final(:,2) > windows(jt,2)) & ( det_points_final(:,2) <= windows(jt,4)),:,:);
                      all_hist=hist(bbox_total(:,3), 1:classification_opts.vocabulary_size)./length(bbox_total); 
%                       histogram_test(:,counter)=all_hist; 
                      test_truth=zeros(size(all_hist,1),1);
                      size(all_hist)
                  [predict_label,accuracy,dec_values]=Do_Model_test_Det(all_hist,test_truth,model);
                  size(dec_values)
                  histogram_test(counter,:)=dec_values;
                      counter=counter+1
              end
                  
%                   test_truth=zeros(size(histogram_test,2),1);
%                   [predict_label,accuracy,dec_values]=Do_Model_test_Det(histogram_test',test_truth,model);
                  img_structure{counter_img}=[windows,histogram_test];
                  counter_img=counter_img+1;
                  save -v7.3 '/home/fahad/Datasets/Inria/Data/Global/Assignment/final_predict5' img_structure

          end
          display('done')
          toc;
      pause
               [drect,dscores]=Do_non_max_sp(windows,dec_values,classification_opts); 
      end
      
%%%%%%%%%%%%%%%%% Do Non-Maxima Supression on sliding window histograms %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% %% only now
% % histogram=ones(1000,9963);
% % rng=nclasses;
%           histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'hist_final');
%           %histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
%           size(histogram)
%           display('classification.. started')
% %         histogram=sqrt(histogram);
% %         histogram=normalize(histogram,2);
% %         histogram=normalize(histogram,1);
% %         histogram=[histogram2;histogram1];
% %%        
% %             histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
% %               histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
% %         histogram4=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name4]),'All_hist');
% %         histogram5=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name5]),'All_hist');
% %       histogram6=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name6]),'All_hist');
% % % % %    histogram6=[(0.9).*histogram2;(0.1).*histogram5];
% %           histogram=[(0.1).*histogram1;(0.35).*histogram2;(0.05).*histogram3;(0.3).*histogram4;(0.2).*histogram5];
% %               histogram=[(0.8).*histogram1;(0.1).*histogram2;(0.1).*histogram3];
% for i=rng
%     cls=opts.classes{i};
% % cls=opts.classes{classification_opts.pascal_cls}; 
%  %%%%%%%%%%%% Load the Histograms %%%%%%%%%%%%%
%  
% %    histogram=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name]),'All_hist');
%  
%  %%%% try to see what happens if i do fusion %%%%%
% %          histogram2=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name2]),'All_hist');
% %        histogram3=getfield(load([opts.data_assignmentpath,'/',classification_opts.assignment_name3]),'All_hist');
% % %       histogram=[(0.7).*histogram1;(0.3).*histogram2];
% %          histogram=[histogram1;histogram2];
% 
%  
%   histogram_train=histogram(:,trainset>0);
%   histogram_test=histogram(:,testset>0);
% 
% 
% % histogram_train=histogram(:,(trainset.*(labels(:,1)==1))>0);
% % histogram_test=histogram(:,(testset.*(labels(:,1)==1))>0);
%    
%  
% %  %%%%%%%%% for Training  GroundTruth %%%%%%%%%%%%%
% train_truth=zeros(size(labels,1),1);
% a=(trainset.*(labels(:,i)==1))>0;
% bcd=find(a==1);
% train_truth(bcd,:)=1;
% train_truth=train_truth(trainset>0,:);
% 
% %  %%%%%%%%%%%% for groundTruth test %%%%%%%%%%%%%%%%%%%
% test_truth=zeros(size(labels,1),1);
% a=(testset.*(labels(:,i)==1))>0;
% bcd=find(a==1);
% test_truth(bcd,:)=1;
% test_truth=test_truth(testset>0,:);
% 
% 
% %%%% for train and test truth of pascal %%%%
% %  [train_truth,test_truth]=Do_train_test_truth_pascal(opts);
% 
% 
% 
%  %%%%%%%%%%%%% Do Classification %%%%%%%%%%%%%
% %    switch (classification_opts.num_histogram)
% %        case 1
%             %%%%%%% Cross Validation %%%%%%%%
%             size(histogram)
%             size(histogram_train)
%             size(histogram_test)
%            
% %                          [best_C,best_CV]=Do_CV_libSVM_pascal(histogram_train',train_truth);
% %% to be used
% %                           [best_C,best_CV]=Do_CV_libSVM_pascal_ikm(histogram_train',train_truth);
% 
% %                          [best_C,best_G,best_CV]=Do_CV_libSVM_chisq(histogram_train',train_truth);
% %best_C=1141;
% %best_C=1500;
% display('fixed c value')
% %                            best_C=5000;best_CV=0;
% %                         best_G=0.1;
%   best_C=20;best_CV=0;               
%                 [predict_label,svm_score,prob_out]=Do_libSVM_fast(histogram_train',histogram_test',train_truth,test_truth,best_C);      
% %               [predict_label,svm_score,prob_out]=Do_libSVM_chi(histogram_train',histogram_test',train_truth,test_truth,best_C,best_G);            
% 
%                 prob_class=prob_out(:,1);         %%%% for all classes its 2 except for chair class where its 1
%             %%%%% save the probabilities with the class name to the results folder 
%                fid=fopen(sprintf(opts.clsrespath,cls),'w');
%                imgset='test';
%                [ids,gt]=textread(sprintf(opts.clsimgsetpath,cls,imgset),'%s %d');
%              for jk=1:length(ids)
%                  fprintf(fid,'%s %f\n',ids{jk},prob_class(jk));
%             end
%              fclose(fid);
%               [recall,prec,ap]=VOCevalcls(opts,cls,true);
% %              if i<opts.nclasses
% %                 fprintf('press any key to continue with next class...\n');
% %                 drawnow;
% %                 pause;
% %              end %%% end if 
% 
%   collect_ap{counter}=ap
%   %             clas_score{counter}=ap
%              class_ap{i}=ap
% %   counter=counter+1;           
% %    end %%%% end switch 
% end    %%%% end for
% % ant=collect_ap;
