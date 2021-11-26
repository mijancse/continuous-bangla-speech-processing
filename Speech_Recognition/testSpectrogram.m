% Compute the spectrogram of speech siignal
function [h] = testSpectrogram(wavFile)
    
    [speech, fs, nbits] = wavread(wavFile);
     
    % PLOT SPECTROGRAMS (PERIODOGRAM SPECTRUM)
    %figure('Position', [20 20 800 250], 'PaperPositionMode', 'auto', 'Visible', 'on');
    h = myspectrogram(speech, fs, [22 1], @hamming, 2048, [-59 -1], false, 'default', false, 'per'); % or be quite specific about what you want
    % title('Speech Spectrogram');
    %xlabel('Time (s)');
    %ylabel('Frequency (Hz)');
    set(gca,'position',[0 0 1 1],'units','normalized')
    axis off;
    print('-dpng', sprintf('Spectrogram.png'));
    %I = imread('spectrogram.png'); % Read spectrogram image
    return;
    % EOF