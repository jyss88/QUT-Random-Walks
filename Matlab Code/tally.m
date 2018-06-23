function sum = tally(M, N, x, y)

% Function to tally the number of people who enetered a building
% M = Building Mask
% N = Number of Steps
% x = x-coordinates
% y = y-coordinates

sum = 0;
F = 0;

for i = 1:N
    people_hit = ~checkhit(x(i+1,:), y(i+1,:), M);
    [k] = find(people_hit);
    S = length(k);
    
    if F >= S
        F = S;
    else
        F =(S-F);
        sum = sum + F;
        F = F + (S-F);
    end       
end
