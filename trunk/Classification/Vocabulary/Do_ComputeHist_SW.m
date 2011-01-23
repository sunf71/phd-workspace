function histogram_test_random=Do_ComputeHist_SW(select_windows_random,det_points_final,param_opts)

if(strcmp(param_opts.histogram_type,'bow'))
counter_rand=1;
for jt=1:length(select_windows_random)
                     
                      bbox_total =  det_points_final(( det_points_final(:,1) > select_windows_random(jt,1)) & ( det_points_final(:,1) <= select_windows_random(jt,3)) & ...
                                            ( det_points_final(:,2) > select_windows_random(jt,2)) & ( det_points_final(:,2) <= select_windows_random(jt,4)),:,:);
                      all_hist=hist(bbox_total(:,3), 1:param_opts.vocabulary_size)./length(bbox_total); 
                      histogram_test_random(:,counter_rand)=all_hist;   
                      counter_rand=counter_rand+1;
end
elseif(strcmp(param_opts.histogram_type,'bow_pym'))
    pyramidLevels=param_opts.level;
    Levels=pyramidLevels;
    maxBins = 2^(Levels-1);binsHigh=maxBins;
    BOW=[];pyramid_all = [];
    vocabulary_size=param_opts.vocabulary_size;
    dictionarySize=vocabulary_size;
    
end