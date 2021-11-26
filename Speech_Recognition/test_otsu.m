%
clear;clc;
file       = 'M11S1';               % Input Speech segment file name
wavFile    = [file '.wav'];
spectFile  = [file '_Spectrogram.png'];
resultFile = [file '_Result_OTSU'];
otsuFile   = [file '_OTSU'];
out = fopen('bwtext.txt','w');
% Read .wav file
[speech, fs, nbits] = wavread(wavFile);
% plot(speech);
%---------------------------------------------------------------------
% Image Resize
% B = imresize(A, scale); returns image B that is scale times the size 
% of A. The input image A can be a grayscale, RGB, or binary image. 
% If scale is between 0 and 1.0, B is smaller than A. 
% If scale is greater than 1.0, B is larger than A.
%
% B = imresize(A, [numrows numcols]); returns image B that has the number 
% of rows and columns specified by [numrows numcols]. 
% Either numrows or numcols may be NaN, in which case imresize computes 
% the number of rows or columns automatically to preserve the image aspect ratio. 
I = imread(spectFile); % Read image file
im= imresize(I, 0.1);
%--------------------------------------------------------------------
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
level = graythresh(fim);
bw = im2bw(fim,level);
% --------------------------------------------------------------
% Plot the result
% --------------------------------------------------------------
subplot(3,1,1);
plot(speech);title('Original Speech Signal');
subplot(3,1,2);
imshow(fim);title('Speech Spectrogram');
subplot(3,1,3);
imshow(bw);title(sprintf('Otsu,level=%f',level));
print('-dpng', sprintf('%s.png',resultFile));
%---------------------------------------------------------------
%Save the result as image
%---------------------------------------------------------------
[m n] = size(bw);
fprintf('Row = %d\nColumn = %d\n',m,n);
fprintf(out,'%d',bw);
imwrite(bw,sprintf('%s.png',otsuFile));
fclose(out);
fprintf('Process completed! :)\n');
%---------------------------------------------------------------