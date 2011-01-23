function []=Do_Descriptor(opts,descriptor_opts)

if nargin<2
    descriptor_opts=[];
end
display('Computing descriptor');

% run descriptor on data set
if ~isfield(descriptor_opts,'color_scale');                 descriptor_opts.color_scale='Unknown';                 end
if ~isfield(descriptor_opts,'mirror_flag');                 descriptor_opts.mirror_flag='Unknown';                 end
if ~isfield(descriptor_opts,'normalize_patch_size');        descriptor_opts.normalize_patch_size='Unknown';                 end
if ~isfield(descriptor_opts,'type');                        descriptor_opts.type='Unkown';                  end
if ~isfield(descriptor_opts,'detector_name');               descriptor_opts.detector_name='Unknown';        end
if ~isfield(descriptor_opts,'scale_magnif');                descriptor_opts.scale_magnif='Unknown';                 end
if ~isfield(descriptor_opts,'name');                        descriptor_opts.name=strcat(descriptor_opts.type,descriptor_opts.detector_name); end

descriptor_flag=1;

try
    descriptor_opts.detector_settings=getfield(load([opts.data_globalpath,'/',descriptor_opts.detector_name,'_settings']),'detector_opts');
catch
    descriptor_opts.detector_settings='Unknown';   
end

try
    descriptor_opts2=getfield(load([opts.data_globalpath,'/',descriptor_opts.name]),'descriptor_opts');
    if(isequal(descriptor_opts,descriptor_opts2))
        descriptor_flag=0;
        display('descriptor has already been computed for this settings');
    else
        display('Overwriting descriptor with same name, but other descriptor settings !!!!!!!!!!');
    end
end

if(descriptor_flag)
    load(opts.image_names);
    load(opts.data_locations);
    nimages=opts.nimages;
    h = waitbar(0,'Please wait...');
       for i=1:nimages
      
            %%%%%% SIFT descriptor
            if (strcmp(descriptor_opts.type,'SIFT'))
                points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
                points = getfield(points_out,'detector_points');
                Do_Sift(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points,descriptor_opts.scale_magnif);
%               Do_Sift_Dorko(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points);
                points=[];
                points_out=[];
            end
            if (strcmp(descriptor_opts.type,'SIFT_Dorko'))
                points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
                points = getfield(points_out,'detector_points');
                Do_Sift_Dorko(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points,descriptor_opts.scale_magnif);
                points=[];
                points_out=[];
            end
            if (strcmp(descriptor_opts.type,'SIFT_Dorko_color'))
                points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
                points = getfield(points_out,'detector_points');
                Do_Sift_Dorko_color1(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points,descriptor_opts.scale_magnif);
                
            end
            if (strcmp(descriptor_opts.type,'SIFT_Dorko_color_javier'))
                points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
                points = getfield(points_out,'detector_points');
                points_out=load(['/media/DATA/javier_color_space','/',descriptor_opts.channel,'/',image_names{i}(1:end-4)]);  %%%% RGB, LAB opts %%%
                channels = getfield(points_out,'imatge');
                Do_Sift_Dorko_color1_javier(channels,descriptor_opts.name,data_locations{i},points,descriptor_opts.scale_magnif);
                
            end
            %%%%% COLOR RGB Descriptors
            if (strcmp(descriptor_opts.type,'ColorRGB'))
                if (strcmp(descriptor_opts.detector_name,'Dense'))
%                 points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
%                 points = getfield(points_out,'detector_points');
                Do_ColorRGB(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},descriptor_opts.color_scale,descriptor_opts.scale_magnif); 
                elseif (strcmp(descriptor_opts.detector_name,'Grid'))
                   points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
                   points = getfield(points_out,'detector_points');
                   Do_ColorRGB(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points,descriptor_opts.scale_magnif);
                end
            end
            %%%%% COLOR HUE Descriptors
            if (strcmp(descriptor_opts.type,'ColorHUE'))
                if (strcmp(descriptor_opts.detector_name,'Dense'))
%                 points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
%                 points = getfield(points_out,'detector_points');
                Do_ColorHUE(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},descriptor_opts.scale_magnif); 
                 elseif (strcmp(descriptor_opts.detector_name,'Grid'))
                   points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
                   points = getfield(points_out,'detector_points');
                   Do_ColorHUE(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points,descriptor_opts.scale_magnif);
                end
            end
            %%%%% COLOR Naming Descriptors
            if (strcmp(descriptor_opts.type,'ColorNM'))
                if (strcmp(descriptor_opts.detector_name,'Dense'))
%                 points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
%                 points = getfield(points_out,'detector_points');
                  Do_ColorNM(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},descriptor_opts.color_scale,descriptor_opts.detector_name,descriptor_opts.normalize_patch_size); 
                   elseif (strcmp(descriptor_opts.detector_name,'Grid'))
                   points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
                   points = getfield(points_out,'detector_points');
                   Do_ColorNM(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points,descriptor_opts.scale_magnif,descriptor_opts.detector_name,descriptor_opts.normalize_patch_size);
                else
                   points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
                   points = getfield(points_out,'detector_points');
                   Do_ColorNM(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points,descriptor_opts.scale_magnif,descriptor_opts.detector_name,descriptor_opts.normalize_patch_size);
                end
            end
            %%%%% Opponent Descriptors
            if (strcmp(descriptor_opts.type,'Opp_Color'))
                if (strcmp(descriptor_opts.detector_name,'Dense'))
%                 points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
%                 points = getfield(points_out,'detector_points');
                  Do_ColorOPP(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},descriptor_opts.color_scale,descriptor_opts.detector_name,descriptor_opts.normalize_patch_size); 
                   elseif (strcmp(descriptor_opts.detector_name,'Grid'))
                   points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
                   points = getfield(points_out,'detector_points');
                   Do_ColorOPP(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points,descriptor_opts.scale_magnif,descriptor_opts.detector_name,descriptor_opts.normalize_patch_size);
                else
                   points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
                   points = getfield(points_out,'detector_points');
                   Do_ColorOPP(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points,descriptor_opts.scale_magnif,descriptor_opts.detector_name,descriptor_opts.normalize_patch_size,descriptor_opts.mirror_flag);
                end
            end
             %%%%% HUE Descriptors 7 , especially for Hybrid Fusion
            if (strcmp(descriptor_opts.type,'ColorHUE_7'))
                if (strcmp(descriptor_opts.detector_name,'Dense'))
%                 points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
%                 points = getfield(points_out,'detector_points');
                  Do_ColorHUE_7(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},descriptor_opts.color_scale,descriptor_opts.detector_name,descriptor_opts.normalize_patch_size); 
                   elseif (strcmp(descriptor_opts.detector_name,'Grid'))
                   points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
                   points = getfield(points_out,'detector_points');
                   Do_ColorHUE_7(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points,descriptor_opts.scale_magnif,descriptor_opts.detector_name,descriptor_opts.normalize_patch_size);
                else
                   points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
                   points = getfield(points_out,'detector_points');
                   Do_ColorHUE_7(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points,descriptor_opts.scale_magnif,descriptor_opts.detector_name,descriptor_opts.normalize_patch_size);
                end
            end
            
            
            waitbar(i/nimages,h);
       end
    close(h);
     save([opts.data_globalpath,'/',descriptor_opts.name],'descriptor_opts');
    save ([opts.data_globalpath,'/',descriptor_opts.name,'_settings'],'descriptor_opts');
end
