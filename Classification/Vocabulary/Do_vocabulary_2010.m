function []=Do_vocabulary_2010(opts,vocabulary_opts)
if nargin<2
    vocabulary_opts=[];
end
display('Computing Vocabulary');

% run Vocabulary on data set
if ~isfield(vocabulary_opts,'fusion_flag');        vocabulary_opts.fusion_flag=0;                   end  %% 1 --> early fusion, o--> late fusion
if ~isfield(vocabulary_opts,'descriptor_name');    vocabulary_opts.descriptor_name='Unknown';       end
if ~isfield(vocabulary_opts,'descriptor_name2');   vocabulary_opts.descriptor_name2='Unknown';      end 

if ~isfield(vocabulary_opts,'type');               vocabulary_opts.type='Kmeans';                   end
if ~isfield(vocabulary_opts,'size');               vocabulary_opts.size='Unknown';                  end
if ~isfield(vocabulary_opts,'sample_rate');        vocabulary_opts.sample_rate='Unknown';           end
%%%% The vocabulary name depends on fusion flag as in case of early fusion
if(vocabulary_opts.fusion_flag)
    %%%%%% In case of early fusion both descriptor names are required
     if ~isfield(vocabulary_opts,'alpha');         vocabulary_opts.alpha=[0:.1:1];                  end 
else
   %%%%%% In case of late fusion single descriptor names is required 
     if ~isfield(vocabulary_opts,'name');          vocabulary_opts.name=strcat(vocabulary_opts.type,vocabulary_opts.descriptor_name,num2str(vocabulary_opts.size)); end
end    

%if ~isfield(vocabulary_opts,'detector_type');      vocabulary_opts.detector_type='Unknown';                                           end
%if ~isfield(vocabulary_opts,'descriptor_type');    vocabulary_opts.descriptor_type='Unknown';                                         end

try
    vocabulary_opts2=getfield(load([opts.data_vocabularypath,'/',vocabulary_opts.name,'_settings']),'vocabulary_opts');
    if(isequal(vocabulary_opts,vocabulary_opts2))
        display('vocabulary is recomputed');
    else
        display('Overwriting vocabulary with same name, but other vocabulary settings !!!!!!!!!!');
    end
end

load(opts.image_names);
load(opts.data_locations);

nimages=opts.nimages;
load(opts.trainset)
points_total1=[];points_total2=[];points_total=[];
h = waitbar(0,'Reading descriptors...');
counter=1;
for i=1:1
    if(trainset(i)==1)
i
counter
counter=counter+1;
        %%%%%%%%%%%%% in case of only 1 detector (detector as well) %%%%
%          points_out=load([data_locations{i},'/',vocabulary_opts.descriptor_name]);
%          points = getfield(points_out,'descriptor_points'); 

%           points=[];
%         %%%%%%%%%%%% if using 3 detectors %%%%%%%%%%%%%
          points_out=load([data_locations{i},'/',vocabulary_opts.descriptor_name]);
          points_det1 = getfield(points_out,'descriptor_points'); 
          sample_step_det1=ceil(size(points_det1,1)/vocabulary_opts.sample_rate);
          points_sample_det1=points_det1(1:sample_step_det1:size(points_det1,1),:);
%           
% %           %%%%% detector 2 (normally its DoG dorko detector  %%%%
          points_out_det2=load([data_locations{i},'/',vocabulary_opts.descriptor_name2]);
          points_det2 = getfield(points_out_det2,'descriptor_points'); 
          sample_step_det2=ceil(size(points_det2,1)/vocabulary_opts.sample_rate);
          points_sample_det2=points_det2(1:sample_step_det2:size(points_det2,1),:);
%           
%           %%%%% detector 3 (normally its Grid Dorko detector  %%%%
          points_out_det3=load([data_locations{i},'/',vocabulary_opts.descriptor_name3]);
          points_det3 = getfield(points_out_det3,'descriptor_points'); 
          sample_step_det3=ceil(size(points_det3,1)/vocabulary_opts.sample_rate_grid);
          points_sample_det3=points_det3(1:sample_step_det3:size(points_det3,1),:);
%           
%           %%%%%%%%%% 2 additional detectors 
          points_out_det4=load([data_locations{i},'/',vocabulary_opts.descriptor_name4]);
          points_det4 = getfield(points_out_det4,'descriptor_points'); 
          sample_step_det4=ceil(size(points_det4,1)/vocabulary_opts.sample_rate);
          points_sample_det4=points_det4(1:sample_step_det4:size(points_det4,1),:);
          
%           points_out_det5=load([data_locations{i},'/',vocabulary_opts.descriptor_name5]);
%           points_det5 = getfield(points_out_det5,'descriptor_points'); 
%           sample_step_det5=ceil(size(points_det5,1)/vocabulary_opts.sample_rate);
%           points_sample_det5=points_det5(1:sample_step_det5:size(points_det5,1),:);
%           
%           %%%%%%%%%%% combine all 3 together %%%%%%%%%%
             points=[points_sample_det1;points_sample_det2;points_sample_det3;points_sample_det4];
%               points=[points_sample_det1;points_sample_det2];
%         points=[points_sample_det1];
        %%%%%%%% Selecting the points based on sample rate %%%%%
        %%%%%%%% Conventional method %%%%%%%%%%
%          sample_step=ceil(size(points,1)/vocabulary_opts.sample_rate);
%          points=points(1:sample_step:size(points,1),:);

%         %%%%%%%%%%%%%% for all the images %%%%%%%%%%%%%%%
           points_total1=[points_total1;points];

        if(vocabulary_opts.fusion_flag)
            points_out2=load([data_locations{i},'/',vocabulary_opts.descriptor_name2]);
            points2 = getfield(points_out2,'descriptor_points');
            points2=points2(1:sample_step:size(points2,1),:);
            %points=[points,points2];
            points_total2=[points_total2;points2];
        end   
    end
    waitbar(i/nimages,h);
end
close(h);
% save ([opts.data_vocabularypath,'/','points_total1'],'points_total1');    % TEMPARORY

if(vocabulary_opts.fusion_flag)
       for jj=1:length(vocabulary_opts.alpha)
           if isfield(vocabulary_opts,'name');           vocabulary_opts.name1=strcat(vocabulary_opts.name,'_',num2str(vocabulary_opts.alpha(jj)*10)); end           
           if ~isfield(vocabulary_opts,'name');          vocabulary_opts.name1=strcat(vocabulary_opts.type,vocabulary_opts.descriptor_name,vocabulary_opts.descriptor_name2,num2str(vocabulary_opts.size),'_',num2str(vocabulary_opts.alpha(jj)*10)); end
           points_total=[(1-vocabulary_opts.alpha(jj))*points_total1,vocabulary_opts.alpha(jj)*points_total2];
%              [IDX,voc,sumdist]=kmeans(points_total, vocabulary_opts.size,'EmptyAction','singleton','display','final');
               [voc,IDX]=Fast_kmeans(points_total, vocabulary_opts.size);
%              Do_ikmeans(opts,vocabulary_opts,points_total)
             save ([opts.data_vocabularypath,'/',vocabulary_opts.name1],'voc');
             save ([opts.data_vocabularypath,'/',vocabulary_opts.name1,'_settings'],'vocabulary_opts');
             vocabulary_opts.name1=[];
%             display('vocabulary computed');
%             pause
       end
else
    if(strcmp(vocabulary_opts.type,'Kmeans')) %%% conventional kmeans 
             [IDX,voc,sumdist]=kmeans(points_total1, vocabulary_opts.size,'EmptyAction','singleton','display','final');
             save ([opts.data_vocabularypath,'/',vocabulary_opts.name],'voc');
             save ([opts.data_vocabularypath,'/',vocabulary_opts.name,'_settings'],'vocabulary_opts');

        elseif(strcmp(vocabulary_opts.type,'fastkmeans')) %%% Fast kmeans            
            size(points_total1)
%              vl_setup
%             % %%%%%%%% compute the hikmeans vocabulary 
%               points_total1=im2uint8(points_total1);
%               display('Computing The Vocabulary Now !!!!!');
%               [voc,A] = vl_ikmeans(points_total1',10000,'method', 'elkan');
%               save ('/home/fahad/Matlab_code/voc_combine_OppSIFT_10000','voc');
%               display('vocabulary computed and saved Now !!!!!!');
%               pause

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
            Do_ikmeans_par_new(opts,vocabulary_opts,points_total1)
    end
end

%save ([opts.data_vocabularypath,'/','points_total'],'points_total');    % TEMPARORY
