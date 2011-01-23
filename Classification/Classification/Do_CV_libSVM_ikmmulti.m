function [best_C,best_CV]=Do_CV_libSVM_ikmmulti(traindata,labels_L)
display('starting cross validation');
            best_CV=0;
            number_of_c=6;
            c_val=[1,2,3,4,5,20];

            for jj=1:number_of_c
%              cc=1^(1+0.15*(jj-1));
cc=c_val(jj);
            cmd = ['-v 5 -t 4 -s 0 -c ', num2str(cc)];
            cv = svmtrain(labels_L,traindata, cmd);
                if (cv >= best_CV),
                best_CV = cv; best_C =cc;
                end
            end