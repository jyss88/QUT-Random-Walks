function [x, y, M] = generate_particles(A, N, P)
    % Function to randomly generate particles inside a set of barriers
    
    % INPUTS
    % A = logical image of barriers
    % N = number of steps in simulation
    % P = probability of finding a particle on any given position
    
    % OUTPUTS
    % M = number of particles in simulation
    % x = N+1 by M matrix of particle x positions
    % y = N+1 by M matrix of particle y positions

    %% Create logical mask of particle positions
    sz = size(A, 1);
    randy = rand(sz, sz); % random array of numbers
    posit_array = randy > P & ~A; % logical mask of particle positions
    
    % posit_array is an image of the same size as A.
    % A true pixel represents a particle on the image.

    %% Generate x and y co-ordinates of particles
    % Pixel positions need to be converted to x and y co-ordinates, for
    % purposes of calculations
    M = sum(posit_array(:)); % number of particles

    x = zeros(N+1,M);  % set all x positions to zero initially
    y = zeros(N+1,M);  % set all y positions to zero initially

    p = 1;

    % Convert array positions to x and y co-ordinates
    for i = 1:sz
        for j = 1:sz
            if posit_array(i, j) == 1
                x(1, p) = j - (sz/2) - 1;
                y(:, p) = (sz/2) + 1 - i;
                p = p + 1;
            end
        end
    end
end 