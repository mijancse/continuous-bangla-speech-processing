% Compute the spectrogram of speech siignal
function h = testmyspectrogram1(file,sfile)
    [speech, fs, nbits] = wavread(file);    
    % PLOT SPECTROGRAMS (PERIODOGRAM SPECTRUM)
    %set(gca,'position',[0 0 1 1],'units','normalized')
    %axis off;
    
    figure('Position', [20 20 800 250], 'PaperPositionMode', 'auto', 'Visible', 'on');
    h = myspectrogram(speech, fs, [22 1], @hamming, 2048, [-59 -1], false, 'default', false, 'per'); % or be quite specific about what you want
    % title('Speech Spectrogram');
    %xlabel('Time (s)');
    %ylabel('Frequency (Hz)');
    % print('-depsc2', '-r250', sprintf('%s.eps', mfilename));
    set(gca,'position',[0 0 1 1],'units','normalized')
    axis off;
    print('-dpng', sprintf('%s', sfile));

    fprintf('Spectrogram Process completed!\n');
% EOF
