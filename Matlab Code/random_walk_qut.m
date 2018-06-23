%% Initialisation   
close all; clear; clc;
load QUTWalks

%% Options
showAnimation = false; % Show animation of particles moving around campus.
                       % Shows initial and final frames otherwise.
randomPositions = true; % Randomly distribute particles around paths.
                         % Puts 500 points at fixed positions at B, V, and
                         % Z block, and on the paths between R and Q block,
                         % and Gov house and P block.
                         
M = 500;           % Default number of particles (used in fixed starting positions)
N = 100;          % the number of steps to take

Deltax = 3;        % the size of the jumps in x
Deltay = 3;        % the size of the jumps in y
% Note that Deltax and Deltay can only be integer values
%% Setup particles       
if randomPositions
    [x, y, M] = generate_particles(PathSpawn, N, 0.995); % Generate particles randomly accross paths
else % Generate particles according to set locations
    % Locations are at
    x = zeros(N+1,M);  % set all x positions to zero initially
    x(1, 1:M/5) = 90;
    x(1,(M/5)+1:2*M/5) = -90;
    x(1,(2*M/5)+1:3*M/5) = -70;
    x(1,(3*M/5)+1:4*M/5) = 230;
    x(1, (4*M/5)+1:M) = 370;

    y = zeros(N+1,M);  % set all y positions to zero initially
    y(:,1:M/5) = 90;
    y(:,(M/5)+1:2*M/5) = 250;
    y(:,(2*M/5)+1:3*M/5) = -90; 
    y(:,(3*M/5)+1:4*M/5) = -60;
    y(:,(4*M/5)+1:M) = 200; 
end

if M*N*8 > 3*1024^3
    error('You are requesting more than 3 GB of memory.  This is a bad idea.');
end

%% Simulation
for n = 1:N        % for each of the N jumps
    building_hit = ~checkhit(x(n+1,:), y(n+1,:), BuildingMask);
    doorway_hit = ~checkhit(x(n+1,:), y(n+1,:), JunctionMask);
    junction_hit = ~checkhit(x(n+1,:), y(n+1,:), Junctions);
    vertpath_hit = ~checkhit(x(n+1,:), y(n+1,:), PathUp);
    horzpath_hit = ~checkhit(x(n+1,:), y(n+1,:), PathsRight);
    
        
    r = rand(1,M); % generate M random numbers between 0 and 1

    left_mask  = (building_hit & r < 0.25) | (junction_hit & r < 0.25 ) | (vertpath_hit & r < 0.1) | (horzpath_hit & r < 0.4)| (doorway_hit & r < 0.25);                           % mask identifying the left-moving particles
    x(n+1, left_mask) = x(n, left_mask)  - Deltax;    % move those particles left
    y(n+1, left_mask) = y(n, left_mask);

    right_mask = (building_hit & r>= 0.25 & r < 0.5) | (junction_hit & r>= 0.25 & r < 0.5 ) | (vertpath_hit & r>= 0.1 & r < 0.2) | (horzpath_hit & r>= 0.4 & r < 0.8)| (doorway_hit & r < 0.25);                  % mask identifying the right-moving particles
    x(n+1, right_mask) = x(n, right_mask) + Deltax;   % move those particles right
    y(n+1, right_mask) = y(n, right_mask);

    down_mask = (building_hit & r>= 0.5 & r < 0.75) | (junction_hit & r>= 0.5 & r < 0.75 ) | (vertpath_hit & r>= 0.2 & r < 0.6) | (horzpath_hit & r>= 0.8 & r < 0.9)| (doorway_hit & r < 0.25);                 % mask identifying the down-moving particles
    x(n+1, down_mask) = x(n, down_mask);   
    y(n+1, down_mask) = y(n, down_mask) - Deltay;     % move those particles down

    up_mask = (building_hit & r>= 0.75 & r <= 1) | (junction_hit & r>= 0.75 & r <= 1 ) | (vertpath_hit & r>= 0.6 & r <= 1) | (horzpath_hit & r>= 0.9 & r <= 1)| (doorway_hit & r < 0.25);                          % mask identifying the up-moving particles
    x(n+1, up_mask) = x(n, up_mask);   
    y(n+1, up_mask) = y(n, up_mask) + Deltay;         % move those particles up

     % Check if a particle is outside bounds
    out_mask = checkout(x(n+1,:), y(n+1,:), Paths);
    % Revert all moves that have hit a barrier
    x(n+1, out_mask) = x(n, out_mask);
    y(n+1, out_mask) = y(n, out_mask);   
    
    
    % Check if a barrier has been hit
%     hit_mask = check_for_barrier_hits(x(n+1,:), y(n+1,:), Paths);
    hit_mask = checkhit(x(n+1,:), y(n+1,:), AllMask);
    % Revert all moves that have hit a barrier
    x(n+1, hit_mask) = x(n, hit_mask);
    y(n+1, hit_mask) = y(n, hit_mask);
end

Lx = max(abs(x(:))); % the furthest x position the particles reached
Ly = max(abs(y(:))); % the furthest y position the particles reached
L = max(Lx, Ly);

%% Animation
if showAnimation
    h = figure;         % remember the figure handle h
    for i = 1:N+1
        set(0,'CurrentFigure',h);  % make h the current figure (in case the user clicks on another figure during the animation)
        imshow('map_w_junction.jpg') 
        axis on;
        set(gca, 'YDir', 'reverse');
        hold on
        plot(x(i,:)+550, -y(i,:)+550, 'y.', 'MarkerSize', 10)
        xlabel('Position x_n');
        ylabel('Position y_n');
        axis equal
        title(['Step number n = ', num2str(i)]);
        drawnow
        hold off
    end
else % Only plot first and final frames
    % Plot initial frame
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(1, 2, 1)
    hold on
    imshow('map_w_junction.jpg')
    set(gca, 'YDir', 'reverse');
    hold on
    plot(x(1,:)+550, -y(1,:)+550, 'y.', 'MarkerSize', 10)
    axis equal
    title('Initial positions');
    
    % Plot final positions
    subplot(1, 2, 2)
    hold on
    hold on
    imshow('map_w_junction.jpg')
    set(gca, 'YDir', 'reverse');
    hold on
    plot(x(N+1,:)+550, -y(N+1,:)+550, 'y.', 'MarkerSize', 10)
    axis equal
    title(['Final positions, after ', num2str(N), ' iterations']);
end

%% Tally of People Entering Each Building
Sum_A = tally(ABlock, N, x, y);
Sum_B = tally(BBlock, N, x, y);
Sum_C = tally(CBlock, N, x, y);
Sum_D = tally(DBlock, N, x, y);
Sum_E = tally(EBlock, N, x, y);
Sum_F = tally(FBlock, N, x, y);
Sum_G = tally(GBlock, N, x, y);
Sum_GOV = tally(GovBlock, N, x, y);
Sum_H = tally(HBlock, N, x, y);
Sum_J = tally(JBlock, N, x, y);
Sum_M = tally(MBlock, N, x, y);
Sum_O = tally(OBlock, N, x, y);
Sum_P = tally(PBLock, N, x, y);
Sum_Q = tally(QBlock, N, x, y);
Sum_R = tally(RBlock, N, x, y);
Sum_S = tally(SBlock, N, x, y);
Sum_U = tally(UBlock, N, x, y);
Sum_V = tally(VBlock, N, x, y);
Sum_W = tally(WBlock, N, x, y);
Sum_X = tally(XBlock, N, x, y);
Sum_Y = tally(YBlock, N, x, y);
Sum_Z = tally(ZBlock, N, x, y);

Names = ["A Block";"B Block";"C Block";"D Block";"E Block";"F Block";"G Block";"GOV Block";"H Block";"J Block";"M Block"; "O Block"; "P Block";"Q Block";"R Block";"S Block";"U Block";"V Block";"W Block";"X Block";"Y Block";"Z Block";];
c = categorical(Names);
S = [Sum_A ; Sum_B ; Sum_C ; Sum_D ; Sum_E ; Sum_F ; Sum_G ; Sum_GOV ; Sum_H ; Sum_J ; Sum_M ; Sum_O ; Sum_P ; Sum_Q ; Sum_R ; Sum_S ; Sum_U ; Sum_V ; Sum_W ; Sum_X ; Sum_Y ; Sum_Z];

%% Plot bar graph of visitors to building
figure, bar(c, S)
xlabel('Number of visitors');
title('Visitors to each building');