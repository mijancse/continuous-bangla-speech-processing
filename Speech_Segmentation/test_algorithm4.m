% Segmentation of continuous speech into word/sub-words using
% short-time energy and spectral centroid features.
%
clear all; close all; clc;  
FileName = 'MI001';
iDIR = 'MIJAN_SPEECH\';    % Input sentence dir
oDIR = 'MIJAN_SEGMENT\';   % Output segment dir
wavFileName = [iDIR FileName '.wav'];
[x,fs] = wavread(wavFileName);
%[n dim] = size(x);
fprintf('Input file: %s.wav\n', FileName);
fprintf('No. of sample: %d\n', length(x));
fprintf('Sampling frequency: %d\n', fs);

fid = fopen([oDIR 'info_seg.txt'], 'a');
%fprintf(fid,'Segment Information\n\n');
fprintf(fid,'Speech File: %s.wav\n', FileName);
imgFile = [oDIR FileName '_Segment.png'];
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
fprintf('T_E = %f  T_C = %f\n',T_E,T_C);
%---- Plot filtering feature sequences--------
%Plot original signal
subplot(3,1,1);
t1 = 1/fs:1/fs:(length(x)/fs);
plot(t1, x);
legend('OriginalSpeech');
xlabel('Time (s)');
ylabel('Amplitude');
%title('Original Speech Signal');

%Plot short-term energy of signal
subplot(3,1,2); 
t2=1/fs:step:(length(E)*step);
plot(t2, E); 
legend('ShortTimeEnergy');
xlabel('Time (s)');
ylabel('Energy');

%Plot spectral of signal
subplot(3,1,3); 
t2=1/fs:step:(length(C)*step);
plot(t2, C); 
legend('SpectralCentroid');
xlabel('Time (s)');
ylabel('SpectralEnergy');
%---------------------------------------------
%fprintf('Showing filtering feature sequences. Press any key to continue...\n');
%pause
%Plot short-term energy of signal
subplot(4,1,1);
t1 = 1/fs:1/fs:(length(x)/fs);
plot(t1, x);
legend('OriginalSpeech');
xlabel('Time (s)');
ylabel('Amplitude');
%title('Original Speech Signal');

%Plot short-term energy of signal
subplot(4,1,2); 
t2=1/fs:step:(length(E)*step);
plot(t2, E); 
legend('ShortTimeEnergy');
xlabel('Time (s)');
ylabel('Energy');

%Plot spectral of signal
subplot(4,1,3); 
t2=1/fs:step:(length(C)*step);
plot(t2, C); 
legend('SpectralCentroid');
xlabel('Time (s)');
ylabel('SpectralEnergy');

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
fprintf('Total Segment: %d\n',size(Limits,1));
k = 1;
newLimits = [];
for (i=1:size(Limits,1))
    sSeg(i) = Limits(i,1);
    eSeg(i) = Limits(i,2);
    fprintf('Segment[%2d]: Start = %5d  End = %5d Samples = %5d\n',i,sSeg(i),eSeg(i),(eSeg(i)-sSeg(i)));
    if (eSeg(i)-sSeg(i))<1500
        continue;
    end
    if i>1 && k>1 && (sSeg(i)-newLimits(k-1,2))<500 %300 %500
       newLimits(k-1,2) = eSeg(i);
       continue;
    end
    newLimits = [newLimits; sSeg(i) eSeg(i)];
    k = k+1;
end
% Word segments:
[nSeg c1] = size(newLimits);
nSample = length(x); 
fprintf(fid,'Word Segments: %d\n', nSeg);
fprintf('Word Segments: %d\n', nSeg);
segments = {};
for i=1:nSeg
    if newLimits(i,2)> nSample
        newLimits(i,2) = nSample;
    end
    segments{i} = x(newLimits(i,1):newLimits(i,2));
    fprintf('WordSeg[%2d]: Start = %5d  End = %5d Samples = %5d\n',i,newLimits(i,1),newLimits(i,2),length(segments{i}));
    fprintf(fid,'WordSeg[%2d]: Start = %5d  End = %5d Samples = %5d\n',i,newLimits(i,1),newLimits(i,2),length(segments{i}));
end
% Plot and play speech segments:
subplot(4,1,4);
t1 = 1/fs:1/fs:(length(x)/fs);
hold off;
P1 = plot(t1, x); set(P1, 'Color', [0.7 0.7 0.7]);
for (i=1:nSeg)
    hold on;
    timeTemp = newLimits(i,1)/fs:1/fs:newLimits(i,2)/fs;
    P = plot(timeTemp, segments{i});
    set(P, 'Color', [0.9 0.0 0.0]);
    %-----------------Write segments into .wav file-------------------%
    if i<10
        filename1  = [oDIR FileName 'S0' num2str(i) '.wav'];
    else
        filename1  = [oDIR FileName 'S' num2str(i) '.wav'];
    end
    wavwrite(segments{i},fs,filename1);
    %clc;
    % Playing segmented word
     sound(segments{i}, fs);
    pause(0.5); % pause(n) - wait for n seconds
end
print('-dpng', imgFile);
fclose(fid);
fprintf('Segmentation process has been completed...\n');