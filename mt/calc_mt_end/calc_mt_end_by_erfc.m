function calc_mt_end_by_erfc
%% CALC_MT_END_BY_ERFC determines the MT end center by fitting an
% erfc function

%% parameters
global gb_params; % kymograph_n, mt_sigma

%% Input: gb_mt_imgs, gb_mt_lines
global gb_mt_imgs gb_mt_lines;

%% Output: gb_mt_end_params_erfc
global gb_mt_end_params_erfc; % parameters of the fitting procedure
gb_mt_end_params_erfc = struct('center', {}, ... % x+yi
                               'sigma', {}, ... % half width
                               'direction', {}, ... % rad
                               'amplitude', {}, ... % a.u.
                               'baseline', {}, ... % a.u.
                               'residue', {}, ... % residual
                               'exitflag', {}, ... % exitflag of fitting
                               'local_length', {} ... % used as an indicator
                               );

%% Variables:
[img_h, img_w, num_frames] = size(gb_mt_imgs);
num_mt_lines = numel(gb_mt_lines);
if(num_mt_lines==0)
    return;
end

%% check if the kymographs contain backward time series
for jj = 1:num_mt_lines
    kymo = gb_mt_lines(jj).kymograph;
    num_kymo_points = numel(kymo);
    for kk = 1:(num_kymo_points-1)
        if(imag(kymo(kk+1)-kymo(kk))<=0)
            msgbox('kymograph contains backward time series');
            return;
        end
    end
end

%% init gb_mt_end_params_erfc
for jj = 1:num_mt_lines
    gb_mt_end_params_erfc(jj).center = complex(nan(num_frames, 1));
    gb_mt_end_params_erfc(jj).sigma = nan(num_frames, 1);
    gb_mt_end_params_erfc(jj).direction = nan(num_frames, 1);
    gb_mt_end_params_erfc(jj).amplitude = nan(num_frames, 1);
    gb_mt_end_params_erfc(jj).baseline = nan(num_frames, 1);
    gb_mt_end_params_erfc(jj).residue = nan(num_frames, 1);
    gb_mt_end_params_erfc(jj).exitflag = nan(num_frames, 1);
    gb_mt_end_params_erfc(jj).local_length = -1*ones(num_frames, 1);
end

%% Calculating coarse centers and direction
% from gb_mg_lines struct
coarse_cens = complex(zeros(num_frames, num_mt_lines));
coarse_local_lens = zeros(num_frames, num_mt_lines);

for jj = 1:num_mt_lines
    ends = complex(zeros(num_frames,1));
    local_lens = zeros(num_frames,1);
    kymo = gb_mt_lines(jj).kymograph;
    tmp_line = gb_mt_lines(jj).line;
    ps = tmp_line(1);
    pe = tmp_line(2);
    %    [ps, pe] = gb_mt_lines(jj).line;
    [ends, local_lens] = kymo_to_ends(kymo, ps, pe, gb_params.kymograph_n, ...
                                      num_frames);
    coarse_cens(:,jj) = ends(:,1);
    coarse_local_lens(:,jj) = local_lens(:,1);
end


%% Calculating fine centers and direction by fitting
% global params_out res exitflg;
params_out = zeros(num_frames, 4, num_mt_lines);
res = zeros(num_frames, num_mt_lines);
exitflag = zeros(num_frames, num_mt_lines);
calc_flag = coarse_local_lens>0; % used to exclude frames without MT

for jj = 1:num_mt_lines
    [params_out(:,:,jj),res(:,jj),exitflag(:,jj)] = ...
        fit_mt_end_by_erfc( ...
            gb_mt_imgs, ...
            gb_params.fit_d, ...
            gb_params.kymograph_n, ...
            coarse_cens(:,jj), ...
            gb_mt_lines(jj).line, ...
            calc_flag(:,jj) ...
            );

end

for jj = 1:num_mt_lines
    ps = gb_mt_lines(jj).line(1);
    pe = gb_mt_lines(jj).line(2);
    gb_mt_end_params_erfc(jj).center = ...
        ps + (pe-ps)*params_out(:,1,jj)/gb_params.kymograph_n;
    gb_mt_end_params_erfc(jj).sigma = params_out(:,2,jj);
    % erfc doesn't contain the direction parameter
    gb_mt_end_params_erfc(jj).direction = ...
        ones(num_frames,1)*angle(pe-ps);
    gb_mt_end_params_erfc(jj).amplitude = params_out(:,3,jj);
    gb_mt_end_params_erfc(jj).baseline = params_out(:,4,jj);
    gb_mt_end_params_erfc(jj).residue = res(:,jj);
    gb_mt_end_params_erfc(jj).exitflag = exitflag(:,jj);
    gb_mt_end_params_erfc(jj).local_length = params_out(:,1,jj);
end


end
