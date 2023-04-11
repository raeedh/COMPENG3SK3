clc; clear;

%% Initialize variables
alpha = 0.1;
N = 100;
K = 21;
lambda = 1e-4;
max_iterations = 100;

%% Implement the Newton’s method based denoising algorithm 
p_est_mean = newtons('mean', alpha, N, K, lambda, max_iterations);
p_est_first = newtons('first', alpha, N, K, lambda, max_iterations);
p_est_random = newtons('random', alpha, N, K, lambda, max_iterations);

%% Calculate root mean square error (RMSE)
fprintf("The root mean square error is with the average as the initialization scheme: %f\n", RSME(p_est_mean, N));
fprintf("The root mean square error is with the first coordinate as the initialization scheme: %f\n", RSME(p_est_first, N));
fprintf("The root mean square error is with a random vector as the initialization scheme: %f\n", RSME(p_est_random, N));

%% Implement the Newton’s method based denoising algorithm
function p_est = newtons(init_scheme, alpha, N, K, lambda, max_iterations)
    p_est = zeros(N,3);

    %% Load data
    % load distances, d (dist)
    load('data for student/dist_R5_L40_N100_K21.mat','dist');
    % load LiDAR observation positions, q (pts_o)
    load('data for student/observation_R5_L40_N100_K21.mat','pts_o');
    % load LiDAR measurements, p (pts_markers)
    load('data for student/pts_R5_L40_N100_K21.mat','pts_markers');

    for i = 1:N
        %% extract coordinates, distances for marker and set appropriate p, d, q values
        p_hat = squeeze(pts_markers(:,i,:));
        d = dist(i,:);
        q = pts_o;

        %% initalize value of p(0)
        switch init_scheme
            case 'mean'
                p0 = p0_init_mean(p_hat);
            case 'first'
                p0 = p0_init_first(p_hat);
            case 'random'
                p0 = p0_init_random;
        end
        
        p = p0.';

        for j = 1:max_iterations
        r = zeros(K,1);
        J = zeros(K,3);

        %% Calculate and update iteration
        for k = 1:K
            % Calculate r and J
            r(k) = norm(p-q(k,:).') - d(k);
            
            J(k,:) = [...
            (p(1) - q(k,1).') / (r(k) + d(k)),...
            (p(2) - q(k,2).') / (r(k) + d(k)), ...
            (p(3) - q(k,3).') / (r(k) + d(k))];

        end
        % Calculate g and H
        g = (J.' * r) + (lambda * sum(2*(p.'-p_hat)).');
        H = (J.' * J) + (2*lambda*K*eye(3));

        % Update iteration
        p = p - alpha*inv(H)*g;
        end

        p_est(i,:) = p;
    end
end

function val = RSME(p_est, N)
    % load ground-truth oordinates, (pts_marks_gt)
    load('data for student/gt_R5_L40_N100_K21.mat','pts_marks_gt');

    val = sqrt((1/N) * norm(p_est - pts_marks_gt)^2);
end

%% Initalize p(0) to average (mean) of  K measured coordinates
function p0 = p0_init_mean(p)
    p0 = [mean(p(:,1)) mean(p(:,2)) mean(p(:,3))];
end

%% Initalize p(0) to the first measured coordinate
function p0 = p0_init_first(p)
    p0 = p(1,:);
end

%% Initalize p(0) to random vector of normally distributed random numbers
function p0 = p0_init_random
    rng(200) % use seed of 200    
    p0 = randn(1,3);
end