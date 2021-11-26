% ------------------Continuous Speech Segmentation--------------------%
% This program segments continuous speech into words/sub-words 
% by using the thresholding of 3-class fuzzy c-means clustering algorithm.
%
clear all;clc;
% Input audio clip number
iDIR = 'SAWMEN_SPEECH\';    % Input sentence dir
oDIR = 'SAWMEN_SEGMENT\';   % Out segment dir
iName = 'S';
%infoFile = [oDIR 'SEG_INFO.txt'];
%fid = fopen(infoFile,'w');
% Input audio clip number
for i = 91:100
    
    if i<10
        %clip = 'S005';              
        clip = [iName '00' num2str(i)];
    elseif i<100
        clip = [iName '0' num2str(i)];
    else
        clip = [iName num2str(i)];
    end
% Input audio file name
% file_sp  = ['M' int2str(clip) '.wav'];
file_sp  = [iDIR clip '.wav'];
% Spectrogram file name
file_sgm  = [oDIR clip '_Spectrogram.png'];
% Speech Spectrogram...
h = testmyspectrogram1(file_sp,file_sgm);

file_result  = [oDIR clip '_Result_FCM.jpg'];
file_result1 = [oDIR clip '_BW_FCM.jpg'];
file_result2 = [oDIR clip '_BlackBox_FCM.jpg'];
%
[speech, fs, nbits] = wavread(file_sp);    
im = imread(file_sgm);
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
% Thresholding by 3-class fuzzy c-means clustering
% ------------------------------------------------------------------
level = fcmthresh(fim);
bw=im2bw(fim,level);
%imwrite(bw,file_result1);
% Blocking Black Area Method
boxImage2 = blockingBlackArea2(bw);
%imwrite(boxImage2,file_result2);
[row,col] = size(boxImage2);

%----------------------------- Get final segments ----------------------%
nSample = length(speech); 
[W, Limits] = testsegment22(boxImage2);
[nSeg c1] = size(Limits);
Limits = floor((nSample/col)*Limits);
%nSeg
%nSample
%fprintf(fid,'\n%3d. %s...\n',i,clip);
%fprintf(fid,'No. of words: %d\n',nSeg);

segments = {};
for i=1:nSeg
    if Limits(i,2)> nSample
        Limits(i,2) = nSample;
    end
    segments{i} = speech(Limits(i,1):Limits(i,2)); 
    fprintf('Segment[%d]: Start= %d End= %d\n',i,Limits(i,1),Limits(i,2));
    
end
% subplot(2,2,1);
% plot(speech);title('Original');
% subplot(2,2,2);
% imshow(fim);title('Speech Spectrogram');
% subplot(2,2,3);
% imshow(bwfim1);title(sprintf('FCM1,level=%f',level1));
% subplot(2,2,4);
% imshow(boxImage2);title('Blocking Black Area');
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
    %fprintf(fid,'Segment[%2d]= %d\n', i,length(segments{i}));
    pause(0.5); % pause(n) - wait for n seconds
    
end
print('-dpng', file_result);
end
%fclose(fid);
fprintf('Process completed! :)\n');
% --------------------------------------------------------------