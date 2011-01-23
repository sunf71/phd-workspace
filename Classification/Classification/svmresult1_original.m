%function svmresult =svmresult()
c = inf;
epsilon = .000001;
kerneloption= 1;
kernel='gaussian';
verbose = 0;
for N=10:10:100;
    total=240-(N+N);
    for ii=1:100
        list=randperm(120);
        labels=[ones(1,N),-1*ones(1,N)];
        all_histL=[all_hist(:,list(1:N)),all_hist(:,list(1:N)+120)];
        all_histT=[all_hist(:,list(N+1:120)),all_hist(:,list(N+1:120)+120)];
        [xsup,w,b,pos]=svmclass(all_histL',labels',c,epsilon,kernel,kerneloption,verbose);
        ypred = svmval(all_histT',xsup,w,b,kernel,kerneloption);

        testmar=(120-(N));
        svm1(ii)=(sum(ypred(1:testmar)>0)+sum(ypred(testmar+1:total)<0))/total
    end
    Themean(N/10)=mean(svm1);
    disp(' ');
    disp('The MEAN IS = ');
    disp(mean(svm1))
    svmcurve=[0;svm1(ii);1];
end
Naxis=[10:10:100];

figure(1);plot(Naxis,Themean,'--R','LineWidth',2);
xlabel('Number of Training Image Set')
ylabel('Classification Rate')
title('The Classification results obtained through SVM')