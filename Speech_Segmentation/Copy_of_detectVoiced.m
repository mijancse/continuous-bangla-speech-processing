function [segments, fs] = detectVoiced(wavFileName)
% function [segments, fs] = detectVoiced(wavFileName,t)
% This function segments continuous speech into word/sub-words
%
% ARGUMENTS:
%  - wavFileName: the path of the wav file to be analyzed
%  
% RETURNS:
%  - segments: a cell array of M elements. M is the total number of
%  detected segments. Each element of the cell array is a vector of audio
%  samples of the respective segment. 
%  - fs: the sampling frequency of the audio signal
%
% Check if the given wav file exists:
fp = fopen(wavFileName, 'rb');
if (fp<0)
	fprintf('The file %s has not been found!\n', wavFileName);
	return;
end 
fclose(fp);

% Check if .wav extension exists:
if  (strcmpi(wavFileName(end-3:end),'.wav'))
    % read the wav file name:
    [x,fs] = wavread(wavFileName);
else
    fprintf('Unknown file type!\n');
    return;
end
%[n dim] = size(x);
fprintf('Input file: %s\n', wavFileName);
fprintf('No. of sample: %d\n', length(x));
fprintf('Sampling frequency: %d\n', fs);

% Convert mono to stereo
if (size(x, 2)==2)
	x = mean(x')';
end

%Plot original signal
subplot(4,1,1);
%t1 = 1/fs:1/fs:(length(x)/fs);
plot(x);
title('Original Speech Signal');

% Window length and step (in seconds):
win = 0.05;
step =0.0125;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  THRESHOLD ESTIMATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%

Weight = 100; % used in the threshold estimation method

% Compute short-time energy and spectral centroid of the signal:
Eor = ShortTimeEnergy(x, win*fs, step*fs);
Cor = SpectralCentroid(x, win*fs, step*fs, fs);

% Apply median filtering in the feature sequences (twice), using 5 windows:
% (i.e., 250 mseconds)
NW = 5;
E = medfilt1(Eor, NW); E = medfilt1(E, NW);
C = medfilt1(Cor, NW); C = medfilt1(C, NW);

% Get the average values of the smoothed feature sequences:
E_mean = mean(E);
Z_mean = mean(C);

% Find energy threshold:
[HistE, X_E] = hist(E, round(length(E) / 10));  % histogram computation
[MaximaE, countMaximaE] = findMaxima(HistE, 3); % find the local maxima of the histogram
if (size(MaximaE,2)>=2) % if at least two local maxima have been found in the histogram:
    T_E = (Weight*X_E(MaximaE(1,1))+X_E(MaximaE(1,2))) / (Weight+1); % ... then compute the threshold as the weighted average between the two first histogram's local maxima.
else
    T_E = E_mean / 2;
end

% Find spectral centroid threshold:
[HistC, X_C] = hist(C, round(length(C) / 10));
[MaximaC, countMaximaC] = findMaxima(HistC, 3);
if (size(MaximaC,2)>=2)
    T_C = (Weight*X_C(MaximaC(1,1))+X_C(MaximaC(1,2))) / (Weight+1);
else
    T_C = Z_mean / 2;
end

% Thresholding:
Flags1 = (E>=T_E);
Flags2 = (C>=T_C);
flags = Flags1 & Flags2;

%Plot short-term energy of signal
    subplot(4,1,2); 
    %t2=1/fs:step:(length(C)*step);
    plot(Eor, 'g'); 
    hold on; 
    plot(E, 'c'); 
    legend({'STE(original)', 'STE(filtered)'});
    L = line([0 length(E)],[T_E T_E]); 
    set(L,'Color',[0 0 0]); set(L, 'LineWidth', 2);
    axis([0 length(Eor) min(Eor) max(Eor)]);

    %Plot spectral of signal
    subplot(4,1,3); 
    plot(Cor, 'g'); 
    hold on; plot(C, 'c'); 
    legend({'SC(original)', 'SC(filtered)'});    
	L = line([0 length(C)],[T_C T_C]); 
    set(L,'Color',[0 0 0]); set(L, 'LineWidth', 2);   
    axis([0 length(Cor) min(Cor) max(Cor)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SPEECH SEGMENTS DETECTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count = 1;
WIN = 5;
Limits = [];
while (count < length(flags)) % while there are windows to be processed:
	% initilize:
	curX = [];	
	countTemp = 1;
	% while flags=1:
	while ((flags(count)==1) && (count < length(flags)))
		if (countTemp==1) % if this is the first of the current speech segment:
			Limit1 = round((count-WIN)*step*fs)+1; % set start limit:
			if (Limit1<1)	
                Limit1 = 1; 
            end        
		end	
		count = count + 1; 		% increase overall counter
		countTemp = countTemp + 1;	% increase counter of the CURRENT speech segment
	end

	if (countTemp>1) % if at least one segment has been found in the current loop:
		Limit2 = round((count+WIN)*step*fs);			% set end counter
		if (Limit2>length(x))
            Limit2 = length(x);
        end
        
        Limits(end+1, 1) = Limit1;
        Limits(end,   2) = Limit2;
    end
	count = count + 1; % increase overall counter
end

%%%%%%%%%%%%%%%%%%%%%%%
% POST - PROCESS      %
%%%%%%%%%%%%%%%%%%%%%%%

% A. MERGE OVERLAPPING SEGMENTS:
RUN = 1;
while (RUN==1)
    RUN = 0;
    for (i=1:size(Limits,1)-1) % for each segment
        if (Limits(i,2)>=Limits(i+1,1))
            RUN = 1;
            Limits(i,2) = Limits(i+1,2);
            Limits(i+1,:) = [];
            break;
        end
    end
end

% B. Get final segments:
segments = {};
for (i=1:size(Limits,1))
    segments{end+1} = x(Limits(i,1):Limits(i,2)); 
end

% Plot and play speech segments:
subplot(4,1,4);
time = 0:1/fs:(length(x)-1) / fs;
for (i=1:length(segments))
    hold off;
    P1 = plot(time, x); set(P1, 'Color', [0.7 0.7 0.7]);    
    hold on;
    for (j=1:length(segments))
        if (i~=j)
           timeTemp = Limits(j,1)/fs:1/fs:Limits(j,2)/fs;
           P = plot(timeTemp, segments{j});
           set(P, 'Color', [0.4 0.1 0.1]);
        end
     end
     timeTemp = Limits(i,1)/fs:1/fs:Limits(i,2)/fs;
     P = plot(timeTemp, segments{i});
     set(P, 'Color', [0.9 0.0 0.0]);
     axis([0 time(end) min(x) max(x)]);
     sound(segments{i}, fs);

    % Write segmented speech words into .wav file. %
    filename1 = ['S' num2str(i) wavFileName];
    wavwrite(segments{i},fs,filename1);
     
    %clc;
    fprintf('Playing segment %d of %d. Press any key to continue...\n', i, length(segments));
    pause
end

%clc
 hold off;
 P1 = plot(time, x); set(P1, 'Color', [0.7 0.7 0.7]);    
 hold on;    
 for (i=1:length(segments))
    for (j=1:length(segments))
      if (i~=j)
        timeTemp = Limits(j,1)/fs:1/fs:Limits(j,2)/fs;
        P = plot(timeTemp, segments{j});
        set(P, 'Color', [0.4 0.1 0.1]);
      end
    end
    axis([0 time(end) min(x) max(x)]);
 end
 
 % Write segment info into .txt file.
% open a file for writing
fid = fopen('info_seg.txt', 'a');
fprintf(fid,'Segment Information\n\n');
fprintf(fid,'Speech File: %s\n', wavFileName);
fprintf(fid,'No. of Segments: %d\n', length(segments));
fprintf('\nNo. of Segments: %d\n', length(segments));
for i=1:length(segments)
   fprintf(fid,'Seg#%d = %d\n', i,length(segments{i}));
end
fclose(fid);
fprintf('\nSegmentation process has been completed...\n');