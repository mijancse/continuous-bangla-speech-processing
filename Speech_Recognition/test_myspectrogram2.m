% Compute the spectrogram of speech siignal
    clc; clear all; close all; % clc;
    titlecase = @(str) ( sprintf('%s%s',upper(str(1)),str(2:end))); % make a word title case
    %
    % String Concatenation
    % numChars = 15
    % s = ['There are ' int2str(numChars) ' characters here']
    % s = sprintf('There are %d characters here', numChars)
    %
    file        = 'M12S5';               % Input Speech segment file name
    wavFile     = [file '.wav'];         % Input .wav file name
    wavFileNew  = [file '_NEW'];         % New .wav file name
    plotFile    = [file '_Speech'];      % Original speech graph file name
    specFile    = [file '_Spectrogram']; % Spectrogram image file name
    
    [speech, fs, nbits] = wavread(wavFile);    
    plot(speech);
    title('Original Speech Signal');
    xlabel('Time(s)'),ylabel('Energy')
     % "axis off" will get rid of the axes.
     % To eliminate the border, you can set the size of the axis 
     % to fill the figure:
     %set(gca,'position',[0 0 1 1],'units','normalized')
     %axis off;
     print('-dpng', sprintf('%s.png', plotFile));
     
    % PLOT SPECTROGRAMS (PERIODOGRAM SPECTRUM)
    %set(gca,'position',[0 0 1 1],'units','normalized')
    %axis off;
    
    figure('Position', [20 20 800 250], 'PaperPositionMode', 'auto', 'Visible', 'on');
    %myspectrogram(speech.(method), fs); % use the default options
    [S.h] = myspectrogram2(speech, fs, [22 1], @hamming, 2048, [-59 -1], false, 'default', false, 'per'); % or be quite specific about what you want
    % title('Speech Spectrogram');
    %xlabel('Time (s)');
    %ylabel('Frequency (Hz)');
    % print('-depsc2', '-r250', sprintf('%s.eps', mfilename));
    set(gca,'position',[0 0 1 1],'units','normalized')
    axis off;
    print('-dpng', sprintf('%s.png',specFile));

    figure, imagesc(S);

    % WRITE TO AUDIO FILES
    audio = 0.999*speech./max(abs(speech));
    wavwrite(audio, fs, nbits, sprintf('%s.wav',wavFileNew));
    fprintf('Process completed! :)\n');
% EOF
