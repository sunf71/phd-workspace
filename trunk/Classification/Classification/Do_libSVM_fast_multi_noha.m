function [predict_label, accuracy , dec_values]=Do_libSVM_fast_multi_noha(traindata,testdata,labels_L,labels_T,best_C)

tic;

options=sprintf('-t 4 -b 1 -c %f',best_C); 
model=svmtrain(labels_L,traindata,options);
[predict_label, accuracy , dec_values] = svmpredict(labels_T,testdata, model,'-b 1');

toc;   
             


