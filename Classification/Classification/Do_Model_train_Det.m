function model=Do_Model_train_Det(traindata,labels_L,best_C,parameter_retrain)
% n = size(traindata,1);
% K = traindata*traindata';
% K1 = [(1:n)', K];
tic;
   options=sprintf('-t 0 -b 1 -c %f',best_C);

%     options=sprintf('-t 4 -b 1 -s 0 -c %f',best_C);
%  options=sprintf('-t 4 -b 1 -s 0'); %%% if no c umcomment this line %%%%

 model=svmtrain(labels_L,traindata,options);

% model = svmtrain(labels_L,K1, options);
%                 [predict_label, accuracy , dec_values] = svmpredict(labels_T,testdata, model);


%%% for test data preparation %%%
% n1 = size(testdata,1);
% Ktest = testdata*testdata';
% K2 = [(1:n1)', Ktest];
%                   [pwconst_values, pwlinear_values, exact_values] = svmpredict(labels_T,testdata, model,'-b 1');
%   [exact_values, pwconst_values, pwlinear_values] = fastpredict(labels_T,testdata, model,'-b 1');
                 
%  [predict_label, accuracy , dec_values] = svmpredict(labels_L,traindata, model,'-b 1');
if(parameter_retrain)
save -v7.3 '/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Data/Global/BOW_Model_final_retrain4' model
else
    save -v7.3 '/home/fahad/Datasets/Pascal_2007_original/VOCdevkit/VOC2007/Data/Global/BOW_Model_final4' model
end
    toc;