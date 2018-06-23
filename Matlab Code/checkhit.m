function hit = checkhit(xn, yn, A)
% Function for checking if a set of x y co-ordinates has hit a barrier.

% INPUTS
% xn = array of x co-ordinates
% yn = array of y co-ordinates
% A = logical image of barriers

% OUTPUT
% hit = boolean array indicating particle has hit barrier

%% Convert co-ordinate pair into array index
rowsz = size(A,1);
columnsz = size(A, 2);

columns = xn + (columnsz/2) + 1; % converts co-ordinate to array index
rows = -yn + (rowsz/2) + 1; % converts co-ordinate to array index

%% check if particle index corresponds to a hit on the barrier image

hit = false(size(xn));

for i = 1:length(xn)
    if A(rows(i), columns(i)) == 1
        hit(i) = true;
    end
end


