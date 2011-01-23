
function [c,lambda,max1]=cross_validate(all_histL,yapp,nbclass,kernel,kerneloption,verbose)
    
number_of_images=size(all_histL,1);
rand_list=1:number_of_images;

all_histL2=all_histL(rand_list,:);

% all_histL2=all_histL;

yapp2=yapp(rand_list,:);
% yapp2=yapp;

lambda = [1e-2,1e-3,1e-4,1e-5,1e-6];
c=[10,50,100,175,250,500,1000,2000,5000];

MM=zeros(length(c),length(lambda));
kfold=5;
mask=ones(size(MM));

for i = 1:kfold              % (i)th-fold in CV
% [ValidSamples, ValidLabels, TrainSamples, TrainLabels] = kfolddata(all_histL2', yapp2', kfold, i);
     [ValidSamples, ValidLabels, TrainSamples, TrainLabels] =nfoldCV(all_histL2',yapp2,kfold,i);
    for j=1:length(c)
        for kk=1:length(lambda)
            if(mask(j,kk)==1)
                 [xsup,w,b,nbsv]=svmmulticlassoneagainstall(TrainSamples',TrainLabels',nbclass,c(j),lambda(kk),kernel,kerneloption,verbose);

                 [ypred,maxi] = svmmultival(ValidSamples',xsup,w,b,nbsv,kernel,kerneloption);

                 MM(j,kk)=MM(j,kk)+sum(ypred==ValidLabels')/(length(ypred))/kfold;
            end
        end
    end
    LL=sort(MM(:));
    mask=MM>(LL(floor(length(LL)/2)));
    if(sum(mask(:)==0)==size(mask,1)*size(mask,2))
        mask=ones(size(mask));
    end

% LL{i}=MM;
end
                        %[max1,max2]=max(MM(size(MM,1):-1:1,:));         % if equal we prefer higher c
[max1,max2]=max(MM); 
[max1,m_l]=max(max1);
m_c=max2(m_l);
lambda=lambda(m_l);
                        %c=c(length(c)+1-m_c);
c=c(m_c);

