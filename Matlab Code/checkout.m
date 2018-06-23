function out = checkout(xn, yn, A)
% Function for checking if a set of co-ordinate pair is outside of a 
% logical array of barriers

% INPUTS
% xn = array of x co-ordinates
% yn = array of y co-ordinates
% A = logical array of barriers

% OUTPUT
% out = boolean array indicating if a particle is outside of the barrier

rowsz = size(A,1);
columnsz = size(A, 2);

out = false(size(xn));

for i = 1:length(xn)
    if abs(2 * xn(i)) >= columnsz || abs(2 * yn(i)) >= rowsz
        out(i) = true;
    end
end