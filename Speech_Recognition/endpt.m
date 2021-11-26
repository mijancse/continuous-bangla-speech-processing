% End-Point Detection Technique
function incut=endpt(sample);
% Find the starting point
i=1;
cont=1;
while (cont==1)
    if sample(i,1)>0.1 % Threshold 
        begin=i;
        cont=0;
    else
        i=i+1;
    end
end

% Find the ending point
i=length(sample);
cont=1;
while (cont==1)
    if sample(i,1)>0.1 % Threshold 
        theend=i;
        cont=0;
    else
        i=i-1;
    end
end
incut=sample(begin:theend,1);