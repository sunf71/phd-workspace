%function svmresult =svmresult()
c = inf;
epsilon = .000001;
kerneloption= 1;
kernel='gaussian';
verbose = 1;
list=randperm(120);
labels=[ones(1,100),-1*ones(1,100)];
all_histL=[all_hist(:,list(1:100)),all_hist(:,list(1:100)+120)];
all_histT=[all_hist(:,list(101:120)),all_hist(:,list(101:120)+120)];
[xsup,w,b,pos]=svmclass(all_histL',labels',c,epsilon,kernel,kerneloption,verbose);
ypred = svmval(all_histT',xsup,w,b,kernel,kerneloption);
svm1=(sum(ypred(1:20)>0)+sum(ypred(21:40)<0))/40
figure(1);plot(list,svm1);

