function [weights,model]=Do_libSVM_fast_car(traindata,testdata,labels_L,labels_T,best_C)
% n = size(traindata,1);
% K = traindata*traindata';
% K1 = [(1:n)', K];
tic;
% options=sprintf('-t 0 -b 1 -c %f',best_C);

  options=sprintf('-t 4 -b 1 -s 0 -c %f',best_C);
%  options=sprintf('-t 4 -b 1 -s 0'); %%% if no c umcomment this line %%%%

 model=svmtrain(labels_L,traindata,options);
 weights=full(model.SVs)'*model.sv_coef;
 
 
 
% model = svmtrain(labels_L,K1, options);
%                 [predict_label, accuracy , dec_values] = svmpredict(labels_T,testdata, model);


%%% for test data preparation %%%
% n1 = size(testdata,1);
% Ktest = testdata*testdata';
% K2 = [(1:n1)', Ktest];
%                   [pwconst_values, pwlinear_values, exact_values] = svmpredict(labels_T,testdata, model,'-b 1');
   [exact_values, pwconst_values, pwlinear_values] = fastpredict(labels_T,testdata, model,'-b 1');
                 
                 
             toc;   