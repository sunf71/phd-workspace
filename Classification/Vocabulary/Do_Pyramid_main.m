function []=Do_Pyramid_main(opts,pyramid_opts)

% run Spatial Pyramid on data set
if nargin<2
    pyramid_opts=[];
end

display('Computing Spatial Pyramid');

if ~isfield(pyramid_opts,'histogram_name');    pyramid_opts.histogram_name='Unknown';          end    %%%%%%%% The name of  histogram 
if ~isfield(pyramid_opts,'index_name');        pyramid_opts.index_name='Unknown';              end    %%%%%%%% The name of  index 
if ~isfield(pyramid_opts,'name');              pyramid_opts.name='Unknown';                    end    %%%%%%%% The name of spatial pyramid histogram
if ~isfield(pyramid_opts,'detector_name');     pyramid_opts.detector_name='Unknown';           end    %%%%%%%% The name of detector to be used
if ~isfield(pyramid_opts,'dictionary_size');   pyramid_opts.dictionary_size='Unknown';         end    %%%%%%%% The size of dictionary
if ~isfield(pyramid_opts,'pyramidtype');       pyramid_opts.pyramidtype='Unknown';             end    %%%%%%%% The pyramid type to be used
if ~isfield(pyramid_opts,'pyramidslevel');     pyramid_opts.pyramidslevel='Unknown';           end    %%%%%%%% Thelevels of pyramids to be used

try
    pyramid_opts2=getfield(load([opts.data_assignmentpath,'/',pyramid_opts.name,'_settings']),'pyramid_opts');
    if(isequal(pyramid_opts,pyramid_opts2))
        display('Recomputing Spatial Pyramids for this settings');
    else
        display('Overwriting Spatial Pyramid with same name, but other Pyramid settings !!!!!!!!!!');
    end
end

%%                              %%%%%%%%%%% Build Spatial Pyramids %%%%%%%%%%%
load(opts.image_names);
load(opts.data_locations);
nimages=opts.nimages;

%%%%% Get the structure containing indexes, x and y points and width and height of image

im_index=Do_Getindex(sprintf('%s/%s',opts.imgpath,image_names{i}),data_locations{i},pyramid_opts,opts);

             for i=1:nimages %%%%%% loop over number of images
                    pyramid_all = Do_createpyramid(im_index,pyramid_opts.pyramidLevels,pyramid_opts.pyramidtype);

                    % compute histogram intersection kernel
                    K = hist_isect(pyramid_all, pyramid_all); 


                    
             end % for loop 

            
          
            