function []=Do_Compute_Feature_image_Segmentation1(opts,descriptor_opts)

 load(opts.image_names);
    load(opts.data_locations);
    nimages=opts.nimages;
    
    display('Started Computed features ');
    for i=5001:nimages 
         i
      
            %%%%%% SIFT descriptor
            if (strcmp(descriptor_opts.type,'DSIFT'))
                im=imread(sprintf('%s/%s',opts.imgpath,image_names{i}));
                im=sum(im,3)/3;
                I=im;
                Is = vl_imsmooth(I, sqrt((descriptor_opts.binSize/descriptor_opts.magnif)^2 - .25)) ;
                [f, d] = vl_dsift(im2single(Is), 'size', descriptor_opts.binSize) ;

            end
            image_dir=data_locations{i};
            descriptor_points=d';
            detector_points=f';
            
            
            save ([image_dir,'/',descriptor_opts.type],'descriptor_points')
            save ([image_dir,'/',descriptor_opts.type,descriptor_opts.detector_name],'detector_points')
    end
    display('Descriptor computed');
    pause