% ------------------Continuous Speech Segmentation--------------------%
% This program segments continuous speech into words/sub-words 
% by using the thresholding of 3-class k-means clustering algorithm.
%
clear all;clc;
% dbstop if error
% Input audio clip number
clip = 'M401';
% Input audio file name
%file_sp  = ['M' int2str(clip) '.wav'];
iDIR = 'SPEECH_DIGIT\';
oDIR = 'SEGMENT\';
file_sp  = [iDIR clip '.wav'];
% Spectrogram file name
file_sgm  = [oDIR clip '_Spectrogram.png'];
% Speech Spectrogram...
h = testmyspectrogram1(file_sp,file_sgm);

file_result  = [oDIR clip '_Result_KMEANS.jpg'];
file_result1 = [oDIR clip '_BW_KMEANS.jpg'];
file_result2 = [oDIR clip '_BlackBox_KMEANS.jpg'];
%
[speech, fs, nbits] = wavread(file_sp);    
im = imread(file_sgm);
fim = mat2gray(im);
%-------------- Thresholding by 3-class k-means clustering --------------%
X=reshape(fim,[],1);
%[idx,ctrs] = kmeans(X,3);
[idx,ctrs] = litekmeans(X,3);
fprintf('Centroids: %f\n',ctrs);
%level=max(ctrs);
C = sort(ctrs);
level=(C(2)+C(3))/2;
fprintf('Level: %f\n',level);
% Binary Image
bw=im2bw(fim,level);
%imwrite(bw,sprintf(file_result1));
imwrite(bw,file_result1);
% Blocking Black Area Method
boxImage2 = blockingBlackArea(bw);
imwrite(boxImage2,file_result2);
[row,col] = size(boxImage2);
%fprintf('Row= %d  Col= %d\n',row,col);
%fprintf('Sample= %d\n',nSample);
%----------------------------- Get final segments ----------------------%
nSample = length(speech); 
[W, Limits] = testsegment2(boxImage2);
[nSeg c1] = size(Limits);
Limits = floor((nSample/col)*Limits);
%nSeg
segments = {};
for i=1:nSeg
    if Limits(i,2)> nSample
        Limits(i,2) = nSample;
    end
    segments{i} = speech(Limits(i,1):Limits(i,2)); 
    % segments{i} = segData;
    fprintf('Segment[%d]: Start= %d End= %d\n',i,Limits(i,1),Limits(i,2));
end
% subplot(5,1,2);
% imshow(fim),title('Speech Spectrogram');
% subplot(5,1,3);
% imshow(bw),title(sprintf('KMEANS,level=%f',level));
% subplot(5,1,4);
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
    pause(0.5); % pause(n) - wait for n seconds
end
%print('-dpng', sprintf(file_result));
print('-dpng', file_result);
fprintf('Process completed! :)\n');
% --------------------------------------------------------------