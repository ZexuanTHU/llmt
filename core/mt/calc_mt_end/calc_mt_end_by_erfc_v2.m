function calc_mt_end_by_erfc_v2
%% CALC_MT_END_BY_ERFC determines the MT end center by fitting an
% erfc function

% Overvall procedure;
% 1. initial estimation from calc_mt_end
% 2. secondary estimation by fitting erfc model    

% Note:
% the lines from user input are not used here
% the kymographs are not used here

%% parameters
global gb_params; % kymograph_n, mt_sigma

%% Input: gb_mt_imgs, gb_mt_lines
global gb_mt_imgs;
global gb_mt_plus_params; % parameters obtained by calc_mt_end

%% Output: gb_mt_plus_params_erfc
global gb_mt_plus_params_erfc; % parameters of the fitting procedure
gb_mt_plus_params_erfc = struct('center', {}, ... % x+yi
                               'sigma', {}, ... % half width
                               'direction', {}, ... % rad
                               'amplitude', {}, ... % a.u.
                               'baseline', {}, ... % a.u.
                               'residue', {}, ... % residual
                               'exitflag', {} ... % exitflag of fitting
                               );

%% Variables:
[img_h, img_w, num_frames] = size(gb_mt_imgs);
num_mt_lines = numel(gb_mt_plus_params);
if(num_mt_lines==0)
    return;
end

%% init gb_mt_plus_params_erfc
for jj = 1:num_mt_lines
    gb_mt_plus_params_erfc(jj).center = complex(nan(num_frames, 1));
    gb_mt_plus_params_erfc(jj).sigma = nan(num_frames, 1);
    gb_mt_plus_params_erfc(jj).direction = nan(num_frames, 1);
    gb_mt_plus_params_erfc(jj).amplitude = nan(num_frames, 1);
    gb_mt_plus_params_erfc(jj).baseline = nan(num_frames, 1);
    gb_mt_plus_params_erfc(jj).residue = nan(num_frames, 1);
    gb_mt_plus_params_erfc(jj).exitflag = nan(num_frames, 1);
end

%% Calculating coarse centers and direction
% from gb_mt_plus_params
coarse_cens = complex(zeros(num_frames, num_mt_lines));
coarse_local_lens = zeros(num_frames, num_mt_lines);
pss = complex(zeros(num_frames, num_mt_lines));
pes = complex(zeros(num_frames, num_mt_lines));

coarse_cens = cat(2, gb_mt_plus_params.center);
coarse_dirs = cat(2, gb_mt_plus_params.direction);
pss = coarse_cens - gb_params.crop_radius_px_erfc_v2 ...
      *( cos(coarse_dirs) + sqrt(-1)*sin(coarse_dirs) );
pes = coarse_cens + gb_params.crop_radius_px_erfc_v2 ...
      *( cos(coarse_dirs) + sqrt(-1)*sin(coarse_dirs) );


%% Calculating fine centers and direction by fitting
% global params_out res exitflg;
params_out = zeros(num_frames, 4, num_mt_lines);
res = zeros(num_frames, num_mt_lines);
exitflag = zeros(num_frames, num_mt_lines);
calc_flag = ~isnan(coarse_cens);

for jj = 1:num_mt_lines
    current_lines = cat(1, pss(:,jj).', pes(:,jj).');
    [params_out(:,:,jj),res(:,jj),exitflag(:,jj)] = ...
        fit_mt_end_by_erfc_v2( ...
            gb_mt_imgs, ...
            gb_params.fit_d, ...
            gb_params.crop_radius_px_erfc_v2*2, ...
            coarse_cens(:,jj), ...
            current_lines, ...
            calc_flag(:,jj) ...
            );
end

for jj = 1:num_mt_lines
    % ps = gb_mt_lines(jj).line(1);
    % pe = gb_mt_lines(jj).line(2);
    ps = pss(:,jj);
    pe = pes(:,jj);
    gb_mt_plus_params_erfc(jj).center = ...
        ps + (pe-ps).*params_out(:,1,jj)/ ...
        (gb_params.crop_radius_px_erfc_v2*2);
    gb_mt_plus_params_erfc(jj).sigma = params_out(:,2,jj);
    % erfc doesn't contain the direction parameter
    gb_mt_plus_params_erfc(jj).direction = ...
        ones(num_frames,1).*angle(pe-ps);
    gb_mt_plus_params_erfc(jj).amplitude = params_out(:,3,jj);
    gb_mt_plus_params_erfc(jj).baseline = params_out(:,4,jj);
    gb_mt_plus_params_erfc(jj).residue = res(:,jj);
    gb_mt_plus_params_erfc(jj).exitflag = exitflag(:,jj);
    gb_mt_plus_params_erfc(jj).local_length = params_out(:,1,jj);
end


end
