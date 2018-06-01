function param_out = fit_2d_filament_end(img, crop_radius, coarse_centers, ...
                                         current_line)
    %% FIT_2D_FILAMENT_END fits images to 2d filament end

    [h, w, n] = size(img);

    % cropping
    cropped = zeros(2*crop_radius+1, 2*crop_radius+1, n);
    for j = 1:n
        x0 = real(coarse_centers(j));
        y0 = imag(coarse_centers(j));
        cropped(:,:,j) = img(y0-crop_radius:y0+crop_radius, ...
                             x0-crop_radius:x0+crop_radius, ...
                             j);
    end

    % fitting
    x0 = 1+crop_radius;
    y0 = 1+crop_radius;
    sigma0 = 3.0;
    theta0 = angle(current_line(2)-current_line(1));
    param_in = [x0 ...
                y0 ...
                sigma0 ...
                theta0 ...
                0.0 ...
                0.0 ];
    
    param_out = zeros(n, 6);

    [xg, yg] = meshgrid(1:(2*crop_radius+1), 1:(2*crop_radius+1));
    xdata = cat(3, xg, yg);

    OPTIONS = optimoptions('lsqcurvefit', ...
                             'Algorithm', 'levenberg-marquardt', ...
                             'Display','off');

    for j = 1:n
        tmpimg = cropped(:,:,j);
        param_in(5) = max(tmpimg(:));
        param_in(6) = min(tmpimg(:));
        param_out(j,1:6) = ...
            lsqcurvefit(@FilamentTip2D, ...
                        param_in, ...
                        xdata, ...
                        tmpimg, ...
                        [], ...
                        [], ...
                        OPTIONS);
        param_out(j,1) = real(coarse_centers(j)) ...
            + param_out(j,1) ...
            - (1+crop_radius);
        param_out(j,2) = imag(coarse_centers(j)) ...
            + param_out(j,2) ...
            - (1+crop_radius);
    end


    function I = FilamentTip2D(params, xdata)

        x = xdata(:,:,1);
        y = xdata(:,:,2);

        % params:
        x0 = params(1);
        y0 = params(2);
        sigma = params(3);
        theta = params(4);
        H = params(5); % amplitude
        b = params(6); % baseline

        f = -(x-x0).*sin(theta-pi/2) + (y-y0).*cos(theta-pi/2) + 0.5;
        f( f < 0 ) = 0;
        f( f > 1 ) = 1;
        A = 1/(2*sigma^2);
        I = H*( f .*exp( -A*( ( x-x0 ).^2 + ( y-y0 ).^2 ) ) + ...
                (1-f).*exp( -A*(-( x-x0 )*sin(theta) + ( y-y0 )*cos(theta)).^2) ) + ...
            b;
    end

end