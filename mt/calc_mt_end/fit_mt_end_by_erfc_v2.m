function [param_out, res, exitflag] = fit_mt_end_by_erfc_v2(img, ...
                                                  line_width, ...
                                                  profile_n, ...
                                                  coarse_centers, ...
                                                  current_lines, ...
                                                  varargin)
%% FIT_MT_END_BY_ERFC_V2 fits the MT end by an erfc and returns the
% parameters
% ~ means ignoring some parameters

% Inputs:
% img: image series
% line_width: the width of the profiling line
% profile_n: number of profiling points
% coarse_centers: coarse centers
% current_lines: 2*n complex vector, start, end
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
    xdats = real(current_lines); % plural form
    ydats = imag(current_lines); % plural form
    pss = current_lines(1,:); % plural form
    pes = current_lines(2,:); % plural form
    
    calc_flag = logical(ones(n,1));
    % exclude those lines which are out of [h,w]
    tmpx1 = xdats(1,:).';
    tmpx2 = xdats(2,:).';
    tmpy1 = ydats(1,:).';
    tmpy2 = ydats(2,:).';
    calc_flag = tmpx1>0.5 & tmpx1<(w+0.5) & ...
        tmpx2>0.5 & tmpx2<(w+0.5) & ...
        tmpy1>0.5 & tmpy1<(h+0.5) & ...
        tmpy2>0.5 & tmpy2<(h+0.5);
    if(nargin>5)
        calc_flag = varargin{1} & calc_flag;
    end

    % fitting
    param_in = zeros(1,4); % l, sigma, amplitude, baseline    
    param_out = nan(n, 4);
    res = nan(n,1);
    exitflag = nan(n,1);

    % OPTIONS = optimoptions('lsqcurvefit', ...
    %                          'Algorithm', 'levenberg-marquardt', ...
    %                          'Display','off');
    OPTIONS = optimoptions('lsqcurvefit', ...
                             'Algorithm', 'trust-region-reflective', ...
                             'Display','off');

    for j = 1:n
        if(~calc_flag(j))
            continue;
        end
        % profiling
        xdat = xdats(:,j);
        ydat = ydats(:,j);
        ps = pss(j);
        pe = pes(j);
        profile = my_line_profile(img(:,:,j), ...
                                  xdat, ...
                                  ydat,...
                                  line_width, ...
                                  profile_n);
        pc = coarse_centers(j);
        ydata = profile;
        xdata = 1:length(ydata);
        xdata = reshape(xdata, size(ydata));
        [mmax,Imax] = max(profile);
        [mmin,Imin] = min(profile); 
        mmean = mean(profile);
        mstd = std(profile);
        param_in = [0.5*profile_n, ...
                    (Imin-Imax+1)/(2*sqrt(2)), ...
                    mmax-mmin, ...
                    mmin];
        param_lb = [1, ...
                    0, ...
                    mstd, ...
                    0.5*mmin];
        param_ub = [profile_n, ...
                    profile_n, ...
                    mmax, ... % assume that mmin>0
                    mmean];

        % optimization
        [a, b, ~, c, ~] = ...
            lsqcurvefit(@mt_erfc, ...
                        param_in, ...
                        xdata, ...
                        ydata, ...
                        param_lb, ...
                        param_ub, ...
                        OPTIONS);
        res(j) = b;
        exitflag(j) = c;
        param_out(j,1:4) = a;
        % sigma unit correction
        param_out(j,2) = param_out(j,2)*abs(pe-ps)/profile_n;

    end

end
