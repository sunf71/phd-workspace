function Do_Descriptor(opts, descriptor_opts)
%% Calculates a descriptor's value based on extracted features.
% Descriptors supported are:
% "SIFT_Dorko", "SIFT_Dorko_Rot", "Opp_SIFT"

if nargin < 2
    detector_opts = [];
end

display('Computing descriptor');

%% Adjust the parameters

if ~isfield(descriptor_opts,'color_scale');
    descriptor_opts.color_scale='Unknown';
end

if ~isfield(descriptor_opts,'mirror_flag');
    descriptor_opts.mirror_flag='Unknown';
end

if ~isfield(descriptor_opts,'normalize_patch_size');
    descriptor_opts.normalize_patch_size='Unknown';
end

if ~isfield(descriptor_opts,'type');
    descriptor_opts.type='Unkown';
end

if ~isfield(descriptor_opts,'detector_name');
    descriptor_opts.detector_name='Unknown';
end

if ~isfield(descriptor_opts,'scale_magnif');
    descriptor_opts.scale_magnif='Unknown';
end

if ~isfield(descriptor_opts,'name');
    descriptor_opts.name = ...
        strcat(descriptor_opts.type,descriptor_opts.detector_name);
end

%% Check that descriptor with the same settings wasn't previously
% calculated

try
    descriptor_opts.detector_settings = getfield( ...
        load([opts.data_globalpath, '/', descriptor_opts.detector_name, ...
        '_settings']),'detector_opts');
catch
    descriptor_opts.detector_settings='Unknown';   
end

descriptor_flag=1;

try
    descriptor_opts2 = getfield(load([opts.data_globalpath, '/', ...
        descriptor_opts.name]),'descriptor_opts');
    if(isequal(descriptor_opts, descriptor_opts2))
        descriptor_flag = 0;
        display('Descriptor has already been computed for this settings');
    else
        display(['Overwriting descriptor with same name, but other ' ...
            'descriptor settings!']);
    end
end

if(descriptor_flag == 0)
    return;
end

%% Start the descriptor step

load(opts.image_names);
load(opts.data_locations);

for i = 1:opts.nimages
    
    display(sprintf('==> Processing Image (%04d/%04d)', i, opts.nimages));
    
    % Get the image ready
    imageName = sprintf('%s/%s', opts.imgpath, image_names{i});

    % Descriptor name used to save the results
    descriptor_name = descriptor_opts.name;

    % Location for saving the results
    image_dir=data_locations{i};
    
    % Convert the image into PGM format (The framework we use for
    % detection requires pgm format for images).
    % If it was already converted before just ignore this step.
    if exist(sprintf('%s/%s.pgm', ...
            data_locations{i}, image_names{i})) ~= 2
        convertPGM = sprintf('%s %s %s/%s.pgm', ...
            which('convert_pgm.sh'), ...
            imageName, data_locations{i}, image_names{i});
        system(convertPGM);
    end
    
    % Load the detector points
    points_out=load([data_locations{i}, '/', ...
        descriptor_opts.detector_name]);
    points_detect = getfield(points_out, 'detector_points');  

    % Prepare detector's points for the descriptor
    if(size(points_detect, 2) < 4)
        save_points(sprintf('%s/%s.detector_points.txt', ...
            data_locations{i}, image_names{i}), ...
            [points_detect, zeros(size(points_detect, 1), 1)]);
    else
        save_points(sprintf('%s/%s.detector_points.txt', ...
            data_locations{i}, image_names{i}), points_detect);
    end

    % SIFT Descriptor
    if (strcmp(descriptor_opts.type,'SIFT_Dorko'))
        % Call the script to perform the SIFT description from Dorko's
        % library only if it's not calculated before
        if exist(sprintf('%s/%s.siftpoints.txt', ...
            data_locations{i}, image_names{i})) ~= 2
            describeCMD = sprintf('%s %s/%s.pgm %s %d %s', ...
                which('compute_sift.bash'), ...
                data_locations{i}, image_names{i}, image_names{i}, ...
                descriptor_opts.scale_magnif, data_locations{i});
            system(describeCMD);
        end
        
        % Load the dscriptor points computed above
        points_load = load_vector(sprintf('%s/%s.siftpoints.txt', ...
            data_locations{i}, image_names{i}));

        points_sift = reshape(points_load, 132, ...
            size(points_load, 1) / 132);
        points2 = points_sift(5:132, :);
        descriptor_points = points2';
    end
    
    % Rotation Invariance SIFT
    if (strcmp(descriptor_opts.type,'SIFT_Dorko_Rot'))
        % Call the script to perform the SIFT description from Dorko's
        % library only if it's not calculated before
        if exist(sprintf('%s/%s.siftrotpoints.txt', ...
            data_locations{i}, image_names{i})) ~= 2
            describeCMD = sprintf('%s %s/%s.pgm %s %d %s', ...
                which('compute_sift_rot.bash'), ...
                data_locations{i}, image_names{i}, image_names{i}, ...
                descriptor_opts.scale_magnif, data_locations{i});
            system(describeCMD);
        end
        
        % Load the dscriptor points computed above
        points_load = load_vector(sprintf('%s/%s.siftrotpoints.txt', ...
            data_locations{i}, image_names{i}));

        points_sift = reshape(points_load, 132, ...
            size(points_load, 1) / 132);
        points2 = points_sift(5:132, :);
        descriptor_points = points2';
    end
    
    % Opponent SIFT
    if (strcmp(descriptor_opts.type,'Opp_SIFT'))

        image = imread(imageName);
        image = im2double(image);
        [O1, O2, O3] = RGB2O(image);

        WriteImage(O1, sprintf('%s/%s.O1', data_locations{i}, ...
            image_names{i}));
        O1tif = sprintf('%s/%s.O1.tif', data_locations{i}, image_names{i});
        convertCMD = sprintf('convert %s %s/%s.O1.pgm', ...
            O1tif, data_locations{i}, image_names{i});
        system(convertCMD);
        
        WriteImage(O2, sprintf('%s/%s.O2', data_locations{i}, ...
            image_names{i}));
        O2tif = sprintf('%s/%s.O2.tif', data_locations{i}, image_names{i});
        convertCMD = sprintf('convert %s %s/%s.O2.pgm', ...
            O2tif, data_locations{i}, image_names{i});
        system(convertCMD);

        WriteImage(O3, sprintf('%s/%s.O3', data_locations{i}, ...
            image_names{i}));
        O3tif = sprintf('%s/%s.O3.tif', data_locations{i}, image_names{i});
        convertCMD = sprintf('convert %s %s/%s.O3.pgm', ...
            O3tif, data_locations{i}, image_names{i});
        system(convertCMD);        
        
        % For channel O1: Call the bash script to perform the SIFT
        % description from Dorko's library

        imageO1Name = strcat(image_names{i}, '.O1');

        % Prepare detector's points for the descriptor
        if(size(points_detect, 2) < 4)
            save_points(sprintf('%s/%s.detector_points.txt', ...
                data_locations{i}, imageO1Name), ...
                [points_detect, zeros(size(points_detect, 1), 1)]);
        else
            save_points(sprintf('%s/%s.detector_points.txt', ...
                data_locations{i}, imageO1Name), points_detect);
        end

        % Call the script to perform the SIFT description from Dorko's
        % library only if it's not calculated before
        if exist(sprintf('%s/%s.siftpoints.txt', ...
            data_locations{i}, imageO1Name)) ~= 2
            describeCMD = sprintf('%s %s/%s.pgm %s %d %s', ...
                which('compute_sift.bash'), ...
                data_locations{i}, imageO1Name, imageO1Name, ...
                descriptor_opts.scale_magnif, data_locations{i});
            system(describeCMD);
        end

        % Load the dscriptor points computed above
        points_load = load_vector(sprintf('%s/%s.siftpoints.txt', ...
            data_locations{i}, imageO1Name));
        points_sift = reshape(points_load, 132, size(points_load, 1) / 132);
        points1 = points_sift(5:132, :);
        descriptor_points = points1;
        
        % For channel O2: Call the bash script to perform the SIFT
        % description from Dorko's library

        imageO2Name = strcat(image_names{i}, '.O2');

        % Prepare detector's points for the descriptor
        if(size(points_detect, 2) < 4)
            save_points(sprintf('%s/%s.detector_points.txt', ...
                data_locations{i}, imageO2Name), ...
                [points_detect, zeros(size(points_detect, 1), 1)]);
        else
            save_points(sprintf('%s/%s.detector_points.txt', ...
                data_locations{i}, imageO2Name), points_detect);
        end

        % Call the script to perform the SIFT description from Dorko's
        % library only if it's not calculated before
        if exist(sprintf('%s/%s.siftpoints.txt', ...
            data_locations{i}, imageO1Name)) ~= 2
            describeCMD = sprintf('%s %s/%s.pgm %s %d %s', ...
                which('compute_sift.bash'), ...
                data_locations{i}, imageO2Name, imageO2Name, ...
                descriptor_opts.scale_magnif, data_locations{i});
            system(describeCMD);
        end

        % Load the dscriptor points computed above
        points_load = load_vector(sprintf('%s/%s.siftpoints.txt', ...
            data_locations{i}, imageO2Name));
        points_sift = reshape(points_load, 132, size(points_load, 1) / 132);
        points2 = points_sift(5:132, :);
        descriptor_points = [descriptor_points; points2];
        
        % For channel O3: Call the bash script to perform the SIFT
        % description from Dorko's library

        imageO3Name = strcat(image_names{i}, '.O3');

        % Prepare detector's points for the descriptor
        if(size(points_detect, 2) < 4)
            save_points(sprintf('%s/%s.detector_points.txt', ...
                data_locations{i}, imageO3Name), ...
                [points_detect, zeros(size(points_detect, 1), 1)]);
        else
            save_points(sprintf('%s/%s.detector_points.txt', ...
                data_locations{i}, imageO3Name), points_detect);
        end

        % Call the script to perform the SIFT description from Dorko's
        % library only if it's not calculated before
        if exist(sprintf('%s/%s.siftpoints.txt', ...
            data_locations{i}, imageO1Name)) ~= 2
            describeCMD = sprintf('%s %s/%s.pgm %s %d %s', ...
                which('compute_sift.bash'), ...
                data_locations{i}, imageO3Name, imageO3Name, ...
                descriptor_opts.scale_magnif, data_locations{i});
            system(describeCMD);
        end

        % Load the dscriptor points computed above
        points_load = load_vector(sprintf('%s/%s.siftpoints.txt', ...
            data_locations{i}, imageO3Name));
        points_sift = reshape(points_load, 132, size(points_load, 1) / 132);
        points3 = points_sift(5:132, :);
        descriptor_points = [descriptor_points; points3] / 3;
        descriptor_points = descriptor_points ./ (eps + ones(size( ...
            descriptor_points, 1), 1) * sum(descriptor_points));
        descriptor_points = descriptor_points';
    end
    
    save([image_dir, '/', descriptor_name], 'descriptor_points');
end
