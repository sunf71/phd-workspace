function Do_Detect(opts,detector_opts)
%% Performs features extraction step on a set of images
% Detector types supported are:
% "HarrLap", "DOG_Dorko", "Grid_Dorko", "HarLapv1_MS", "BoostHarLapv1_MS",
% "LoG_MS", "BoostLoG_MS"

if nargin < 2
    detector_opts = [];
end

display('Computing detector');

%% Adjust the parameters

if ~isfield(detector_opts, 'type');
    detector_opts.type{1} = 'Unknown';
end

if ~isfield(detector_opts, 'grey_flag');
    detector_opts.grey_flag = 'Unknown';
end

if ~isfield(detector_opts, 'scale');
    detector_opts.scale = 'Unknown';
end

if ~isfield(detector_opts, 'grid_step');
    detector_opts.grid_step = 'Unknown';
end

if ~isfield(detector_opts, 'name');
    detector_opts.name{1} = detector_opts.type{1};
end

%% Start the detection step

load(opts.image_names);
load(opts.data_locations);

for type = 1:length(detector_opts.type)

    % Detector name used to save the results
    detector_name = detector_opts.name{type};

    parfor i = 1:opts.nimages

        % Get the image ready
        imageName = sprintf('%s/%s',opts.imgpath, image_names{i});

        % Location for saving the results
        image_dir = data_locations{i};

        if exist([image_dir, '/', detector_name '.mat']) == 2
            continue;
        end

        display(sprintf('==> Processing Image (%04d/%04d)', i, opts.nimages));

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

        % Harris Laplacian detector
        if (strcmp(detector_opts.type{type}, 'HarrLap'))
            % Apply the detector on the images.
            % If it was applied before just ignore this step.
            if exist(sprintf('%s/%s.Harpoints.txt', ...
                data_locations{i}, image_names{i})) ~= 2
                % Call the script to perform the detection from Dorko's library
                detectCMD = sprintf('%s %s/%s.pgm %s %s %s', ...
                    which('compute_HarrLap_Dorko.bash'), ...
                    data_locations{i}, image_names{i}, image_names{i}, ...
                    data_locations{i}, ...
                    fileparts(which('compute_HarrLap_Dorko.bash')));
                system(detectCMD);
            end

            % Load the detector points computed above
            points_load = load_vector(sprintf('%s/%s.Harpoints.txt', ...
                data_locations{i}, image_names{i}));

            points1 = reshape(points_load, 4, size(points_load, 1) / 4);
            detector_points = points1';
        end

        % DOG detector
        if (strcmp(detector_opts.type{type}, 'DOG_Dorko'))
            % Apply the detector on the images.
            % If it was applied before just ignore this step.
            if exist(sprintf('%s/%s.DOGDorkopoints.txt', ...
                data_locations{i}, image_names{i})) ~= 2
                % Call the script to perform the detection from Dorko's library
                detectCMD = sprintf('%s %s/%s.pgm %s %s %s', ...
                    which('compute_DOG_Dorkopar.bash'), ...
                    data_locations{i}, image_names{i}, image_names{i}, ...
                    data_locations{i}, ...
                    fileparts(which('compute_DOG_Dorkopar.bash')));
                system(detectCMD);
            end

            % Load the detector points computed above
            points_load = load_vector(sprintf('%s/%s.DOGDorkopoints.txt', ...
                data_locations{i}, image_names{i}));

            points1 = reshape(points_load, 4, size(points_load, 1) / 4);
            detector_points = points1';
        end

        % Grid detector
        if (strcmp(detector_opts.type{type},'Grid_Dorko'))
            % Apply the detector on the images.
            % If it was applied before just ignore this step.
            if exist(sprintf('%s/%s.Gridpoints.txt', ...
                data_locations{i}, image_names{i})) ~= 2
                % Call the script to perform the detection from Dorko's library
                detectCMD = sprintf('%s %s/%s.pgm %s %s %s', ...
                    which('compute_Gridpar.bash'), ...
                    data_locations{i}, image_names{i}, image_names{i}, ...
                    data_locations{i}, ...
                    fileparts(which('compute_Gridpar.bash')));
                system(detectCMD);
            end

            % Load the detector points computed above
            points_load = load_vector(sprintf('%s/%s.Gridpoints.txt', ...
                data_locations{i}, image_names{i}));

            points1 = reshape(points_load, 4, size(points_load, 1) / 4);
            detector_points = points1';
        end

        % Harris Laplacian meanshift
        if (strcmp(detector_opts.type{type},'HarLapv1_MS'))
           detector_points = Do_HarrLapv1_MS(sprintf('%s/%s', ...
               opts.imgpath, image_names{i}), ...
               detector_opts.name, data_locations{i});
        end

        % Boosted Harris Laplacian Meanshift
        if (strcmp(detector_opts.type{type},'BoostHarLapv1_MS'))
           detector_points = Do_BoostHarrLapv1_MS(sprintf('%s/%s', ...
               opts.imgpath, image_names{i}), ...
               detector_opts.name, data_locations{i});
        end

        % Laplacian of Gaussian Meanshift
        if (strcmp(detector_opts.type{type},'LoG_MS'))
            detector_points = Do_LoG_MS(sprintf('%s/%s', ...
                opts.imgpath,image_names{i}), ...
                detector_opts.name,data_locations{i});   
        end

        % Boosted Laplacian of Gaussian Meanshift
        if (strcmp(detector_opts.type{type},'BoostLoG_MS'))
             detector_points = Do_BoostLoG_MS(sprintf('%s/%s', ...
                 opts.imgpath,image_names{i}), ...
                 detector_opts.name,data_locations{i});
        end

        % Save the results
        saveDetection([image_dir, '/', detector_name], detector_points);
    end
end

end

%% A helper function for the parfor to save the results
% Know more about Transparency:
% http://www.mathworks.com/help/toolbox/distcomp/bq__cs7-1.html#brdqrmd-1
function saveDetection(file, detector_points)
    save(file, 'detector_points')
end
