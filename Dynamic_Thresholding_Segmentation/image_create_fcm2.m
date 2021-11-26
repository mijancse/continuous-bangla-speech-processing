% FCM clustering
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
subplot(121), imshow(fim);

% Thresholding by fuzzy c-means clustering
% ----------------------------------------------------------------
data=reshape(fim,[],1);
[center,member]=fcm(data,2);
%[center,cidx]=sort(center);
out = fopen('img_member2.txt','w');
fprintf(out,'SN\tData\tGray\tMember1\tMember2\tClass\n');
C1 = 0;
C2 = 0;
%member
k =1;
for i=1:36    
    M = max(member(k),member(k+1));
    if M == member(k)
        C(i) = 1;
        C1 = C1+1;
    elseif M == member(k+1)
        C(i) = 2;
        C2 = C2+1;
    end
    fprintf('data[%2d]= %4d\t%f\tMem1= %f\tMem2= %f\tClass= %d\n',i,fim1(i),fim(i),member(k),member(k+1),C(i));
    fprintf(out,'%2d\t%3d\t%f\t%f\t%f\t%d\n',i,fim1(i),fim(i),member(k),member(k+1),C(i));
    k = k+2;
end
fprintf('C#1= %d\nC#2= %d\n',C1,C2);
fprintf(out,'C#1= %d\nC#2= %d\n',C1,C2);
fprintf('Center#1= %f\nCenter#2= %f\n',center(1),center(2));
fprintf(out,'Center#1= %f\nCenter#2= %f\n',center(1),center(2));
%member
%center
%
level= sum(center)/2;
fprintf('Threshold= %f\n\n',level);
fprintf(out,'Threshold= %f\n\n',level);
fclose(out);
% Binary Image
bw=im2bw(fim,level);
subplot(122), imshow(bw);
fprintf('Process completed! :)\n');
% --------------------------------------------------------------