function mc=melcep(sample,fs,cf,mf)
% Inputs: in  Wav. file
%         cf  Desired cepstrum coefficients
%         mf  Desired MFCC filters
out = fopen('mfccFile.txt','w'); 
% Default length of cepstrum
if nargin<3 
    cf=12;         % Give 12 coefficients  
    mf=20;         % Use 20 MFCC filters
else 
    cf=20;         % Use 20 MFCC filters
end

% Segment of speech signal
inseg=segment(sample,fs,20E-3,10E-3);  
[row,col]=size(inseg);
% Store Mel-Cepstrum coefficients 
mc=zeros(col,cf);

% Each column represents a segment of 20ms, we want to find the
% coefficients that represent that 20ms. 
for c=1:col
    % Window speech using Hamming window
      hw=hamming(length(inseg(:,c)));
    
    % Window speech using Hanning window
    % hw=hann(length(inseg(:,c)));
    % Window speech using Blackman window
    % hw=blackman(length(inseg(:,c)));
    % Window speech using Minimum 4-term Blackman-Harris window
    % hw=blackmanharris(length(inseg(:,c)));
    
    win=inseg(:,c).*hw;
    
    % Take the FFT of the speech signal
    IN=fft(win);
    fs=8000;        % Sampling frequency
    F=-fs/2+(fs/length(win)):fs/length(win):fs/2;   
    
    % Take right half of speech signal
    IN=abs(IN(round(row/2):row));
    % We are only interested in right half of speech signal and right portion
    % of frequencies
    F=F(round(row/2):row)';
    
    % Find S(w), which is the sum of abs(speech(f)) * filter(f)
    % Warp speech signal frequencies into Mel frequencies
    melF=2595*log10(1+F/700);
    % Take magnitude of Mel frequencies
    melF=abs(melF);
   
    % Create MFCC filter
    w=300;      % Width of triangular filters
    h=1;        
    mel=zeros(w,1);
    for f=1:w/2
        mel(f)=f*1/(w/2); 
    end
    for f=w/2:w
        mel(f)=1-(f-w/2)/(w/2); 
    end
    f=1:300;
    % Plot MFCC filter
    % plot(f,mel);
    
    % Find the power of speech signal
    IN=IN.*IN;
    % Plot power of speech signal over Mel frequencies
    % plot (melF,IN);
    
    % Need to line up Mel frequencies and speech signal in order
    % multiply power of speech signal by MFCC filter
    for k=1:mf
                                    % mel(f)=value of MFCC filter at
                                    % frequency f               
                                    % melF=frequency of speech signal
        S(k)=0;
        for m=1:length(melF)
            if f(1)<round(melF(m)) & round(melF(m))<f(300)  
                S(k)=S(k)+IN(m)*mel(round(melF(m))-(k-1)*150);
            end
        end
        f=f+150;
    end 

    % Find the Mel cepstrum coefficients
    for n=1:cf   
        % Find all cepstrum, coefficients
        C(n)=0;
        for k=1:mf
            % Find one cepstrum coefficient
            if S(k)==0
                C(n)=C(n);
            else
                C(n)=C(n)+log(S(k))*cos(n*(k-.5)*pi/mf);
            end
        end
    end
    mc(c,:)=C;
    fprintf(out,'%f\n',C);
end
fclose(out);