clc; clear; close all;

%% Initialize variables
img1 = imread('../images/test1.png');
img2 = imread('../images/test2.png');

img1_demosaic = demosaic(img2, 'rggb');
figure, imshow(img1_demosaic);

img_interp = demosaic_interpolation(img2, 'rggb');
figure, imshow(img_interp)