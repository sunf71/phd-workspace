function []=Do_vocabulary(opts,vocabulary_opts)
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
     if ~isfield(vocabulary_opts,'alpha');         vocabulary_opts.alpha=[0.1:.1:.9];                end 
     if ~isfield(vocabulary_opts,'beta');         vocabulary_opts.beta=[0.1:.1:.9];                  end 
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
points_total1=[];points_total2=[];points_total_alpha=[];points_total3=[];points_total=[];
h = waitbar(0,'Reading descriptors...');
for i=1:nimages
    if(trainset(i)==1)
%            i
%            data_locations{i}
         
        points_out=load([data_locations{i},'/',vocabulary_opts.descriptor_name]);
        points = getfield(points_out,'descriptor_points'); 
       % points=points(:,1:128);
        sample_step=ceil(size(points,1)/vocabulary_opts.sample_rate);
        points=points(1:sample_step:size(points,1),:);
        points_total1=[points_total1;points];
        if(vocabulary_opts.fusion_flag)
            points_out2=load([data_locations{i},'/',vocabulary_opts.descriptor_name2]);
            points2 = getfield(points_out2,'descriptor_points');
            points2=points2(1:sample_step:size(points2,1),:);
            %points=[points,points2];
            points_total2=[points_total2;points2];
            
            
            %%%% to incorporate the 3rd feature
            points_out3=load([data_locations{i},'/',vocabulary_opts.descriptor_name3]);
            points3 = getfield(points_out3,'descriptor_points');
            points3=points3(1:sample_step:size(points3,1),:);
            %points=[points,points2];
            points_total3=[points_total3;points3];
        end   
    end
    waitbar(i/nimages,h);
end
close(h);

if(vocabulary_opts.fusion_flag)
    for iii=1:length(vocabulary_opts.beta)
       for jj=1:length(vocabulary_opts.alpha)
           if isfield(vocabulary_opts,'name');           vocabulary_opts.name1=strcat(vocabulary_opts.name,'_',num2str(vocabulary_opts.alpha(jj)*10)); end           
           if ~isfield(vocabulary_opts,'name');          vocabulary_opts.name1=strcat(vocabulary_opts.type,vocabulary_opts.descriptor_name,vocabulary_opts.descriptor_name2,vocabulary_opts.descriptor_name3,num2str(vocabulary_opts.size),'_',num2str(vocabulary_opts.alpha(jj)*10),'_',num2str(vocabulary_opts.beta(jj)*10)); end
           points_total_alpha=[(1-vocabulary_opts.alpha(jj))*points_total1,vocabulary_opts.alpha(jj)*points_total2];
           points_total=[(1-vocabulary_opts.beta(iii))*points_total_alpha,vocabulary_opts.beta(jj)*points_total3];
%            [IDX,voc,sumdist]=kmeans(points_total, vocabulary_opts.size,'EmptyAction','singleton','display','final');
            [voc,IDX]=Fast_kmeans(points_total, vocabulary_opts.size);
           save ([opts.data_vocabularypath,'/',vocabulary_opts.name1],'voc');
           save ([opts.data_vocabularypath,'/',vocabulary_opts.name1,'_settings'],'vocabulary_opts');
           vocabulary_opts.name1=[];
       end
    end
else
%                  [IDX,voc,sumdist]=kmeans(points_total1, vocabulary_opts.size,'EmptyAction','singleton','display','final');
  [voc,IDX]=Fast_kmeans(points_total1, vocabulary_opts.size);
       save ([opts.data_vocabularypath,'/',vocabulary_opts.name],'voc');
       save ([opts.data_vocabularypath,'/',vocabulary_opts.name,'_settings'],'vocabulary_opts');
end

save ([opts.data_vocabularypath,'/','points_total'],'points_total');    % TEMPARORY
