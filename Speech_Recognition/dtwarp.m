%
% This file computes the distance between two vectors 
% using the dynamic time wrap technique.
%
function d=dtwarp(a,b)

% Find the cost matrix
[arow,acol]=size(a);
[brow,bcol]=size(b);
for r=1:arow
    for c=1:brow
        cst(r,c)=sum((a(r,:)-b(c,:)).^2); 
    end
end

% Find the size of the cost matrix
[row,col]=size(cst);
cpath=zeros(row,col);
step=zeros(row,col);
% Find the path of least cost
for c=1:col
    for r=1:row
        if c==1
            cpath(r,c)=cst(r,c);
        else
            % We are at cost(r,c), we want to look back:
            % Local path constraints
            % To the right
            right=cpath(r,c-1)+cst(r,c);
            % To the diagonal
            % There is no diagonal for the last row
            if r==1
                diagonal=inf;
            else
                diagonal=cpath(r-1,c-1)+cst(r,c);
            end
            % To the frontier, which is to move up two rows and over one column 
            % There is no frontier for the last two rows
            if r==1|r==2
                frontier=inf;
            else
                frontier=cpath(r-2,c-1)+cst(r,c);
            end
            % Take the path of least cost
            constraints=[right diagonal frontier];
            cpath(r,c)=min(constraints);
            % Records the steps
            if cpath(r,c)==right
                step(r,c)=r;
            elseif cpath(r,c)==diagonal
                step(r,c)=r-1;
            elseif cpath(r,c)==frontier
                step(r,c)=r-2;
            end
        end
    end
end

% Records the most efficient steps to take to get to the end point
% direction=zeros(1,col);
% Trace the last step
% prow=step(row,col);
% Record the step taken
% direction(1,col)=prow;
% c=col;
% for i=1:c-1
    % Go back a step
%     c=c-1;
    % This is the last row taken to get to the end point
%     prow = step(prow,c);
    % Record the step taken
%     direction(1,c)=prow;
% end 

% Record the cost for efficient path
d=cpath(row,col);