function folds=nfoldCV(train_set,nn)
% n-fold cross validation
% trainset contains labels

if(size(train_set,1)==1)
    train_set=train_set';
end

sizeT=size(train_set,1);

index=( 1 : sizeT )';

for jj=1:nn
   folds{jj}=zeros(sizeT,1); 
end


for jj=1:max(train_set) % until number of classes
    total=sum(train_set==jj);
    step_size=total/nn;

    indexC=index(train_set==jj); % indexes refering to current class    
    %indexC=indexC(randperm(length(indexC)));
    
    for ii=1:nn 
        foldT=folds{ii};
        foldT(indexC( 1+round(step_size*(ii-1)) : round(step_size*ii) ))=jj;
        folds{ii}=foldT;
    end
end