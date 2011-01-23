function []=Descriptor(opts,descriptor_opts)

if nargin<2
    descriptor_opts=[];
end

% run descriptor on data set
if ~isfield(descriptor_opts,'type');               descriptor_opts.type='SIFT';               end
if ~isfield(descriptor_opts,'detector_name');      descriptor_opts.detector_name='Grid';      end
if ~isfield(descriptor_opts,'name');               descriptor_opts.name=strcat(descriptor_opts.type,descriptor_opts.detector_name); end

try
    descriptor_opts2=getfield(load([opts.data_globalpath,'/',descriptor_opts.name]),'detector_opts');
    if(isequal(descriptor_opts,descriptor_opts2))
        descriptor_flag=0;
        display('descriptor has already been computed for this settings');
    else
        descriptor_flag=1;
        display('Overwriting descriptor with same name, but other descriptor settings !!!!!!!!!!');
    end
catch
    descriptor_flag=1;
end

if(descriptor_flag)
    load(opts.image_names);
    load(opts.data_locations);
    nimages=opts.nimages;

       for i=1:nimages
      
         % SIFT descriptor
        if (strcmp(descriptor_opts.type,'SIFT'))
            points_out=load([data_locations{i},'/',descriptor_opts.detector_name]);
            points = getfield(points_out,descriptor_opts.detector_name);
            Do_Sift(sprintf('%s/%s',opts.imgpath,image_names{i}),descriptor_opts.name,data_locations{i},points);    
            points=[];
            points_out=[];
        end
      end

    save([opts.data_globalpath,'/',descriptor_opts.name],'descriptor_opts');
end
