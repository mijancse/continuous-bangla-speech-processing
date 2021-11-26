%testfcmthresh.m
%
clear;clc;
file_sp         = 'M15.wav';
file_sgm        = 'M15_Sptrogram.png';
file_result     = 'M15_Result.png';
%file_result2    = 'M15_BlackBox.png';
%
[speech, fs, nbits] = wavread(file_sp);    
% plot(speech);
im=imread(file_sgm);
%
% I = mat2gray(A, [amin amax]) converts the matrix A to the intensity 
% image I. The returned matrix I contains values in the range 0.0 (black) 
% to 1.0 (full intensity or white). amin and amax are the values in A 
% that correspond to 0.0 and 1.0 in I.
%
% I = mat2gray(A) sets the values of amin and amax to the minimum 
% and maximum values in A.
fim = mat2gray(im);
%
% ------------------------------------------------------------------
% Otsu's Thresholding
% ------------------------------------------------------------------
% level = graythresh(I) computes a global threshold (level) that can 
% be used to convert an intensity image to a binary image with im2bw. 
% level is a normalized intensity value that lies in the range [0, 1].
% The graythresh function uses Otsu's method, which chooses the threshold 
% to minimize the intraclass variance of the black and white pixels.
%
% BW = im2bw(I, level) converts the grayscale image I to a binary image. 
% The output image BW replaces all pixels in the input image 
% with luminance greater than level with the value 1 (white) and 
% replaces all other pixels with the value 0 (black). 
% Specify level in the range [0,1].
level=graythresh(fim);
bwfim=im2bw(fim,level);
boxImage1 = blockingBlackArea(bwfim); % Blocking Black Area Method
%-----------------------------------------------------------------
% Thresholding by 3-class fuzzy c-means clustering
% ----------------------------------------------------------------
%[bwfim0,level0]=fcmthresh(fim,0);
[bwfim1,level1]=fcmthresh(fim,1);
boxImage2 = blockingBlackArea(bwfim1); % Blocking Black Area Method
% ----------------------------------------------------------------
% Plot the result
% ----------------------------------------------------------------
subplot(3,2,1);
plot(speech);title('Original');
subplot(3,2,2);
imshow(fim);title('Speech Spectrogram');
subplot(3,2,3);
imshow(bwfim);title(sprintf('Otsu,level=%f',level));
subplot(3,2,4);
imshow(boxImage1);title('Blocking Black Area');
%subplot(2,2,3);
%imshow(bwfim0);title(sprintf('FCM0,level=%f',level0));
subplot(3,2,5);
imshow(bwfim1);title(sprintf('FCM1,level=%f',level1));
subplot(3,2,6);
imshow(boxImage2);title('Blocking Black Area');
print('-dpng', sprintf(file_result));
%---------------------------------------------------------------
% Save the result as image
% --------------------------------------------------------------
%imwrite(bwfim,'img_OTSU.jpg');
%imwrite(bwfim0,'img_FCM0.jpg');
%imwrite(bwfim1,'img_FCM1.jpg');
%imwrite(boxImage2,'img_BLACK.jpg');
fprintf('Process completed! :)\n');
% --------------------------------------------------------------