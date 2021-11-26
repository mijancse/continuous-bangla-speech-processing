%testfcmthresh.m
%
clear;clc;
%file_sp         = 'M25.wav';
%file_sgm        = 'M25_sptrogram.png';
%file_result     = 'M25_Result_FCM.png';
%file_result1    = 'M25_BW_FCM.jpg';
%file_result2    = 'M25_BlackBox_FCM.jpg';
fim1 =  [  0   0  25 150 150 255;...
          0  25  82 150  82 150;...
         25  82 150  41  25  82;...
        150 150  82  25   0   0;...
        255 150  41  25   0   0;...
        255 255 150  82  25   0];
%im=imread(file_sgm);
fim = mat2gray(fim1);
subplot(121), imshow(fim),title('Original Image');
fim1
fim
% Thresholding by 3-class k-means clustering
% ----------------------------------------------------------------
X=reshape(fim,[],1);
[idx,ctrs] = kmeans(X,3);
% idx
out = fopen('img_member_kmeans.txt','w');
fprintf(out,'SN\tData\tGray\tClass\n');
C1 = 0;
C2 = 0;
C3 = 0;
for i=1:36    
    if idx(i) == 1
        C1 = C1+1;
    elseif idx(i) == 2
        C2 = C2+1;
    elseif idx(i) == 3
        C3 = C3+1;
    end
    fprintf('data[%2d]= %4d\t%f\tClass= %d\n',i,fim1(i),fim(i),idx(i));
    fprintf(out,'%2d\t%3d\t%f\t%d\n',i,fim1(i),fim(i),idx(i));
end
fprintf('C#1= %d\nC#2= %d\nC#3= %d\n',C1,C2,C3);
fprintf(out,'C#1= %d\nC#2= %d\nC#3= %d\n',C1,C2,C3);
fprintf('Centroid#1= %f\nCentroid#2= %f\nCentroid#3= %f\n',ctrs(1),ctrs(2),ctrs(3));
fprintf(out,'Centroid#1= %f\nCentroid#2= %f\nCentroid#3= %f\n',ctrs(1),ctrs(2),ctrs(3));
%level=max(ctrs);
%C = sort(ctrs);
level=sum(ctrs)/3;
fprintf('Threshold: %f\n',level);
fprintf(out,'Threshold: %f\n',level);
fclose(out);
% Binary Image
bw=im2bw(fim,level);
subplot(122), imshow(bw),title(sprintf('Thresholded Image (Thresh: %f)',level));
fprintf('Process completed! :)\n');
% --------------------------------------------------------------