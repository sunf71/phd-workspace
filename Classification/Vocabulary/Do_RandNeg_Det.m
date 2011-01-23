function histogram_all_select_random=Do_RandNeg_Det(opts,classification_opts)

 load(opts.trainset)
 load(opts.data_locations);
 load(opts.testset)
 load(opts.image_names)
 nimages=opts.nimages;
 labels=getfield(load(opts.labels),'labels');
 nclasses=opts.nclasses;
 histogram_all_select_random=[];
 
 %% Start Collecting Random Neagtive Samples from Negative Images
for itk=1:nimages
         if(trainset(itk)==1)
             if(labels(itk,classification_opts.cls_num)==1) 
                 display('not here');
             else
                 itk
                 det_points_final=getfield(load([data_locations{itk},'/',classification_opts.index_name]),'assignments');
                 imt=sprintf('%s/%s',opts.imgpath,image_names{itk});
                 im=imread(imt);
                 %%%%%%%%% Generate Windows %%%%%%%
                 windows_all = Do_SlidingWindows(im,classification_opts.optionGenerate,classification_opts);
                 %%%%%%%%% Select Negative Windows %%%%%%%%%%%
                 attp=randperm(length(windows_all));
                 select_windows=attp(1:classification_opts.num_neg_samples);
                 select_windows_random=windows_all(select_windows,:);
                 %%%%%%%%% Compute Histograms over all windows %%%%%%%
                 histogram_test_random=Do_ComputeHist_SW(select_windows_random,det_points_final,classification_opts);
                 %%%%%%%% Store All Hard Negatives %%%%%%%%%%%
                 histogram_all_select_random=[histogram_all_select_random,histogram_test_random];
                
             end

         end
end %%%%%% End of loop over no of images for rand Neg Examples
display('The Size of Random Negative Examples Extracted is :');
size(histogram_all_select_random)
pause