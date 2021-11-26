% Convert B/W image using Otsu's Method
function [bw] = testOtsu(spectFile) 
%---------------------------------------------------------------------
% Image Resize
% B = imresize(A, scale); returns image B that is scale times the size 
% of A.  
I = imread(spectFile); % Read image file
im= imresize(I, 0.1);
%--------------------------------------------------------------------
% I = mat2gray(A) The returned matrix I contains values in the range 0.0 (black) 
% to 1.0 (full intensity or white).
fim = mat2gray(im);
%
% ------------------------------------------------------------------
% Otsu's Thresholding
% ------------------------------------------------------------------
% level = graythresh(I)
% The graythresh function uses Otsu's method, which chooses the threshold 
% to minimize the intraclass variance of the black and white pixels.
%
% BW = im2bw(I, level) converts the grayscale image I to a binary image. 
% 
level = graythresh(fim);
bw = im2bw(fim,level);
%---------------------------------------------------------------
%Save the result as image
%---------------------------------------------------------------
imwrite(bw,sprintf('Spectrogram_Otsu.png'));
return;
%EOF