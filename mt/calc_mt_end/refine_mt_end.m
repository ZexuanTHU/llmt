function refine_mt_end
%% REFINE_MT_END refines the MT end center that are calculated
% by calc_mt_end.m
% model

% Overall procedure:
% 1. coarse estimation by cal_mt_end.m
% 2. fine estimation by fitting 2d model

% Todo:
% 1. tracking by kalman filter

%% parameters
global gb_params; % kymograph_n, mt_sigma

%% Input: gb_mt_imgs, gb_mt_lines
global gb_mt_imgs gb_mt_lines;

%% Output: gb_mt_end_params
global gb_mt_end_params;

mt_end_params_refined = struct('center', {}, ... % x+yi
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


%% init mt_end_params_refined
for jj = 1:num_mt_lines
    mt_end_params_refined(jj).center = complex(nan(num_frames, 1));
    mt_end_params_refined(jj).sigma = nan(num_frames, 1);
    mt_end_params_refined(jj).direction = nan(num_frames, 1);
    mt_end_params_refined(jj).amplitude = nan(num_frames, 1);
    mt_end_params_refined(jj).baseline = nan(num_frames, 1);
    mt_end_params_refined(jj).residue = nan(num_frames, 1);
    mt_end_params_refined(jj).exitflag = nan(num_frames, 1);
    mt_end_params_refined(jj).local_length = -1*ones(num_frames, 1);
end

%% Calculating coarse centers and direction
% from gb_mg_lines struct
coarse_cens = complex(zeros(num_frames, num_mt_lines));
coarse_local_lens = zeros(num_frames, num_mt_lines);
coarse_dirs = zeros(num_frames, num_mt_lines);

coarse_cens = cat(2, gb_mt_end_params.center);
coarse_local_lens = cat(2, gb_mt_end_params.local_length);
coarse_dirs = cat(2, gb_mt_end_params.direction);


%% Calculating fine centers and direction by fitting
% global params_out res exitflg;
params_out = zeros(num_frames, 6, num_mt_lines);
res = zeros(num_frames, num_mt_lines);
exitflag = zeros(num_frames, num_mt_lines);
calc_flag = ~isnan(coarse_cens);

for jj = 1:num_mt_lines
    % mt_line = gb_mt_lines(jj).line;
    % coarse_centers = coarse_cens(:,jj);
    %    param_out = zeros(num_frames, 6);
    % [params_out(:,:,jj),res(:,jj),exitflag(:,jj)] = ...
    %     fit_mt_end(gb_mt_imgs, ...
    %                8, ...
    %                coarse_centers, ...
    %                mt_line, ...
    %                coarse_local_lens(:,jj));
    [params_out(:,:,jj),res(:,jj),exitflag(:,jj)] = ...
        fit_mt_end(gb_mt_imgs, ...
                   gb_params.fit_cropped_r, ...
                   coarse_cens(:,jj), ...
                   gb_mt_lines(jj).line, ...
                   calc_flag(:,jj) ...
                   );

end

for jj = 1:num_mt_lines
    mt_end_params_refined(jj).center = params_out(:,1,jj) + ...
        params_out(:,2,jj)*i;
    mt_end_params_refined(jj).sigma = params_out(:,3,jj);
    mt_end_params_refined(jj).direction = params_out(:,4,jj);
    mt_end_params_refined(jj).amplitude = params_out(:,5,jj);
    mt_end_params_refined(jj).baseline = params_out(:,6,jj);
    mt_end_params_refined(jj).residue = res(:,jj);
    mt_end_params_refined(jj).exitflag = exitflag(:,jj);
    mt_end_params_refined(jj).local_length = coarse_local_lens(:,jj);
end

gb_mt_end_params = mt_end_params_refined;

end
