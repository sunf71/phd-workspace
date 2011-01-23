function []=Do_Vocabulary_Segmentation(opts,vocabulary_opts)

load(opts.image_names);
load(opts.data_locations);

nimages=opts.nimages;
load(opts.trainset)
points_total1=[];points_total2=[];points_total=[];

counter=1;
for i=1:nimages
    if(trainset(i)==1)
i
        %%%%%%%%%%%%% in case of only 1 detector (detector as well) %%%%
         points_out=load([data_locations{i},'/',vocabulary_opts.descriptor_name]);
         points = getfield(points_out,'descriptor_points'); 
         
        %%%%%%%% Selecting the points based on sample rate %%%%%
        %%%%%%%% Conventional method %%%%%%%%%%
         sample_step=ceil(size(points,1)/vocabulary_opts.sample_rate);
         points=points(1:sample_step:size(points,1),:);

%         %%%%%%%%%%%%%% for all the images %%%%%%%%%%%%%%%
           points_total1=[points_total1;points];
    end
    
end

    if(strcmp(vocabulary_opts.type,'Kmeans')) %%% conventional kmeans 
             [IDX,voc,sumdist]=kmeans(points_total1, vocabulary_opts.size,'EmptyAction','singleton','display','final');
             save ([opts.data_vocabularypath,'/',vocabulary_opts.name],'voc');
             save ([opts.data_vocabularypath,'/',vocabulary_opts.name,'_settings'],'vocabulary_opts');
             display('Kmeans vocabulary computed');
             pause
             
        elseif(strcmp(vocabulary_opts.type,'fastkmeans')) %%% Fast kmeans                    
             [voc,IDX]=Fast_kmeans(points_total1, vocabulary_opts.size);
             save ([opts.data_vocabularypath,'/',vocabulary_opts.name],'voc');
             save ([opts.data_vocabularypath,'/',vocabulary_opts.name,'_settings'],'vocabulary_opts');
             display('FastKmeans vocabulary computed');
             pause
             
        elseif(strcmp(vocabulary_opts.type,'sparse')) %%% Sparse Coding vocabularies (NIPS 2006 and CVPR 2009)
            display('start computing sparse vocabulary');
            nBases=500;
            beta=1e-3;
            gamma = 0.15;
            num_iters=15;
            [voc, S, stat] = reg_sparse_coding(points_total1', nBases, eye(nBases), beta, gamma, num_iters);
            save ([opts.data_vocabularypath,'/',vocabulary_opts.name],'voc');
            display('Sparse vocabulary computed');
%             pause

        elseif(strcmp(vocabulary_opts.type,'hikmeans')) %%% hierarchical kmeans (ECCV 2008)
            %%%% in case of hierarchical kmeans , both vocabulary construction
            %%%% and assignment are done together 
            Do_hikmeans(opts,vocabulary_opts,points_total1)
            
        elseif(strcmp(vocabulary_opts.type,'ikmeans')) %%% Integer kmeans (ECCV 2008)
            %%%% in case of integer kmeans , both vocabulary construction
            %%%% and assignment are done together 
%             Do_ikmeans_par_new(opts,vocabulary_opts,points_total1)
%               vl_setup
            % % % %%%%%%%% compute the hikmeans vocabulary 
%             points_total1=im2uint8(points_total1);
            display('Computing The Vocabulary Now !!!!!');
            [voc,A] = vl_ikmeans(points_total1',vocabulary_opts.size,'method', 'elkan');
            save ([opts.data_vocabularypath,'/',vocabulary_opts.name],'voc');
            display('Integer Kmeans vocabulary computed');
             pause
    end


