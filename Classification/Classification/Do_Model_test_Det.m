function [predict_label,accuracy,dec_values]=Do_Model_test_Det(test_histogram,labels_L,model)

 tic;
%          [dec_values, accuracy, predict_label] = fastpredict(labels_L,test_histogram, model,'-b 1');
       [predict_label, accuracy , dec_values] = svmpredict(labels_L,test_histogram, model,'-b 1');

%        prediction_windows=[prediction_windows;dec_values];

    toc;
% save -v7.3 '/home/fahad/Datasets/Inria/Data/Global/Assignment/predict_try' prediction_windows

