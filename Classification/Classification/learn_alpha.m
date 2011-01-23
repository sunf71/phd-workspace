function [all_histL,all_hist,alpha]=learn_alpha(all_histL,all_hist,c,lambda,yapp,nbclass,kernel,kerneloption,verbose,start_row,end_row,start_row2,end_row2)

number_of_images=size(all_histL,1);
rand_list=1:number_of_images;


all_histL2=all_histL(rand_list,:);
yapp2=yapp(rand_list,:);
alphas=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
kfold=5;
QQ=zeros(length(alphas),1);

for i = 1:kfold              % (i)th-fold in CV
%    [ValidSamples, ValidLabels, TrainSamples, TrainLabels] = kfolddata(all_histL2', yapp2', kfold, i);
[ValidSamples, ValidLabels, TrainSamples, TrainLabels] =nfoldCV(all_histL2',yapp2,kfold,i);
   for ij=1:length(alphas)
            train_hist=[((1-alphas(ij)).*TrainSamples(start_row:end_row,:));alphas(ij).*TrainSamples(start_row2:end_row2,:)];    
            valid_hist=[((1-alphas(ij)).*ValidSamples(start_row:end_row,:));alphas(ij).*ValidSamples(start_row2:end_row2,:)];
            [xsup,w,b,nbsv]=svmmulticlassoneagainstall(train_hist',TrainLabels',nbclass,c,lambda,kernel,kerneloption,verbose);
            [ypred,maxi] = svmmultival(valid_hist',xsup,w,b,nbsv,kernel,kerneloption);
            QQ(ij)=QQ(ij)+sum(ypred==ValidLabels')/((length(ypred))*kfold);
   end
end
QQ;
[max1,max2]=max(QQ);
alpha=alphas(max2);
if (size(all_hist,1)>end_row2)
    all_hist=[(1-alpha).*all_hist(start_row:end_row,:);alpha.*all_hist(start_row2:end_row2,:);all_hist(end_row2+1:size(all_hist,1),:)];
    all_histL=[(1-alpha).*all_histL(:,start_row:end_row),alpha.*all_histL(:,start_row2:end_row2),all_histL(:,end_row2+1:size(all_hist,1))];
else
    all_hist=[(1-alpha).*all_hist(start_row:end_row,:);alpha.*all_hist(start_row2:end_row2,:)];
    all_histL=[(1-alpha).*all_histL(:,start_row:end_row),alpha.*all_histL(:,start_row2:end_row2)];
end
