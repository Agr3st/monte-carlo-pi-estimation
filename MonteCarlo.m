close all; clear; clc;


N = 1e5;
M = 10;
point = zeros(N*M, 2);
points_in = zeros(N, 2);
points_out = zeros(N, 2);
ki = 0;          % licznik punktów in 
ko = 0;          % licznik punktów out
m = zeros(4, 1); % liczba punktów in po iteracji 100, 1000, 10000, 100000
n = zeros(4, 1); % liczba punktów out po iteracji 100, 1000, 10000, 100000
estimated_pi = zeros(4*M, 1);
estimated_pi_instant = zeros(N,1);

idx = 1;
for j = 1:M
    temp=1;
    rng(j);
    ki = 0;
    for i = 1:N
        % losowanie liczb
        point(i + N * (j-1), :) = rand(1,2);
        
        % (dane do wykresu 1.) czy punkt leży w ćwiartce koła
        if point(i + N * (j-1), 2) <= sqrt( 1-point(i + N * (j-1), 1)^2 )
            if j == 1
                points_in(ki+1, :) = point(i, :);
            end
            ki = ki + 1;
        else
            if j == 1
                points_out(ko+1, :) = point(i, :);
                ko = ko + 1;
            end
        end

        % estymacja pi dla 100, 1000, 10000, 100000
        if mod(i, 10^( temp + 1) ) == 0
            
            estimated_pi(idx, 1) = 4 * ki / i;
            idx = idx + 1;
            % (dane dla 1. wykresu)
            if j == 1
                m(temp, 1) = ki;
                n(temp, 1) = ko;
            end
            temp = temp + 1;
        end
        estimated_pi_instant(i, j) = 4 * ki / i;
    end
end

% WYKRESY - JAK LOSOWANE SĄ PUNKTY
x = 0 : 0.01 : 1;
f = sqrt(1-x.^2);

subplot(221),
plot(points_in(1:m(1,1), 1), ...
    points_in( 1:m(1,1), 2), '.r', ...
    points_out(1:n(1,1), 1), ... 
    points_out(1:n(1,1), 2), '.b', ...
    x, f, 'g')
title("N = 100")
legend(sprintf('Estimated pi = %.6f', estimated_pi(1)), ...
    'Location', 'southwest');

subplot(222),
plot(points_in(1:m(2,1), 1), ...
    points_in( 1:m(2,1), 2), '.r', ...
    points_out(1:n(2,1), 1), ... 
    points_out(1:n(2,1), 2), '.b', ...
    x, f, 'g')
title("N = 1000")
legend(sprintf('Estimated pi = %.6f', estimated_pi(2)), ...
    'Location', 'southwest');

subplot(223),
plot(points_in(1:m(3,1), 1), ...
    points_in( 1:m(3,1), 2), '.r', ...
    points_out(1:n(3,1), 1), ... 
    points_out(1:n(3,1), 2), '.b', ...
    x, f, 'g')
title("N = 10 000")
legend(sprintf('Estimated pi = %.6f', estimated_pi(3)), ...
    'Location', 'southwest');

subplot(224),
plot(points_in(:,1), points_in(:, 2), '.r', ...
    points_out(:,1), points_out(:,2), '.b', ...
    x, f, 'g')
title("N = 100 000");
legend(sprintf('Estimated pi = %.6f', estimated_pi(4)), ...
    'Location', 'southwest');

% WYKRES - DĄŻENIE CHWILOWE LICZBY PI
figure;
plot(1000:100000, estimated_pi_instant(1000:end, :));
xlim([1000 100000]);
title("Estymacja liczby \pi dla kolejno wylosowanych punktów")
xlabel('Liczba losowań (od 1000)');
ylabel('Estymowana wartość \pi');
yline(pi, 'g');

% WYKRES - ROZKŁAD ESTYMACJI LICZBY PI
boxes = zeros(4, 10);
for i = 1:4
    boxes(i, :) = estimated_pi(i:4:end);
end

figure;
boxplot(boxes', 'Labels', {'100', '1000', '10 000', '100 000'});
yline(pi, 'g')
title('Rozkład estymacji liczby \pi w zależności od liczby punktów');
xlabel('Liczba wylosowanych punktów');
ylabel('Estymacja liczby \pi');
grid on;