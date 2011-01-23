function histogram_test=Do_Test_Det(windows,det_points_final,model,classification_opts)
histogram_test=[];
counter=1;
%  for jt=1:length(windows)
%           
%           bbox_total =  det_points_final(( det_points_final(:,1) > windows(jt,1)) & ( det_points_final(:,1) <= windows(jt,3)) & ...
%                                 ( det_points_final(:,2) > windows(jt,2)) & ( det_points_final(:,2) <= windows(jt,4)),3);
%           all_hist=hist(bbox_total, 1:classification_opts.vocabulary_size)./length(bbox_total); 
% %                       histogram_test(:,counter)=all_hist; 
%           test_truth=zeros(size(all_hist,1),1);
% %           size(all_hist)
%           [predict_label,accuracy,dec_values]=Do_Model_test_Det(all_hist,test_truth,model);
%           histogram_test(counter,:)=dec_values;
%           counter=counter+1;
%  end

 val1=det_points_final(:,1)*ones(1,length(windows));
 val2=det_points_final(:,2)*ones(1,length(windows)); 
 mask= val1 - ones(size(det_points_final,1),1)*windows(:,1)'>0  & ...
 val1 - ones(size(det_points_final,1),1)*windows(:,3)'<=0 & ... 
 val2 - ones(size(det_points_final,1),1)*windows(:,2)'>0 & ...
 val2 - ones(size(det_points_final,1),1)*windows(:,4)'<=0 ;
tic;
 for jt=1:length(windows)
        maskC=mask(:,jt);
        all_hist(jt,:)=hist(det_points_final(maskC,3),1:classification_opts.vocabulary_size)./sum(maskC);
 end
 toc;
 test_truth=zeros(size(all_hist,1),1);
%           size(all_hist)
          [predict_label,accuracy,dec_values]=Do_Model_test_Det(all_hist,test_truth,model);
%           histogram_test(counter,:)=dec_values;
histogram_test=dec_values;
          counter=counter+1;
