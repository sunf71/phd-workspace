function [pwconst_values, pwlinear_values,exact_values]=Do_libSVM_fast_pep(traindata,testdata,labels_L,labels_T,best_C)
% n = size(traindata,1);
% K = traindata*traindata';
% K1 = [(1:n)', K];
tic;
% options=sprintf('-t 0 -b 1 -c %f',best_C);

  options=sprintf('-t 4 -b 1 -s 0 -c %f',best_C);
%  options=sprintf('-t 4 -b 1 -s 0'); %%% if no c umcomment this line %%%%

 model=svmtrain(labels_L,traindata,options);

% model = svmtrain(labels_L,K1, options);
%                 [predict_label, accuracy , dec_values] = svmpredict(labels_T,testdata, model);


%%% for test data preparation %%%
% n1 = size(testdata,1);
% Ktest = testdata*testdata';
% K2 = [(1:n1)', Ktest];
%                   [pwconst_values, pwlinear_values, exact_values] = svmpredict(labels_T,testdata, model,'-b 1');
  [exact_values, pwconst_values, pwlinear_values] = fastpredict(labels_T,testdata, model,'-b 1');
                 
  
  if model.Label(1) == 0
      t(:,1) = exact_values(:,2);
      t(:,2) = exact_values(:,1);
      exact_values = t;
  end
  
  
              
  toc;   