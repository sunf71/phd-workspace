function [predict_label,accuracy,dec_values]=Do_libSVM(traindata,testdata,labels_L,labels_T,best_C)

options=sprintf('-t 0 -b 1 -c %f',best_C);
model=svmtrain(labels_L,traindata,options);
%                               [predict_label, accuracy , dec_values] = svmpredict(labels_T,testdata, model);
                               [predict_label, accuracy , dec_values] = svmpredict(labels_T,testdata, model,'-b 1');