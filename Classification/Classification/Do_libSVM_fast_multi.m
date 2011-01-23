function [predict_label, accuracy , dec_values]=Do_libSVM_fast_multi(traindata,testdata,labels_L,labels_T,best_C)
% n = size(traindata,1);
% K = traindata*traindata';
% K1 = [(1:n)', K];
tic;
%% Linear Kernel
% options=sprintf('-t 0 -b 1 -c %f',best_C);

% options=sprintf('-t 4 -b 1 -s 0 -c %f',best_C);

%%% uncomment next line for b= true 1

%% Intersection kernel
  options=sprintf('-t 4 -b 1 -s 0 -c %f',best_C); %%%%% if using IKM
%  options=sprintf('-t 4 -s 0 -c %f',best_C); %%%%% if using IKM

%              options=sprintf('-t 2 -b 1 -g %f',best_G, '-c %f',best_C);       % used for Chi sqaure kernel 
%              options=['-t 2 -b 1 -c  ', num2str(best_C), ' -g ', num2str(best_G)];    % used for chi square kernel
%%
             
%       options=sprintf('-t 4  -s 0 -c %f',best_C);

%       options=sprintf('-t 4 -b 1 -s 0');

 model=svmtrain(labels_L,traindata,options);

% model = svmtrain(labels_L,K1, options);
%                 [predict_label, accuracy , dec_values] = svmpredict(labels_T,testdata, model);


%%% for test data preparation %%%
% n1 = size(testdata,1);
% Ktest = testdata*testdata';
% K2 = [(1:n1)', Ktest];
%   [pwconst_values, pwlinear_values, exact_values] = svmpredict(labels_T,testdata, model,'-b 1');
%   [exact_values, pwconst_values, pwlinear_values] = fastpredict(labels_T,testdata, model,'-b 1');
                 
                                      [predict_label, accuracy , dec_values] = svmpredict(labels_T,testdata, model,'-b 1');
%                                        [predict_label, accuracy , dec_values] = svmpredict(labels_T,testdata, model);
             toc;   
             
            