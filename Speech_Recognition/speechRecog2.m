%-----------SPEECH RECOGNITION USING BACK PROPAGATION ALGORITHM----------%
% This code solves the problem of speech recognition using Back
% Propagation Algorithm. 
%------------------------------Code Starts-------------------------------%
clc; clear all; close all;
% Test speech file
testFile = 'M13S1.wav';
fprintf('Test File: [%s]\n',testFile);
% Reference speech file 
refFile = ['M12S1';'M12S2';'M12S3';'M12S4';'M12S5'];
NO = length(refFile);
fprintf('No. of Ref File: %d\n',NO);
%
%------------------------------------------%
% Test Speech Data and Feature Extraction  %
%------------------------------------------%
bwData = extractData(testFile);
% Convert 2d array into vector
[m,n] = size(bwData);
testData = [];
for i=1:m
   for j=1:n
       testData=[testData;bwData(i,j)];
   end
end
%------------------------------------------%    
% Ref Speech Data and Features Extraction  %
%------------------------------------------%

%Ref-1
fileName = refFile(1,:);  
wavFile = [fileName '.wav'];
fprintf('Processing [%s]...\n',wavFile);
bwData = extractData(wavFile);
% Convert 2d array into vector
[m,n] = size(bwData);
a1 = [];
for i=1:m
   for j=1:n
       a1 =[a1;bwData(i,j)];
   end
end

%Ref-2
fileName = refFile(2,:);  
wavFile = [fileName '.wav'];
fprintf('Processing [%s]...\n',wavFile);
bwData = extractData(wavFile);
% Convert 2d array into vector
[m,n] = size(bwData);
b1 = [];
for i=1:m
   for j=1:n
       b1 =[b1;bwData(i,j)];
   end
end

%Ref-3
fileName = refFile(3,:);  
wavFile = [fileName '.wav'];
fprintf('Processing [%s]...\n',wavFile);
bwData = extractData(wavFile);
% Convert 2d array into vector
[m,n] = size(bwData);
c1 = [];
for i=1:m
   for j=1:n
       c1 =[c1;bwData(i,j)];
   end
end

%Ref-4
fileName = refFile(4,:);  
wavFile = [fileName '.wav'];
fprintf('Processing [%s]...\n',wavFile);
bwData = extractData(wavFile);
% Convert 2d array into vector
[m,n] = size(bwData);
d1 = [];
for i=1:m
   for j=1:n
       d1 =[d1;bwData(i,j)];
   end
end

%Ref-5
fileName = refFile(5,:);  
wavFile = [fileName '.wav'];
fprintf('Processing [%s]...\n',wavFile);
bwData = extractData(wavFile);
% Convert 2d array into vector
[m,n] = size(bwData);
e1 = [];
for i=1:m
   for j=1:n
       e1 =[e1;bwData(i,j)];
   end
end

%----------------------------Training-----------------------%
le=[a1 b1 c1 d1 e1];
t=eye(5);
net=newff(minmax(le),[20,5],{'tansig','purelin'},'traingd');
% net.trainParam.epochs = 1000;
% net.trainParam.show = 100;
% net.trainParam.goal=0.1;
% net.trainParam.lr=0.01;
% net.trainParam.mc=0.9
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
for j=1:NO
    if out(j)>out(max)
        max=j;
    end
end
fprintf('\nTest speech matching output: %d\n',max);
%--------------------------End Testing------------------------------%