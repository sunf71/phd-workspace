%% Read the directory containing the dataset images
[filesearchdir, junk1, junk2, junk3] = fileparts('D:\Workspace\Research\RAVSegmentation\Shida-Images\');
filelist = dir(filesearchdir);

%% Iterate on the directory files
for fInd = 1:length(filelist)

    if (filelist(fInd).isdir == 0) % Make sure its not a dir
        %% Read the image
        orgIm = imread(fullfile(filesearchdir, filelist(fInd).name));
        
        % Apply reddish luminance to the image
%         orgIm = uint8(double(orgIm) .* repmat(cat(3, 0.9, 0.6, 0.75), ...
%                    size(orgIm, 1), size(orgIm, 2)));
               
        im = orgIm;

        %% Display the image
        fig = figure(1);
        imshow(orgIm);
        set(fig, 'Name', 'Original Image', 'NumberTitle','off');

        %% Apply some color correction to the image
        corr = 255 * (double(im) / 255) .^ 1.2;
        im = uint8(corr);
        % Also add some illumination to the image
        im = double(im) .* 1.5;

        %% Set the RAD segmentation parameters
        sizeDis = 250;  %100
        deriva = 3;     %3
        integra = 5;  %0.01
        thr = 0.0001;

        %% Set the image channels
        R = im(:, :, 1);
        G = im(:, :, 2);
        B = im(:, :, 3);
        
        %% Convert to color opponent space
        % - We will convert the image to the color opponent space
        % - We will afterwards work on every pair of the channels
        % separately to be able to work on a 2D version of ridges and be
        % able to analyze the ridges more precisely

        % Set the luminance channel
        WB = sum(im, 3) / 3; 
        
        % Set the Red-Green channel
        RG = R - G;
        RG = RG ./ 2 + 127.5;
        
        % Set the Blue-Yellow channel
        BY = (B .* 2) - R - G;
        BY = (BY ./ 4) + 127.5;

        % Now we want to work on every pair separately
        clear ims;
        ims(1, :, :, :) = uint8(cat(3, WB, BY));
        ims(2, :, :, :) = uint8(cat(3, WB, RG));
        ims(3, :, :, :) = uint8(cat(3, RG, BY));
        
        labels(1, :) = 'WB-BY';
        labels(2, :) = 'WB-RG';
        labels(3, :) = 'RG-BY';

        %% Iterate on color space pairs
        for pairs = 1:3
            %% Get the color histogram
            [h3, x, nbins] = histnd(reshape(double(ims(pairs, :, :, :)), [], 2), ...
                                    repmat([0:255 / sizeDis:255 - 1]', 1, 2));

            %% Get the ridges and the major color distributions of the image
            [ridgesFound, creasened, disSmooth] = maxCross(h3, deriva, integra, thr);

            %% Get the final segmentation result (Useless in our context)
%             [aprimada] = sortChulu(ridgesFound, disSmooth);
%             zonesInf;

            %% Get the useful region props of the image
            RPs = regionprops(double(ridgesFound), 'ConvexHull', 'Orientation');
            CH = RPs.ConvexHull;
            
            %% Show the colors distribution
            % Also plot the ridges above the color distribution
            % Also plot the convex hull of the ridges
            fig = figure(2);
            imagesc(double(disSmooth));
            set(fig, 'Name', labels(pairs, :), 'NumberTitle','off');

            hold on

            [X, Y] = find(ridgesFound == 1);
            % Plot the convex hull in yellow
            plot(CH(:, 1), CH(:, 2), 'y');
            % Plot the ridges values in white
            plot(Y, X, 'w.');

            hold off
            
            disSmooth(disSmooth==0)=NaN;
            figure(4),surf(flipud(double(disSmooth)),'edgecolor','none')
            % figure(5),imshow(ridgesFound)

            %% Select the regions to visualize the real image part
            while 1
                
                % Focus on the current image figure
                fig = figure(2);
                set(fig, 'Name', labels(pairs, :), 'NumberTitle','off');
                
                % Read the user's input
                points = ginput();

                % The user has to select 2 points
                if size(points, 1) ~= 2
                    break;
                end

                % Calculate the selected region parameters
                x1 = floor(min(points(1, 1), points(2, 1)));
                x2 = floor(max(points(1, 1), points(2, 1)));
                y1 = floor(min(points(1, 2), points(2, 2)));
                y2 = floor(max(points(1, 2), points(2, 2)));

                % Select the indices of the selected points
                channel1 = ismember(ims(pairs, :, :, 2), x1:x2);
                channel2 = ismember(ims(pairs, :, :, 1), y1:y2);

                % Intersect the indices from each channel
                intersection = channel1 .* channel2;

                % Now get the real image index
                selected = find(intersection == 1);

                % Now assign the temporary image and visualize it
                tmpIm = orgIm;

                tmpIm(selected) = 255;
                tmpIm(selected + size(tmpIm, 1) * size(tmpIm, 2)) = 0;
                tmpIm(selected + 2 * size(tmpIm, 1) * size(tmpIm, 2)) = 255;

                fig = figure(3);
                imshow(tmpIm);
                set(fig, 'Name', 'Selected in Magenta', 'NumberTitle','off');

            end
        end

        close all

    end
end;
