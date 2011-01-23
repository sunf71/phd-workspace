% MULTICLASS SVM USING ONE AGAINST ALL 
%%%% to incorporate 10 classes
%-----------------------------------------------------
%   Learning and Learning Parameters
c = 1000;
epsilon = .000001;
kerneloption= 1;
kernel='gaussian';
verbose = 0;
nbclass=10;
svm1=[];
svm2=[];
lambda=1e-7;
svm_score_flag=1;
all_list=[];
perclass_image=40;
total_image=400;

yapp=[];
% For SVM_score, Craeting a class_list
 for jj=1:nbclass
    class_list{jj}=[];
    yapp=[yapp; jj*ones(30,1)];
 end
 %---------------------One Against All algorithms----------------
 % for 10 (total-N) test images

 for N=30:30;                   % number of test images
    num_test=perclass_image-N;
    total=total_image-N*nbclass;
    [xx,GT]=ndgrid(1:num_test,1:nbclass);
    for ii=1:100
        all_histL=[];
        all_histT=[];
        list=randperm(perclass_image);
        for jj=1:nbclass
            all_histL=[all_histL;all_hist(:,list(1:N)+(jj-1)*perclass_image)'];
            all_histT=[all_histT;all_hist(:,list(N+1:perclass_image)+(jj-1)*perclass_image)'];            
        end
        all_histL2=[all_hist(:,list(1:N)),all_hist(:,list(1:N)+40), all_hist(:,list(1:N)+80), all_hist(:,list(1:N)+120), all_hist(:,list(1:N)+160), all_hist(:,list(1:N)+200), all_hist(:,list(1:N)+240),all_hist(:,list(1:N)+280),all_hist(:,list(1:N)+320),all_hist(:,list(1:N)+360)]';
        all_histT2=[all_hist(:,list(N+1:perclass_image)),all_hist(:,list(N+1:perclass_image)+40), all_hist(:,list(N+1:perclass_image)+80), all_hist(:,list(N+1:perclass_image)+120), all_hist(:,list(N+1:perclass_image)+160), all_hist(:,list(N+1:perclass_image)+200), all_hist(:,list(N+1:perclass_image)+240),all_hist(:,list(N+1:perclass_image)+280),all_hist(:,list(N+1:perclass_image)+320),all_hist(:,list(N+1:perclass_image)+360)]';
        %yapp=[1*ones(1,N) 2*ones(1,N) 3*ones(1,N) 4*ones(1,N) 5*ones(1,N) 6*ones(1,N) 7*ones(1,N)]';

        [xsup,w,b,nbsv]=svmmulticlassoneagainstall(all_histL,yapp,nbclass,c,lambda,kernel,kerneloption,verbose);
        [ypred,maxi] = svmmultival(all_histT,xsup,w,b,nbsv,kernel,kerneloption);

        svm2(ii,:)=( sum( reshape(ypred,size(GT,1),size(GT,2))==GT  ) )/num_test;
        svm1(ii)=( sum(ypred==GT(:)) )/total;

         %only works when the flag is set, used to calculate SVM_SCORE   
         if(svm_score_flag)
             list2=[];
             for jj=1:nbclass
                 list2=[list2,list(N+1:perclass_image)+(jj-1)*perclass_image];
             end
             for jj=1:nbclass
                    temp=class_list{jj};
                    class_list{jj}=[temp,list2(ypred(1:nbclass*num_test)==jj)];
             end
             all_list=[all_list,list2];
         end
    end
% FOR DISPLAYING THE AVERAGE MEAN AND THE MEAN PER EACH CLASS
    disp(' ');
    disp('The MEAN IS = ');
    disp(mean(svm1))
    disp('The MEAN per class = ');
    disp(mean(svm2))

end





