function M = max3(A,B,C)
if A>B
    if A>C
        M = A;
    else
        M = C;
    end
else
    if B>C
        M = B;
    else
        M = C;
    end
end
return;