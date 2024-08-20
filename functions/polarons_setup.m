function polarons_realspace_potential = polarons_setup(ss)

    polarons_realspace_potential = zeros(ss.Ny,ss.Nx);
    

    % define global parameters that must be used in polarons_move
    global polarons_pos_x_list;
    global polarons_pos_y_list;
    global polarons_vel_x_list;
    global polarons_vel_y_list;


    polarons_pos_x_list = zeros(1,ss.polaron_number);  % create a list to remember the position of each polaron, created randomly
    polarons_pos_y_list = zeros(1,ss.polaron_number);
    
    polarons_vel_x_list = zeros(1,ss.polaron_number);  % do the same for velocity
    polarons_vel_y_list = zeros(1,ss.polaron_number);


    for index01 = 1 : ss.polaron_number     % generate random position and velocity for each of polarons
        rand_x_grid = randi(ss.Nx);
        rand_y_grid = randi(ss.Ny);

        rand_x_pos = -ss.Lx/2 + ss.delx * (rand_x_grid - 1);
        rand_y_pos = -ss.Ly/2 + ss.delx * (rand_y_grid - 1);

        polaron_velocity_angel = rand() * 360;
        polaron_x_velocity = ss.polaron_velocity * cosd(polaron_velocity_angel);
        polaron_y_velocity = ss.polaron_velocity * sind(polaron_velocity_angel);
        
        % record the initial data for every polaron
        polarons_pos_x_list(index01) = rand_x_pos;
        polarons_pos_y_list(index01) = rand_y_pos;

        polarons_vel_x_list(index01) = polaron_x_velocity;
        polarons_vel_y_list(index01) = polaron_y_velocity;    

    
        switch ss.polaron_potential_shape
        
           case 'bessel_function'
               R = (((ss.x - rand_x_pos)/ss.Lx * 200).^2 + ((ss.y - rand_y_pos)/ss.Ly * 200).^2).^0.5;
               polarons_realspace_potential = polarons_realspace_potential + ss.polaron_potential_height * besselj(0, R) .* exp(-ss.polaron_potential_damping * R);
        
           case 'gaussian_function'
               Gaussian_sigma = ss.Gaussian_sigma_factor * ss.delx;
               polarons_realspace_potential = polarons_realspace_potential + ss.polaron_potential_height * exp(-((ss.x - rand_x_pos).^2 / (2 * Gaussian_sigma^2) + (ss.y - rand_y_pos).^2 / (2 * Gaussian_sigma^2)));

        end

    end

    
    figure;
    surf(ss.x, ss.y, polarons_realspace_potential, 'EdgeColor', 'none');  % Use 'EdgeColor', 'none' for a smoother surface
    colorbar;
    title('polarons realspace potential');
    xlabel('x');
    ylabel('y');
    zlabel('z');
    view(2);  % View the plot from above to make it 2D
end