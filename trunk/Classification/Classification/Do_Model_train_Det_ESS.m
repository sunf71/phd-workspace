function [model,weights]=Do_Model_train_Det_ESS(traindata,labels_L,best_C,opts,classification_opts)

tic;
%     options=sprintf('-t 0 -b 1 -c %f',best_C);

%     options=sprintf('-s 0 -t 0 -w1 10 -w-1 1 -c %f  -b 1',best_C);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 cost=10;  % cost=100 better ?
 cc=100;   % cost=100 better ?
 att=find(labels_L<1);
 labels_L(att,:)=-1;
 options=sprintf('-s 0 -t 0 -w1 %d -w-1 1 -c %f',cost,cc);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
 model=svmtrain(labels_L,traindata,options);
 weights=full(model.SVs)'*model.sv_coef;
%  weights=-weights;


    toc;
    
    %%%%%%%%%%%% Save Model and Weights %%%%%%%%%%%%%
%      save_weights(sprintf('%s//w.weight',opts.resultfolder),-weights);       % save the weights in a file

     save([opts.data_globalpath,'/',classification_opts.cls_name,'_weights'],'weights');
     save([opts.data_globalpath,'/',classification_opts.cls_name,'_model'],'model');
     save_weights(sprintf('%s//w.weight',opts.data_globalpath),weights);