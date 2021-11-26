%-----------SPEECH RECOGNITION USING BACK PROPAGATION ALGORITHM----------%
% This code solves the problem of speech recognition using Back
% Propagation Algorithm. 
%------------------------------Code Starts-------------------------------%
clc; clear all; close all;
% Test speech file
testFile = 'M13S5.wav';
fprintf('Test File: [%s]\n',testFile);
% Reference speech file 
refFile = ['M12S1';'M12S2';'M12S3';'M12S4';'M12S5'];
n = length(refFile);
fprintf('No. of Ref File: %d\n',n);
%
%------------------------------------------%
% Test Speech Data and Feature Extraction  %
%------------------------------------------%
% Speech Spectrogram
h = testSpectrogram(testFile);
% B/W Spectrogram using Otsu's Method
sFile = 'Spectrogram.png';
bw = testOtsu(sFile);
% Convert 2d array into vector
[m1,n1] = size(bw);
testData = [];
for i=1:m1
   for j=1:n1
       testData=[testData;bw(i,j)];
   end
end
%------------------------------------------%    
% Ref Speech Data and Features Extraction  %
%------------------------------------------%
bw_v = [];    
for k=1:n
    fileName = refFile(k,:);  
    wavFile = [fileName '.wav'];
    fprintf('Processing [%s]...\n',wavFile);
    % Speech Spectrogram
    h = testSpectrogram(wavFile);
    % B/W Spectrogram using Otsu's Method
    sFile = 'Spectrogram.png';
    bw = testOtsu(sFile);
    % Convert 2d array into vector
    [m1,n1] = size(bw);
    for i=1:m1
        for j=1:n1
            bw_v=[bw_v;bw(i,j)];
        end
    end
    %pause; 
end
%length(bw_v)
% Reference speech spectrogram data
a1=[];
N1 = m1*n1;
for i=1:N1
   a1=[a1;bw_v(i)];
end

b1=[];
N2 = 2*m1*n1;
for i=N1+1:N2
   b1=[b1;bw_v(i)];
end

c1=[];
N3 = 3*m1*n1;
for i=N2+1:N3
   c1=[c1;bw_v(i)];
end

d1=[];
N4 = 4*m1*n1;
for i=N3+1:N4
   d1=[d1;bw_v(i)];
end

e1=[];
N5 = 5*m1*n1;
for i=N4+1:N5
   e1=[e1;bw_v(i)];
end

%----------------------------Training-----------------------%
le=[a1 b1 c1 d1 e1];
t=eye(5);
net=newff(minmax(le),[100,5],{'tansig','purelin'},'traingd');
net.trainParam.epochs = 1000;
net.trainParam.goal=0.1;
net.trainParam.lr=0.01;
net.trainParam.mc=0.1
net = train(net,le,t);
Y = sim(net,le);
cor=0;
for i=1:5
    max=1;
    for j=1:5
        if Y(j,i)>Y(max,i)
            max=i;
        end
    end
    if max==i
        cor=cor+1;
    end
end

%'Train Cases Recognized'
%cor

%'Train Cases Recognition Accuracy'
%cor/5*100
%----------------------------End Traning----------------------------%
%
%------------------------------Testing------------------------------%
out=sim(net,testData);
fprintf('Test File: [%s]\n',testFile);
fprintf('Test speech output vector:\n');
fprintf('%f\n',out);

max=1;
for j=1:n
    if out(j)>out(max)
        max=j;
    end
end
fprintf('\nTest speech matching output: %d\n',max);
%--------------------------End Testing------------------------------%