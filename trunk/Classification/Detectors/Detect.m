function []=Detect(opts,detector_opts)
if nargin<2
    detector_opts=[];
end

% run detector on data set
if ~isfield(detector_opts,'type');      detector_opts.type='Grid';             end
if ~isfield(detector_opts,'name');      detector_opts.name=detector_opts.type; end
if ~isfield(detector_opts,'grey_flag'); detector_opts.grey_flag=0;             end
if ~isfield(detector_opts,'scale');     detector_opts.scale=4;                 end
if ~isfield(detector_opts,'grid_step'); detector_opts.grid_step=10;            end

try
    detector_opts2=getfield(load([opts.data_globalpath,'/',detector_opts.name]),'detector_opts');
    if(isequal(detector_opts,detector_opts2))
        detect_flag=0;
        display('detector has already been computed for this settings');
    else
        detect_flag=1;
        display('Overwriting detector with same name, but other detector settings !!!!!!!!!!');
    end
catch
    detect_flag=1;
end

if(detect_flag==1)
    load(opts.image_names);
    load(opts.data_locations);
    nimages=opts.nimages;

    for i=1:nimages
        % Difference of Gaussian (Color possible) )
        if (strcmp(detector_opts.type,'DoG'))
             DoG_color(sprintf('%s/%s',opts.imgpath,image_names{i}),detector_opts.name,data_locations{i},diag(3),0,detector_opts.grey_flag);                
        end
        % Grid Detection
        if (strcmp(detector_opts.type,'Grid'))
             GridDetection(sprintf('%s/%s',opts.imgpath,image_names{i}),detector_opts.name,data_locations{i},detector_opts.scale,detector_opts.grid_step);   
        end
    end
    save([opts.data_globalpath,'/',detector_opts.name],'detector_opts');
end