clear; clc;

sum = 0;
n = 2;
idk = 1;
x = 1;

% sum = single(sum); n = single(n); idk = single(idk); x = single(x);

N_max = 2^26;
% sum_keep = single(zeros(1,N_max));

for N = 1:N_max
    sum = sum + (idk/N);
    idk = idk * -1;

    sum_keep(N) = sum;
end

x_plot = linspace(1,N_max,N_max);
plot(log2(x_plot), abs(log(2)-sum_keep));
set(gca,'YScale','log');