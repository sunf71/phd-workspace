function [best_C,best_CV]=Do_CV_libSVM_final(traindata,labels_L)
            best_CV=0;
            number_of_c=10;
            for jj=1:number_of_c
             cc=20^(1+0.15*(jj-1));
            cmd = ['-v 5 -t 0   -c ', num2str(cc)];
            cv = svmtrain(labels_L,traindata, cmd);
                if (cv >= best_CV),
                best_CV = cv; best_C =cc;
                end
            end