function [param_out, res, exitflag] = fit_mt_end_by_erfc(img, ...
                                                  line_width, ...
                                                  profile_n, ...
                                                  coarse_centers, ...
                                                  current_line, ...
                                                  varargin)
%% FIT_MT_END_BY_ERFC fits the MT end by an erfc and returns the
% parameters
% ~ means ignoring some parameters

% Inputs:
% img: image series
% line_width: the width of the profiling line
% profile_n: number of profiling points
% coarse_centers: coarse centers
% current_line: 2*1 complex vector, start, end
% varargin: indicator of mt end missing, logical vector

% param_out:
% 1. l: the local (line coordinate) center of the erfc
% 2. sigma
% 3. amplitude
% 4. baseline

% exitflag:
% 1 Function converged to a solution x.
% 2 Change in x was less than the specified tolerance.
% 3 Change in the residual was less than the specified tolerance.
% 4 Magnitude of search direction was smaller than the specified tolerance.
% 0 Number of iterations exceeded options.MaxIterations or number of function evaluations exceeded options.MaxFunctionEvaluations.
% -1 Output function terminated the algorithm.
% -2 Problem is infeasible: the bounds lb and ub are inconsistent. 

    [h, w, n] = size(img);
    xdat = real(current_line);
    ydat = imag(current_line);
    ps = current_line(1);
    pe = current_line(2);
    
    calc_flag = logical(ones(n,1));
    if(nargin>5)
        calc_flag = varargin{1};
    end

    % fitting
    param_in = zeros(1,4); % l, sigma, amplitude, baseline    
    param_out = nan(n, 4);
    res = nan(n,1);
    exitflag = nan(n,1);

    OPTIONS = optimoptions('lsqcurvefit', ...
                             'Algorithm', 'levenberg-marquardt', ...
                             'Display','off');

    for j = 1:n
        if(~calc_flag(j))
            continue;
        end
        % profiling
        profile = my_line_profile(img(:,:,j), ...
                                  xdat, ...
                                  ydat,...
                                  line_width, ...
                                  profile_n);
        pc = coarse_centers(j);
        ind_mid = round((abs(pc-ps)/abs(pe-ps))*profile_n);
        [mmax, mmin, mmid, Imax, Imin, Imid] = p_find_v2(...
            profile, ...
            ind_mid);
        
        % method 1 to determine the start and end points used to
        % fit
        Imid = Imid/2 + ind_mid/2;
        % check if the curve shape looks like erfc
        if(~(Imid>Imax && Imid<Imin))
            continue;
        end
        % extend beyond the max & min value for fitting
        % ext_n = round(profile_n/10); 
        ext_n = 2;
        Is = 1; % start index
        if ((Imax-ext_n) > 0)
            Is = Imax-ext_n;
        end
        Ie = profile_n;
        if ((Imin+ext_n) < profile_n)
            Ie = Imin+ext_n;
        end
        
        
        ydata = profile(Is:Ie);
        xdata = 1:length(ydata);
        xdata = reshape(xdata, size(ydata));
        param_in = [Imid-Is+1, ...
                    (Imin-Imax+1)/(2*sqrt(2)), ...
                    mmax-mmin, ...
                    mmin];

        % optimization
        [a, b, ~, c, ~] = ...
            lsqcurvefit(@mt_erfc, ...
                        param_in, ...
                        xdata, ...
                        ydata, ...
                        [], ...
                        [], ...
                        OPTIONS);
        res(j) = b;
        exitflag(j) = c;
        param_out(j,1:4) = a;
        % sigma unit correction
        param_out(j,2) = param_out(j,2)*abs(pe-ps)/profile_n;
        param_out(j,1) = param_out(j,1)+Is-1;

    end


    function [mmax, mmin, mmid, Imax, Imin, Imid] = p_find(profile)
        [mmax, Imax] = max(profile);
        [mmin, Imin] = min(profile);
        mmid = (mmax+mmin)/2;
        profile2 = profile(Imax:Imin);
        [~, Imid] = min((profile-mmid).^2);
        Imid = Imid+Imax-1;
    end

    function [mmax, mmin, mmid, Imax, Imin, Imid] = p_find_v2(profile, ...
                                                          ind_mid)
        [mmax, Imax] = max(profile(1:ind_mid));
        [mmin, Imin] = min(profile(ind_mid:end));
        Imin = Imin + ind_mid - 1;
        mmid = (mmax+mmin)/2;
        profile2 = profile(Imax:Imin);
        [~, Imid] = min((profile-mmid).^2);
        Imid = Imid+Imax-1;
    end

end
