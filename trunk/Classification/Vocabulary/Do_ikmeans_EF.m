function []=Do_ikmeans_EF(opts,vocabulary_opts,points_total1)
load(opts.image_names);
load(opts.data_locations);
nimages=opts.nimages;
all_hist=[];
%% compute the vocabualry compression using the method of ECCV 2008 (AIB)
vl_setup
%%%%%%%% compute the hikmeans vocabulary 
points_total1=im2uint8(points_total1);
[voc,A] = vl_ikmeans(points_total1',vocabulary_opts.size,'method', 'elkan');

%%%%%%%%%%%% Save the vocabulary %%%%%%%
save ([opts.data_vocabularypath,'/',vocabulary_opts.name],'voc');
save ([opts.data_vocabularypath,'/',vocabulary_opts.name,'_settings'],'vocabulary_opts');
% voc=voc';
display('Computing the Assignment Now !!!!!!!!!!');
%%%%%%%% compute the assignment part
for i=1:nimages
      points_out=load([data_locations{i},'/',vocabulary_opts.descriptor_name]);
      points_out = getfield(points_out,'descriptor_points');
      points_out=im2uint8(points_out);
      path=vl_ikmeanspush(points_out',voc);
      index_list{i}=path;
      %%% compute assignment 
      all_hist(:,i)=vl_ikmeanshist(vocabulary_opts.size,path);
end
All_hist=normalize(all_hist,1);
%%%%%%%%%%%% save the voc, the indexes and the histogram 

save ([opts.data_assignmentpath,'/',vocabulary_opts.name],'All_hist');
save ([opts.data_assignmentpath,'/',vocabulary_opts.name,'_settings'],'vocabulary_opts');
save ([opts.data_assignmentpath,'/',vocabulary_opts.name,'_hybrid_index'],'index_list');