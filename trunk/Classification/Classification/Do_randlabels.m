function []=Do_randlabels(opts,randlabels_opts)

% run Assignment on data set
if nargin<2
    assignment_opts=[];
end

display('Computing labels');

 load(opts.labels)
 nclasses=opts.nclasses;
 [max1,max2]=max(labels,[],2);
 

 [train_truth,test_truth]=train_test_split(max2,randlabels_opts.fold);
%  trainset=zeros(size(train_truth));
%  testset=zeros(size(test_truth));
%  a=find(train_truth>0);
%  b=find(test_truth>0);
%  trainset(a,:)=1;
%  testset(b,:)=1;
 trainset=double(train_truth>0);
 testset=double(test_truth>0);
 
 save ([opts.annopath,'/','trainset'],'trainset');
  save ([opts.annopath,'/','testset'],'testset');
  
%  save ([opts.annopath,'/','train_truth'],'train_truth');
%  save ([opts.annopath,'/','test_truth'],'test_truth');