function [best_C,best_CV]=Do_CV_libSVM_pascal_ikm(traindata,labels_L)
             best_CV=0;
%display('Inside cross validation method')
%pause
            %c_val=[1,2,3,4,5,20];
             c_val=[1,2,3,4,5,20];
            display('5 values of c ');
%             cvs = zeros(size(c_val));
            for jj=1:length(c_val) %%%% loop over the number of C parameters 

            cc=c_val(jj);
            cmd = ['-v 5 -t 4 -s 0 -c ', num2str(cc)];
            cv = svmtrain(labels_L,traindata, cmd);
               if (cv >= best_CV),
               best_CV = cv; best_C =cc;
               end
            
            end
            
            
            
            