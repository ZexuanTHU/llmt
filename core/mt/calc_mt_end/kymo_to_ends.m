function [ends, local_length] = kymo_to_ends(kymo, ps, pe, n, num_frames)
%% KYMOGRAPH_TO_ENDS calculates the ends of lines in every frame
% from kymograph

%% input
% kymo: kymograph lines, complex vector
% ps: original start point, complex number
% pe: original end point, complex number
% n: number of points in line profile
% num_frames: number of frames

%% output
% ends: the ends of lines in each frame, complex vector
    
    % ends in global coordinate
    ends = complex(zeros(num_frames, 1)); 
    % ends in line coordinate, unit corrected
    ends_local = zeros(num_frames, 1);
    local_length = zeros(num_frames, 1);
    num_points = numel(kymo);

    slopes = zeros((num_points-1), 1);
    for jj = 1:(num_points-1)
        slopes(jj) = tan(angle(kymo(jj+1)-kymo(jj)));
    end

    idx = 1; % slope of line segment idx being used
    p1x = real(kymo(idx));
    p1y = imag(kymo(idx));
    p2x = real(kymo(idx+1));
    p2y = imag(kymo(idx+1));
    for jj = 1:num_frames
        if(jj<p2y)
            % use slope: idx:idx+1
            ends_local(jj) = (jj-p1y)/slopes(idx)+p1x;
        else
            % the last segment is reached
            if(idx==(num_points-1))
                break;
            end
            % move to next interval
            while(jj>=imag(kymo(idx+1)) ...
                  && idx<(num_points-1))
                idx = idx + 1;
            end
            p1x = real(kymo(idx));
            p1y = imag(kymo(idx));
            p2x = real(kymo(idx+1));
            p2y = imag(kymo(idx+1));
            ends_local(jj) = (jj-p1y)/slopes(idx)+p1x;
        end
    end
    
    if(jj~=num_frames)
        p1x = real(kymo(num_points-1));
        p1y = imag(kymo(num_points-1));
        p2x = real(kymo(num_points));
        p2y = imag(kymo(num_points));
        while(jj<=num_frames)
            ends_local(jj) = (jj-p1y)/slopes(num_points-1)+p1x;
            jj = jj+1;
        end
    end

    % convert the end point coordinate (local to global)
    for jj = 1:num_frames
        scaling = (ends_local(jj)-1)/(n-1);
        ends(jj) = ps + scaling*(pe-ps);
        local_length(jj) = scaling*abs(pe-ps);
    end
end