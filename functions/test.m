% Define the range of x and y values
x = linspace(-10, 10, 500);  % Adjust the range as needed
y = linspace(-10, 10, 500);  % Adjust the range as needed

% Create a meshgrid for x and y
[X, Y] = meshgrid(x, y);

% Define the parameters for the Gaussian function
mu_x = 0;       % Mean in x direction
mu_y = 0;       % Mean in y direction
sigma_x = 1;    % Standard deviation in x direction
sigma_y = 1;    % Standard deviation in y direction

% Compute the 2D Gaussian function
Z = (1/(2*pi*sigma_x*sigma_y)) * exp(-((X - mu_x).^2 / (2 * sigma_x^2) + (Y - mu_y).^2 / (2 * sigma_y^2)));

% Plot the 2D Gaussian function
figure;
surf(X, Y, Z, 'EdgeColor', 'none');  % Use 'EdgeColor', 'none' for a smoother surface
colorbar;
title('2D Gaussian Function');
xlabel('x');
ylabel('y');
zlabel('f(x, y)');
view(2);  % View the plot from above to make it 2D
