function []=Do_Segmentation_QuickShift(opts,descriptor_opts)

 counterss=1;
 load(opts.image_names);
 load(opts.data_locations);
 nimages=opts.nimages;
    
    display('Started Computed features ');
    for i=1:nimages
         i
      
            %%%%%% SIFT descriptor
            if (strcmp(descriptor_opts.type,'quickshift'))
                im=imread(sprintf('%s/%s',opts.imgpath,image_names{i}));
%                 im=sum(im,3)/3;
                I=im;
               [Iseg map]= vl_quickseg(I, descriptor_opts.ratio, descriptor_opts.kernelsize, descriptor_opts.maxdist);
               
                  labels = unique(map);
               % build adjacency matrix and counts
                  segs = struct('ind', [], 'count', [], 'color', [], 'adj', []);
                  map1 = circshift(map, [1 0]);
                  map1(1,:) = map(1,:);
                  map2 = circshift(map, [-1 0]);
                  map2(end,:) = map(end,:);
                  map3 = circshift(map, [0 1]);
                  map3(:,1) = map(:,1);
                  map4 = circshift(map, [0 -1]);
                  map4(:,end) = map(:,end);

                  for ij=1:length(labels)
                    ind = find(map(:) == labels(ij));
                    segs(ij).ind = ind;
                    segs(ij).count = length(ind);
                    [row col] = ind2sub(size(map), ind(1));
                    segs(ij).color = squeeze(Iseg(row, col, :));
                    adj = [map1(ind) map2(ind) map3(ind) map4(ind)];
                    adj = unique(adj(:));
                    adj = setdiff(adj, labels(ij));
                    segs(ij).adj = adj;
                  end


            end
            image_dir=data_locations{i};
            save ([image_dir,'/',descriptor_opts.type],'segs')
            save ([image_dir,'/',descriptor_opts.type,descriptor_opts.im_seg],'Iseg')
    end
    display('Segmentation Done !!!!!!');
    pause