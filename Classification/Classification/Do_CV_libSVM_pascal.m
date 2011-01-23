function [best_C,best_CV]=Do_CV_libSVM_pascal(traindata,labels_L)
            best_CV=0;

            c_val=[20,200,500,1000,2000,5000];

            for jj=1:size(c_val) %%%% loop over the number of C parameters 

            cc=c_val(jj);
            cmd = ['-v 5 -t 0 -c ', num2str(cc)];
            cv = svmtrain(labels_L,traindata, cmd);
                if (cv >= best_CV),
                best_CV = cv; best_C =cc;
                end
            end