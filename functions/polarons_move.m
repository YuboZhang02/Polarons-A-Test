function polarons_realspace_potential = polarons_move(ss,iter)
    

    polarons_realspace_potential = zeros(ss.Ny,ss.Nx);

    % first calculate each polaron center at time t
    % then add each of their potential one by one to give overall potential
    

    % access global parameters defined in polarons_setup
    global polarons_pos_x_list;
    global polarons_pos_y_list;
    global polarons_vel_x_list;
    global polarons_vel_y_list;


    for index02 = 1 : ss.polaron_number 
       
        polaron_x_pos_t = polarons_pos_x_list(index02) + polarons_vel_x_list(index02) * ss.tau * iter;
        polaron_y_pos_t = polarons_pos_y_list(index02) + polarons_vel_y_list(index02) * ss.tau * iter;

        % for periodic considerations, we don't want polarons to move away
        % get them back by mod ss.Lx

        %polaron_x_pos_t = mod(polaron_x_pos_t,ss.Lx);
        %polaron_y_pos_t = mod(polaron_y_pos_t,ss.Ly);

        switch ss.polaron_potential_shape
        
            case 'bessel_function'
                R = (((ss.x - polaron_x_pos_t)/ss.Lx * 100).^2 + ((ss.y - polaron_y_pos_t)/ss.Ly * 100).^2).^0.5;
                polarons_realspace_potential = polarons_realspace_potential + ss.polaron_potential_height * besselj(0, R) .* exp(-ss.polaron_potential_damping * R);
        
            case 'gaussian_function'
                Gaussian_sigma = ss.Gaussian_sigma_factor * ss.delx;
                polarons_realspace_potential = polarons_realspace_potential + ss.polaron_potential_height * exp(-((ss.x - polaron_x_pos_t).^2 / (2 * Gaussian_sigma^2) + (ss.y - polaron_y_pos_t).^2 / (2 * Gaussian_sigma^2)));

        end

    end

end