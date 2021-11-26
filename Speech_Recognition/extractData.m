% End-ponit detection, Spectrogram, Binary Image
function [bw] = extractData(wavFile)
[speech, fs, nbits] = wavread(wavFile);
speech2 = endpt(speech);
testFile = 'newWav.wav';
wavwrite(speech2,fs,nbits,testFile)
% Speech Spectrogram
h = testSpectrogram(testFile);
% B/W Spectrogram using Otsu's Method
sFile = 'Spectrogram.png';
bw = testOtsu(sFile);
%--------------------------End------------------------------%