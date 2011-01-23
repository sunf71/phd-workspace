function [bestc,bestg,bestcv]=Do_CV_libSVM_chisq(traindata,labels_L)
%             best_CV=0;
%             number_of_c=3;
%           gamma = [0.1,0.2,0.3];
%           c_val=[100,500,1000];
%             for jj=1:number_of_c
%                 for kk=1:length(gamma)
% %              cc=20^(1+0.15*(jj-1));
%              gm=gamma(kk);
%              cc=c_val(jj)
%              gm
%             cmd = ['-v 5 -t 2 -g -c ',  num2str(gm), num2str(cc)];
%             cv = svmtrain(labels_L,traindata, cmd);
%                 if (cv >= best_CV),
%                 best_CV = cv; best_C =cc;
%                 end
%                 end
%             end


%% Cross-validation for 2 parameters (C and gamma ) selection        ..... Inspired from LibSVM example

bestcv=0;
gamma = [0.1,0.01,0.01];
%           c=[200,500,1000,2000,3000];
%   c=[100,300,500,1000,3000,5000];
%          c=[20,200,300,400,500,700,2000,3000,5000]; %soccer
%      c=[2000,3000,5000];
 c=[5000];

for i=1:length(c)
    for j=1:length(gamma)
        good_c=c(i);
        good_g=gamma(j);
        cmd=['-v 5 -c  ', num2str(c(i)), ' -g ', num2str(gamma(j))];
        cv = svmtrain(labels_L,traindata, cmd);
        if (cv >= bestcv),
            bestcv= cv; bestc= good_c; bestg= good_g;
        end
%         fprintf('%g %g %g (best c=%g, gamma=%g, accuracy=%g) \n', c, gamma, cv, bestc, bestg, bestcv);
    end
end