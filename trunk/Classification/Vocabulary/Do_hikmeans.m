function []=Do_hikmeans(opts,vocabulary_opts,points_total1)
load(opts.image_names);
load(opts.data_locations);
nimages=opts.nimages;
all_hist=[];
ind_arr=[];
%% compute the hierarchical vocabualry computation using the method of ECCV 2008 (AIB)
vl_setup
%%%%%%%% compute the hikmeans vocabulary 
points_total1=im2uint8(points_total1);
[tree,A] = vl_hikmeans(points_total1',vocabulary_opts.K,vocabulary_opts.nleaves);
depth=tree.depth;

%%%%%%%% compute the assignment part
for i=1:nimages
      points_out=load([data_locations{i},'/',vocabulary_opts.descriptor_name]);
      points_out = getfield(points_out,'descriptor_points');
      points_out=im2uint8(points_out);
      path=vl_hikmeanspush(tree,points_out');
%         index_list{i}=path;
      %%% compute assignment 
      all_hist(:,i)=vl_hikmeanshist(tree,path);
       for jj=1:size(points_out,1)
       ab=vl_hikmeanshist(tree,path(:,jj));
       abcd=find(ab==1);
       ind_arr=[ind_arr,abcd];
       end
       index_list{i}=ind_arr(depth,:);
       ind_arr=[];
end
%%%% save only the leaf nodes %%%%%
hist_leaf_start=1+sum(vocabulary_opts.K.^[0:1:depth]);
All_hist=normalize(all_hist(hist_leaf_start:end,:),1);
%%%%%%%%%%%% save the voc, the indexes and the histogram 
save ([opts.data_vocabularypath,'/',vocabulary_opts.name],'tree');
save ([opts.data_vocabularypath,'/',vocabulary_opts.name,'_settings'],'vocabulary_opts');
save ([opts.data_assignmentpath,'/',vocabulary_opts.name],'All_hist');
save ([opts.data_assignmentpath,'/',vocabulary_opts.name,'_settings'],'vocabulary_opts');
save ([opts.data_assignmentpath,'/',vocabulary_opts.name,'_hybrid_index'],'index_list');
