% Compute the spectrogram of speech siignal

clear all; close all; % clc;
    titlecase = @(str) ( sprintf('%s%s',upper(str(1)),str(2:end))); % make a word title case
    %
    % String Concatenation
    % numChars = 15
    % s = ['There are ' int2str(numChars) ' characters here']
    % s = sprintf('There are %d characters here', numChars)
    %
    clip = 'M15S6';              % Input audio clip number
    DIR = 'SEGMENT\';
    file  = [DIR clip '.wav'];
    %file =  'M61.wav';      % Source speech file name
    file2 = [DIR clip '_NEW'];
    %file2 = 'M61_NEW';      % Write back to audio file
    file3 = [DIR clip '_Speech'];
    %file3 = 'M61_Speech';   % Original speech image file name
    sfile = [DIR clip '_Spectrogram'];
    %sfile = 'M61_Sptrogram';% Spectrogram image file name
    
    [speech, fs, nbits] = wavread(file);    
     plot(speech);
     %title('Original Speech');
     xlabel('Time(s)'),ylabel('Energy')
     
     % "axis off" will get rid of the axes.
     % To eliminate the border, you can set the size of the axis 
     % to fill the figure:
     set(gca,'position',[0 0 1 1],'units','normalized')
     axis off;
     print('-dpng', sprintf('%s.png', file3));
     
     
    % PLOT SPECTROGRAMS (PERIODOGRAM SPECTRUM)
    %set(gca,'position',[0 0 1 1],'units','normalized')
    %axis off;
    
    figure('Position', [20 20 800 250], 'PaperPositionMode', 'auto', 'Visible', 'on');
        %myspectrogram(speech.(method), fs); % use the default options
        h = myspectrogram(speech, fs, [22 1], @hamming, 2048, [-59 -1], false, 'default', false, 'per'); % or be quite specific about what you want
        % title('Speech Spectrogram');
        %xlabel('Time (s)');
        %ylabel('Frequency (Hz)');
        % print('-depsc2', '-r250', sprintf('%s.eps', mfilename));
        set(gca,'position',[0 0 1 1],'units','normalized')
        axis off;
        print('-dpng', sprintf('%s.png', sfile));

    % WRITE TO AUDIO FILES
        audio = 0.999*speech./max(abs(speech));
        wavwrite(audio, fs, nbits, sprintf('%s.wav',file2));
    
        fprintf('Process completed! :)\n');
% EOF
