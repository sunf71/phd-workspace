function [best_alpha,all_histL,all_hist,best_C,bestcv]=Do_learn_alpha_libSVM1(all_histL,all_hist,yapp,cc,start_row,end_row,start_row2,end_row2,trainset)
            

all_histL2=all_hist';

bestcv=0;
alphas=(.1:.1:.9);
number_of_c=10;
for i=1:length(alphas)
    for jj=1:number_of_c
        cc=20^(1+0.15*(jj-1));
        cmd = ['-v 5 -t 0 -c ', num2str(cc)];
all_hist1=[(1-alphas(i)).*all_histL2(:,start_row:end_row),alphas(i).*all_histL2(:,start_row2:end_row2)];
traindata=all_hist1(trainset>0,:);
cv = svmtrain(yapp,traindata,cmd);
        if (cv >= bestcv),
        bestcv = cv; best_alpha=alphas(i);best_C =cc;
        end
    end
end

if (size(all_hist,1)>end_row2)
    all_hist=[(1-best_alpha).*all_hist(start_row:end_row,:);best_alpha.*all_hist(start_row2:end_row2,:);all_hist(end_row2+1:size(all_hist,1),:)];
    all_histL=[(1-best_alpha).*all_histL(:,start_row:end_row),best_alpha.*all_histL(:,start_row2:end_row2),all_histL(:,end_row2+1:size(all_hist,1))];
else
    all_hist=[(1-best_alpha).*all_hist(start_row:end_row,:);best_alpha.*all_hist(start_row2:end_row2,:)];
    all_histL=[(1-best_alpha).*all_histL(:,start_row:end_row),best_alpha.*all_histL(:,start_row2:end_row2)];
end

 