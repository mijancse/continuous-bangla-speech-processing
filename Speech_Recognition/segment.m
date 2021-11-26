function segment = segment(sample,fs,segment_duration,segment_shift)
% Read speech file
%[sample,fs] = wavread(file);

%subplot(1,2,1)
%plot(sample)
%title('Original Signal')

% Calling end-point detection module
sample=endpt(sample);

%subplot(1,2,2)
%plot(sample)
%title('Signal after end-point detection')

% fs=8000;
% Find the length of speech sample
sample_length = length(sample);
%plot(sample);
sample_duration = sample_length/fs ;       % In seconds
sample_intervals = round(sample_duration/segment_duration);% In array elements
% sample_intervals = sample_length/128;

% Find the size of an interval
sample_interval_size = round(sample_length/sample_intervals);   % In array elements
% sample_interval_size = 160

% Find the number of shifts in sample
sample_shifts = round(sample_duration/segment_shift);
sample_shift_size = round(sample_length/sample_shifts);
% sample_shifts = sample_length/80
% sample_shift_size = 80;

% Split speech into intervals
% Create an empty array 
segment = zeros(sample_interval_size,sample_shifts);

% Begin at element 1
i_begin = 1;    
j_begin = 1;    

% End at the element size of the interval
i_end = sample_interval_size; 
j_end = sample_interval_size;
j_exception = 0;

% Start to segment speech sample
for i = 1:sample_shifts
    % End elements are greater than size of sample for last couple of
    % segments
    if j_exception == 1
        segment(i_begin:sample_length) = sample(i_begin:sample_length);
    else
        segment(i_begin:i_end) = sample(j_begin:j_end);
    end
    
    i_begin = i_end + 1;
    i_end = i_begin + sample_interval_size - 1;
    
    % Shift by element size of shift
    j_begin = j_begin + sample_shift_size;
    j_end = j_begin + sample_interval_size - 1;
    
    % Shift until end element, j_end, is greater than number of elements 
    % in sample, sample_length
    if j_end > sample_length
       j_exception = 1; 
    end
end

[row,column] = size(segment);

% Delete zero columns, which causes problems when determining the
% Mel-Cepstrum coefficients
for c = column:-1:1
    if segment(:,c) == 0 
        segment(:,c) = [];
    end
end
