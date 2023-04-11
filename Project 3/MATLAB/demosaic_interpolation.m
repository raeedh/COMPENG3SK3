function demosaiced_img = demosaic_interpolation(img, pattern)
    if pattern == 'rggb'
        demosaiced_img = demosaic_rggb(img);
    elseif pattern == 'gbrg'
        demosaiced_img = demosaic_gbrg(img);
    elseif pattern == 'grbg'
        demosaiced_img = demosaic_grbg(img);
    elseif pattern == 'bggr'
        demosaiced_img = demosaic_bggr(img);
    end
end

function out_img = demosaic_rggb(mosaic_img)
    % Get the size of the input image
    [height, width] = size(mosaic_img);
    
    % Create an output RGB image
    out_img = zeros(height, width, 3);

    mosaic_img = double(mosaic_img);
    
    % Loop over each pixel in the mosaic image
    for i = 1:height-1
        for j = 1:width-1
            % Determine the color of the current pixel based on its position in the pattern
            c1 = mod(i, 2);  % 1 = Red, 2 = Green, 3 = Blue
            c2 = mod(j, 2);

            if (i == 1) || (j == 1)
                continue
            end
            
            % Interpolate the missing color channels based on surrounding pixels
            if c1 == 1 && c2 == 1  % Red
                out_img(i, j, 1) = mosaic_img(i, j);
                out_img(i, j, 2) = (mosaic_img(i, j-1) + mosaic_img(i, j+1) + mosaic_img(i-1, j) + mosaic_img(i+1, j))/4;
                out_img(i, j, 3) = (mosaic_img(i-1, j-1) + mosaic_img(i+1, j-1) + mosaic_img(i-1, j+1) + mosaic_img(i+1, j+1))/4;
            elseif c1 == 0 && c2 == 1  % Green 1
                out_img(i, j, 1) = (mosaic_img(i+1, j) + mosaic_img(i-1, j))/2;
                out_img(i, j, 2) = mosaic_img(i, j);
                out_img(i, j, 3) = (mosaic_img(i, j-1) + mosaic_img(i, j+1))/2;
            elseif c1 == 1 && c2 == 0  % Green 2
                out_img(i, j, 1) = (mosaic_img(i, j-1) + mosaic_img(i, j+1))/2;
                out_img(i, j, 2) = mosaic_img(i, j);
                out_img(i, j, 3) = (mosaic_img(i-1, j) + mosaic_img(i+1, j))/2;
            else  % Blue
                out_img(i, j, 1) = (mosaic_img(i-1, j-1) + mosaic_img(i+1, j-1) + mosaic_img(i-1, j+1) + mosaic_img(i+1, j+1))/4;
                out_img(i, j, 2) = (mosaic_img(i, j-1) + mosaic_img(i, j+1) + mosaic_img(i-1, j) + mosaic_img(i+1, j))/4;
                out_img(i, j, 3) = mosaic_img(i, j);
            end
        end
    end

    out_img = uint8(out_img);
end

function out_img = demosaic_bggr(mosaic_img)
    % Get the size of the input image
    [height, width] = size(mosaic_img);
    
    % Create an output RGB image
    out_img = zeros(height, width, 3);

    mosaic_img = double(mosaic_img);
    
    % Loop over each pixel in the mosaic image
    for i = 1:height-1
        for j = 1:width-1
            % Determine the color of the current pixel based on its position in the pattern
            c1 = mod(i, 2);  % 1 = Blue, 2 = Green, 3 = Red
            c2 = mod(j, 2);

            if (i == 1) || (j == 1)
                continue
            end
            
            % Interpolate the missing color channels based on surrounding pixels
            if c1 == 1 && c2 == 1  % Blue
                out_img(i, j, 1) = (mosaic_img(i-1, j-1) + mosaic_img(i+1, j-1) + mosaic_img(i-1, j+1) + mosaic_img(i+1, j+1))/4;
                out_img(i, j, 2) = (mosaic_img(i, j-1) + mosaic_img(i, j+1) + mosaic_img(i-1, j) + mosaic_img(i+1, j))/4;
                out_img(i, j, 3) = mosaic_img(i, j);
            elseif c1 == 0 && c2 == 1  % Green 1
                out_img(i, j, 1) = (mosaic_img(i, j-1) + mosaic_img(i, j+1))/2;
                out_img(i, j, 2) = mosaic_img(i, j);
                out_img(i, j, 3) = (mosaic_img(i+1, j) + mosaic_img(i-1, j))/2;
            elseif c1 == 1 && c2 == 0  % Green 2
                out_img(i, j, 1) = (mosaic_img(i-1, j) + mosaic_img(i+1, j))/2;
                out_img(i, j, 2) = mosaic_img(i, j);
                out_img(i, j, 3) = (mosaic_img(i, j-1) + mosaic_img(i, j+1))/2;
            else  % Red
                out_img(i, j, 1) = mosaic_img(i, j);
                out_img(i, j, 2) = (mosaic_img(i-1, j) + mosaic_img(i+1, j) + mosaic_img(i, j-1) + mosaic_img(i, j+1))/4;
                out_img(i, j, 3) = (mosaic_img(i-1, j-1) + mosaic_img(i+1, j-1) + mosaic_img(i-1, j+1) + mosaic_img(i+1, j+1))/4;
            end
        end
    end

    out_img = uint8(out_img);
end

function out_img = demosaic_gbrg(mosaic_img)
    % Get the size of the input image
    [height, width] = size(mosaic_img);
    
    % Create an output RGB image
    out_img = zeros(height, width, 3);

    mosaic_img = double(mosaic_img);
    
    % Loop over each pixel in the mosaic image
    for i = 1:height-1
        for j = 1:width-1
            % Determine the color of the current pixel based on its position in the pattern
            c1 = mod(i, 2);  % 1 = Green 1, 2 = Blue, 3 = Red
            c2 = mod(j, 2);  % 1 = Green 2, 2 = Red
            
            if (i == 1) || (j == 1)
                continue
            end
            
            % Interpolate the missing color channels based on surrounding pixels
            if c1 == 1 && c2 == 1  % Green 1
                out_img(i, j, 1) = (mosaic_img(i, j-1) + mosaic_img(i, j+1))/2;
                out_img(i, j, 2) = mosaic_img(i, j);
                out_img(i, j, 3) = (mosaic_img(i-1, j) + mosaic_img(i+1, j))/2;
            elseif c1 == 0 && c2 == 1  % Blue
                out_img(i, j, 1) = (mosaic_img(i-1, j) + mosaic_img(i+1, j))/2;
                out_img(i, j, 2) = (mosaic_img(i, j-1) + mosaic_img(i, j+1))/2;
                out_img(i, j, 3) = mosaic_img(i, j);
            elseif c1 == 1 && c2 == 0  % Green 2
                out_img(i, j, 1) = (mosaic_img(i-1, j) + mosaic_img(i+1, j))/2;
                out_img(i, j, 2) = mosaic_img(i, j);
                out_img(i, j, 3) = (mosaic_img(i, j-1) + mosaic_img(i, j+1))/2;
            else  % Red
                out_img(i, j, 1) = mosaic_img(i, j);
                out_img(i, j, 2) = (mosaic_img(i, j-1) + mosaic_img(i, j+1) + mosaic_img(i-1, j) + mosaic_img(i+1, j))/4;
                out_img(i, j, 3) = (mosaic_img(i-1, j-1) + mosaic_img(i+1, j-1) + mosaic_img(i-1, j+1) + mosaic_img(i+1, j+1))/4;
            end
        end
    end

    out_img = uint8(out_img);
end

function out_img = demosaic_grbg(mosaic_img)
    % Get the size of the input image
    [height, width] = size(mosaic_img);
    
    % Create an output RGB image
    out_img = zeros(height, width, 3);

    mosaic_img = double(mosaic_img);
    
    % Loop over each pixel in the mosaic image
    for i = 1:height-1
        for j = 1:width-1
            % Determine the color of the current pixel based on its position in the pattern
            c1 = mod(i, 2);  % 1 = Green 1, 2 = Red, 3 = Blue
            c2 = mod(j, 2);

            if (i == 1) || (j == 1)
                continue
            end
            
            % Interpolate the missing color channels based on surrounding pixels
            if c1 == 1 && c2 == 1  % Green 1
                out_img(i, j, 1) = (mosaic_img(i, j-1) + mosaic_img(i, j+1))/2;
                out_img(i, j, 2) = mosaic_img(i, j);
                out_img(i, j, 3) = (mosaic_img(i-1, j) + mosaic_img(i+1, j))/2;
            elseif c1 == 0 && c2 == 1  % Red
                out_img(i, j, 1) = mosaic_img(i, j);
                out_img(i, j, 2) = (mosaic_img(i, j-1) + mosaic_img(i, j+1) + mosaic_img(i-1, j) + mosaic_img(i+1, j))/4;
                out_img(i, j, 3) = (mosaic_img(i-1, j-1) + mosaic_img(i+1, j-1) + mosaic_img(i-1, j+1) + mosaic_img(i+1, j+1))/4;
            elseif c1 == 1 && c2 == 0  % Blue
                out_img(i, j, 1) = (mosaic_img(i-1, j-1) + mosaic_img(i+1, j-1) + mosaic_img(i-1, j+1) + mosaic_img(i+1, j+1))/4;
                out_img(i, j, 2) = (mosaic_img(i, j-1) + mosaic_img(i, j+1) + mosaic_img(i-1, j) + mosaic_img(i+1, j))/4;
                out_img(i, j, 3) = mosaic_img(i, j);
            else  % Green 2
                out_img(i, j, 1) = (mosaic_img(i-1, j) + mosaic_img(i+1, j))/2;
                out_img(i, j, 2) = mosaic_img(i, j);
                out_img(i, j, 3) = (mosaic_img(i, j-1) + mosaic_img(i, j+1))/2;
            end
        end
    end

    out_img = uint8(out_img);
end

