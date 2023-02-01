clear; clc; close all;

%% Initialize variables
n = single(2);
alt = single(-1);
x = single(1);
sum(1) = single(0);

% maximum number of terms calculated
N_max = 2^10;
num_err = single(zeros(1,N_max));

for N = 1:N_max
    %% processor 1
    % alternates between addition and subtraction
    alt_prev = alt;
    alt = alt * -1;

    %% processor 2
    % increments N
    n_prev = n;
    n = n + 1;
    
    %% processor 3
    % divide 1 / N
    x_prev = x;
    x = alt_prev / n_prev;
        
    %% processor 4
    % adds x to sum
    sum(N+1) = x_prev + sum(N);
end

%% Plotting error curve
% b = sum(2:end);
% x_plot = linspace(1,N_max,N_max);
% figure('Name','3SK3 Project 0: 4c', 'WindowState', 'maximized');
% plot(log2(x_plot), abs(log(2)-b),'LineWidth',3);
% 
% ax = gca;
% set(ax, 'YScale', 'log', 'FontSize', 32);
% xlabel('log2(N)'); ylabel('Numerical error')
% % title("Numerical Error against N",'FontSize',26)
% 
% f = gcf;
% exportgraphics(f,"q4c.png")
% exportgraphics(f,"./report/figures/q4c.png")