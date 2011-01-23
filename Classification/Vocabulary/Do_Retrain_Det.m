function histogram_all_retrain=Do_Retrain_Det(opts,classification_opts,model)

 load(opts.trainset)
 load(opts.data_locations);
 load(opts.testset)
 load(opts.image_names)
 nimages=opts.nimages;
 labels=getfield(load(opts.labels),'labels');
 nclasses=opts.nclasses;
 histogram_all_retrain=[];
 %%
for it=1:nimages
         if(trainset(it)==1)
             if(labels(it,classification_opts.cls_num)==1) 
                 display('not here');
             else
                 it
                 det_points_final=getfield(load([data_locations{it},'/',classification_opts.index_name]),'assignments');
                 imt=sprintf('%s/%s',opts.imgpath,image_names{it});
                 im=imread(imt);
                 %%%%%%%%% Generate Windows %%%%%%%
                 windows_all = Do_SlidingWindows(im,classification_opts.optionGenerate,classification_opts);
                 %%%%%%%%% Compute Histograms over all windows %%%%%%%
                 histogram_test_random=Do_ComputeHist_SW(windows_all,det_points_final,classification_opts);
                 %%%%%%%% Prepare test_truth %%%%%%%%%
                 test_truth=zeros(size(histogram_test_random,2),1);
                 
                 %%%%%%%% retrain the model to get Hard negatives %%%%%%
                 histogram_hard_neg=Do_Model_retrain_Det(histogram_test_random',test_truth,model);
                 size(histogram_hard_neg)
                 
                 %%%%%%%% Store All Hard Negatives %%%%%%%%%%%
                 histogram_all_retrain=[histogram_all_retrain,histogram_hard_neg];
                 
                
             end

         end
end
 save -v7.3 '/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Data/Global/hard_Negatives' histogram_all_retrain
 display('The Size of Hard Negative Examples Extracted is :');
 size(histogram_all_retrain)
 pause