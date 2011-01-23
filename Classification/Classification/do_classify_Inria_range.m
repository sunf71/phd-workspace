function All_hist=do_classify_Inria_range(opts,classification_opts,start_images, end_images,assignment_opts)
load(opts.image_names);
load(opts.data_locations);
count_it=1;
  patch_step=7;

for ijk=17213:17393
      
   count_it=count_it+1;
%       if(count_it>197)
         patch_step=8;
%       end
im=imread(sprintf('%s/%s',opts.imgpath,image_names{ijk}));
index=getfield(load([data_locations{ijk},'/',classification_opts.assignment_name,'_hybridindex']),'assignments');
            
All_hist=Convert_Image_Hist_Inria(opts,assignment_opts,index,im,patch_step,data_locations{ijk});
save ([data_locations{ijk},'/','histogram_test_sift'],'All_hist');
       
end
