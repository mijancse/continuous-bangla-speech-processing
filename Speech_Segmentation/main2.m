% ------------------------------------------------------%
% Spech segmentation using Energy and Spectral Analysis %
% ------------------------------------------------------%

% Clean-up MATLAB's environment. 
clear all; close all; clc;  

% Input wav files.
[filenames] = ['M51';'M52';'M53';'M55'];
%filename = 'M35.wav';              
n = length(filenames); % No. of input .wav files
for i=1:n
    filename = filenames(i,:);              
    fprintf('Press any key to process [%s.wav]\n',filename);
    pause; 
    %Calling detectVoiced() function
    detectVoiced(filename);
end

 % EOF