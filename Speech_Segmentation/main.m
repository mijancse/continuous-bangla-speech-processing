% Speech segmentation

% Clean-up MATLAB's environment.
clear all; close all; clc;  

% Initial input wav file.
filename = 'M15';              

%Calling detectVoiced() function
detectVoiced(filename);
% EOF