function [best_C,best_CV]=Do_CV_libSVM(traindata,labels_L)
              best_CV=0;
            number_of_c=10;
            for jj=1:number_of_c
             cc=20^(1+0.15*(jj-1));
            cmd = ['-v 5 -t 0 -c ', num2str(cc)];
            cv = svmtrain(labels_L,traindata, cmd);
                if (cv >= best_CV),
                best_CV = cv; best_C =cc;
                end
            end


%%%%%%%%%%%%%%%%%% Histogram Intersection Kernel(new on 21-4)
%             number_of_c=2;
%             c_val=[3,20];
%             for jj=1:number_of_c
%                 cc=c_val(jj);
%                 cmd = ['-v 5 -t 4 -s 0 -c ', num2str(cc)];
%                 cv = svmtrain(labels_L,traindata, cmd);
%                 if (cv >= best_CV),
%                 best_CV = cv; best_C =cc;
%                 end
%            end
%%%%%%%%%%%%%%%%%% Histogram Intersection Kernel            

% %%%%%%%%%%%%%%%Linear Kernel (new on 21-4)
%             best_CV=0;
%             number_of_c=10;
%             c_val=10;
%             for jj=1:number_of_c
%                cc=20^(1+0.15*(jj-1));
%              cc=c_val(jj);
%             cmd = ['-v 5 -t 0 -c ', num2str(cc)];
%             cv = svmtrain(labels_L,traindata, cmd);
%                 if (cv >= best_CV),
%                 best_CV = cv; best_C =cc;
%                 end
%             end
% %%%%%%%%%%%%%%%Linear Kernel            