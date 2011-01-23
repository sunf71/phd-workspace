function [svm1,svm2]=Do_SVM(all_histL,all_histT,yapp,GT,kerneloption,kernel,nbclass,c,lambda,verbose)

% MULTICLASS SVM USING ONE AGAINST ALL 
%%%% to incorporate Multiclasses classes
%-----------------------------------------------------
%   Learning and Learning Parameters

numberIt=1;
svm1=zeros(numberIt,1);
svm2=zeros(numberIt,nbclass);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% cross validation 
%  [c,lambda,max_score]=cross_validate(all_histL,yapp,nbclass,kernel,kerneloption,verbose);

%%%%%%%%%%%%%%%%%%%%%%%%%%%  For Testing

total=size(all_histT,2);
num_test=size(GT,1);
fprintf(1,'\n'); 

  for ii=1:numberIt   
        fprintf(1,'\b%d',ii);
        
%          [xsup,w,b,nbsv]=svmmulticlassoneagainstall(all_histL',yapp,nbclass,c,lambda,kernel,kerneloption,verbose);
 [xsup,w,b,nbsv,classifier]=svmmulticlassoneagainstone(all_histL',yapp,nbclass,c,lambda,kernel,kerneloption,verbose);
 [ypred,maxi] = svmmultivaloneagainstone(all_histT',xsup,w,b,nbsv,kernel,kerneloption);
%          [ypred,maxi] = svmmultival(all_histT',xsup,w,b,nbsv,kernel,kerneloption);
        svm2(ii,:)=( sum( reshape(ypred,size(GT,1),size(GT,2))==GT  ) )/num_test;
        svm1(ii)=( sum(ypred==GT(:)) )/total;
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%  FOR DISPLAYING THE AVERAGE MEAN AND THE MEAN PER EACH CLASS
    disp(' ');
    disp('The MEAN IS = ');
    disp(mean(svm1))
    disp('The MEAN per class = ');
    disp(mean(svm2))
%     disp(sprintf('The SVM settings: c=%f and lambda=%f and svm_score=%f',c,lambda,max_score));
     disp(sprintf('The SVM settings: c=%f and lambda=%f',c,lambda));


