
function [ValidSamples, ValidLabels, TrainSamples, TrainLabels] =nfoldCV(all_hist,labels,nn,kk)
% n-fold cross validation
% trainset contains labels

if(size(labels,1)==1)
    labels=labels';
end

sizeT=size(labels,1);

index=( 1 : sizeT )';

for jj=1:nn
   folds{jj}=zeros(sizeT,1); 
end


for jj=1:max(labels) % until number of classes
    total=sum(labels==jj);
    step_size=total/nn;

    indexC=index(labels==jj); % indexes refering to current class    
    %indexC=indexC(randperm(length(indexC)));
    
    for ii=1:nn 
        foldT=folds{ii};
        foldT(indexC( 1+round(step_size*(ii-1)) : round(step_size*ii) ))=jj;
        folds{ii}=foldT;
    end
end
ValidLabels2=folds{kk};
ValidLabels=ValidLabels2(ValidLabels2>0)';
ValidSamples=all_hist(:,(ValidLabels2>0));
TrainLabels=labels(ValidLabels2==0)';
TrainSamples=all_hist(:,ValidLabels2==0);