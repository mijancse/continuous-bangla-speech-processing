% ------------------Continuous Speech Segmentation--------------------%
% This program segments continuous speech into words/sub-words 
% by using the otsu's thresholding algorithm.
%
clear;clc;
% Input audio clip number
clip = 'M402';              
iDIR = 'SPEECH_DIGIT\';
oDIR = 'SEGMENT\';
% Input audio file name
file_sp  = [iDIR clip '.wav'];

% Spectrogram file name
file_sgm  = [oDIR clip '_Spectrogram.png'];
% Speech Spectrogram...
h = testmyspectrogram1(file_sp,file_sgm);

file_result  = [oDIR clip '_Result_OTSU.jpg'];
file_result1 = [oDIR clip '_BW_OTSU.jpg'];
file_result2 = [oDIR clip '_BlackBox_OTSU.jpg'];
%
[speech, fs, nbits] = wavread(file_sp);    
im=imread(file_sgm);
fim = mat2gray(im);
%
% I = mat2gray(A, [amin amax]) converts the matrix A to the intensity 
% image I. The returned matrix I contains values in the range 0.0 (black) 
% to 1.0 (full intensity or white). amin and amax are the values in A 
% that correspond to 0.0 and 1.0 in I.
% I = mat2gray(A) sets the values of amin and amax to the minimum 
% and maximum values in A.
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
% Binary Image
bw=im2bw(fim,level);
imwrite(bw,file_result1);
% Blocking Black Area Method
boxImage2 = blockingBlackArea(bw);
imwrite(boxImage2,file_result2);
[row,col] = size(boxImage2);
%----------------------------- Get final segments ----------------------%
[W, Limits] = testsegment2(boxImage2);
%Limits
[nSeg c1] = size(Limits);
nSample = length(speech); 
Limits = floor((nSample/col)*Limits);

segments = {};
for i=1:nSeg
    if Limits(i,2)> nSample
        Limits(i,2) = nSample;
    end
    segments{i} = speech(Limits(i,1):Limits(i,2)); 
    fprintf('Segment[%d]: Start= %d End= %d\n',i,Limits(i,1),Limits(i,2));
end
% Plot the result
% subplot(2,2,1);
% plot(speech);title('Original');
% subplot(2,2,2);
% imshow(fim);title('Speech Spectrogram');
% subplot(2,2,3);
% imshow(bwfim);title(sprintf('Otsu,level=%f',level));
% subplot(2,2,4);
% imshow(boxImage1);title('Blocking Black Area');
figure;
subplot(2,1,1);
t1 = 1/fs:1/fs:(length(speech)/fs);
plot(t1,speech);title('Original');
% plot(speech);title('Original');
subplot(2,1,2);
t1 = 1/fs:1/fs:(length(speech)/fs);
hold off;
P1 = plot(t1, speech); set(P1, 'Color', [0.7 0.7 0.7]);
%P1 = plot(t1, speech);
for (i=1:nSeg)
    hold on;
    timeTemp = Limits(i,1)/fs:1/fs:Limits(i,2)/fs;
    P = plot(timeTemp, segments{i});
    set(P, 'Color', [0.9 0.0 0.0]);
    % Playing segmented word
    % sound(segments{i}, fs);
    %-----------------Write segments into .wav file-------------------%
    if i<10
        filename1  = [oDIR clip 'S0' num2str(i) '.wav'];
    else
        filename1  = [oDIR clip 'S' num2str(i) '.wav'];
    end
    wavwrite(segments{i},fs,filename1);
    %clc;
    fprintf('Segment[%d]= %d...\n', i,length(segments{i}));
    pause(0.5); % pause(n) - wait for n seconds
end
print('-dpng', file_result);
fprintf('Process completed! :)\n');
% --------------------------------------------------------------