function [best_alpha,all_histL,all_hist]=Do_learn_alpha_libSVM(all_histL,all_hist,yapp,cc,start_row,end_row,start_row2,end_row2,trainset)
            
% number_of_images=size(all_histL,1);
% rand_list=1:number_of_images;
% all_histL2=all_histL(rand_list,:);
% yapp2=yapp(rand_list,:);
% alphas=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
% QQ=zeros(length(alphas),1);
% kfold=5;
% 
% for i = 1:kfold              % (i)th-fold in CV
% 
% [ValidSamples, ValidLabels, TrainSamples, TrainLabels] =nfoldCV(all_histL2',yapp2,kfold,i);
%    for ij=1:length(alphas)
%               train_hist=[((1-alphas(ij)).*TrainSamples(start_row:end_row,:));alphas(ij).*TrainSamples(start_row2:end_row2,:)];    
%               valid_hist=[((1-alphas(ij)).*ValidSamples(start_row:end_row,:));alphas(ij).*ValidSamples(start_row2:end_row2,:)];
%               options=sprintf('-t 0 -c %f',cc);
%               model = svmtrain(TrainLabels',train_hist',options);
%               [predict_label, accuracy , dec_values] = svmpredict(ValidLabels',valid_hist',model);
% 
% %               QQ(ij)=QQ(ij)+sum(predict_label==ValidLabels')/((length(predict_label))*kfold);
%               QQ(ij)=QQ(ij)+accuracy(1)
%               
%     end
% end
% 
% 
% [max1,max2]=max(QQ);
% alpha=alphas(max2);
% if (size(all_hist,1)>end_row2)
%     all_hist=[(1-alpha).*all_hist(start_row:end_row,:);alpha.*all_hist(start_row2:end_row2,:);all_hist(end_row2+1:size(all_hist,1),:)];
%     all_histL=[(1-alpha).*all_histL(:,start_row:end_row),alpha.*all_histL(:,start_row2:end_row2),all_histL(:,end_row2+1:size(all_hist,1))];
% else
%     all_hist=[(1-alpha).*all_hist(start_row:end_row,:);alpha.*all_hist(start_row2:end_row2,:)];
%     all_histL=[(1-alpha).*all_histL(:,start_row:end_row),alpha.*all_histL(:,start_row2:end_row2)];
% end


%             for jj=1:number_of_alpha
%             
%             cmd = ['-v 5 -t 0 -c ', num2str(cc)];
%             cv = svmtrain(labels_L,traindata, cmd);
%                 if (cv >= best_CV),
%                 best_CV = cv; best_C =cc;
%                 end
%             end
all_histL2=all_hist';
cmd = ['-v 5 -t 0 -c ', num2str(cc)];
bestcv=0;
alphas=(.1:.1:.9);
for i=1:length(alphas)
all_hist1=[(1-alphas(i)).*all_histL2(:,start_row:end_row),alphas(i).*all_histL2(:,start_row2:end_row2)];
traindata=all_hist1(trainset>0,:);
cv = svmtrain(yapp,traindata,cmd);
if (cv >= bestcv),
bestcv = cv; best_alpha=alphas(i);
end
end

if (size(all_hist,1)>end_row2)
    all_hist=[(1-best_alpha).*all_hist(start_row:end_row,:);best_alpha.*all_hist(start_row2:end_row2,:);all_hist(end_row2+1:size(all_hist,1),:)];
    all_histL=[(1-best_alpha).*all_histL(:,start_row:end_row),best_alpha.*all_histL(:,start_row2:end_row2),all_histL(:,end_row2+1:size(all_hist,1))];
else
    all_hist=[(1-best_alpha).*all_hist(start_row:end_row,:);best_alpha.*all_hist(start_row2:end_row2,:)];
    all_histL=[(1-best_alpha).*all_histL(:,start_row:end_row),best_alpha.*all_histL(:,start_row2:end_row2)];
end