%-----------SPEECH RECOGNITION USING MFCC FEATURES----------%
clc; clear all; close all;
% Test speech file
testFile = 'M12S2.wav';
fprintf('Test File: [%s]\n',testFile);
[speech, fs, nbits ] = wavread(testFile);
subplot(211);
%plot(time,speech, 'k' );
plot(speech);
xlabel( 'Time (s)' ); 
ylabel( 'Amplitude' ); 
title( 'Speech waveform'); 

% Get Mel-Cepstrum coefficients for input wav file
mfccData = melcep(speech,fs);
fprintf('MFCC DATA: %d\n',size(mfccData));
subplot(212);
imagesc(mfccData); % HTK's TARGETKIND: MFCC
%imagesc( time_frames, [1:C+1], MFCCs );       % HTK's TARGETKIND: MFCC_0
axis( 'xy' );
xlabel( 'Time (s)' ); 
ylabel( 'Cepstrum index' );
title( 'Mel frequency cepstrum' );
% Set color map to grayscale
%colormap( 1-colormap('gray') ); 
%--------------------------End Testing------------------------------%