function [best_C,best_CV]=Do_CV_libSVM_fast(traindata,labels_L)
% n = size(traindata,1);
% K = traindata*traindata';
% K1 = [(1:n)', K];
% tic;
% model=svmtrain(training_label_vector, training_instance_matrix, '-t 4 -s 0 ...');
            best_CV=0;
            number_of_c=2;
            for jj=1:number_of_c
               
                cc=20^(1+0.15*(jj-1));
%  cc=1;
%             cmd = ['-v 5 -t 0 -c ', num2str(cc)];
 cmd = ['-v 5 -t 4 -s 0 -c ', num2str(cc)];
             cv = svmtrain(labels_L,traindata, cmd);
% cv = svmtrain(labels_L,K1, cmd);
                if (cv >= best_CV),
                best_CV = cv; best_C =cc;
                end
            end
%             toc;