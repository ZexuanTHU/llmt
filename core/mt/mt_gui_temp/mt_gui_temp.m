function mt_gui_temp(gb_red_ori, gb_green_ori)
%% MT_GUI_V1 facilitates the analysis of microtubule
% img_filename: filename of the input image file
% Requirement: the channel number of the input image MUST be 2
% example: 
% the first channel, red, EB1
% the second channel, green, MT

    % image preprocessing
    % gb_ prefix
        
    % image
    % [gb_red_ori, gb_green_ori] = read_two_channel_image(img_filename);
    [gb_img_height, gb_img_width, gb_num_frames] = size(gb_red_ori);
    gb_red_ori = double(gb_red_ori);
    gb_green_ori = double(gb_green_ori);
    gb_red_display = zeros(gb_img_height, gb_img_width, gb_num_frames);
    gb_green_display = zeros(gb_img_height, gb_img_width, gb_num_frames);
    for i = 1:gb_num_frames
        gb_red_display(:,:,i) = gb_red_ori(:,:,i)/max(max(gb_red_ori(:,:,i)));
        gb_green_display(:,:,i) = gb_green_ori(:,:,i)/max(max(gb_green_ori(:,:,i)));
    end
    gb_img_display = zeros(gb_img_height, gb_img_width, 3);
    gb_img_display(:,:,1) = gb_red_display(:,:,1);
    gb_img_display(:,:,2) = gb_green_display(:,:,1);

    % interactive 
    gb_lines = [0+0i, 0+0i]; % complex number representation of
                             % start and end
    gb_lines2 = [0+0i, 0+0i]; % enlarged gb_lines
    gb_current_line = [0+0i, 0+0i]; % the current line being edited
    gb_num_lines = 0;
    
    % cropping
    gb_mt_width = 0.0; % sigma
    gb_border_px = 10; % expanded region pixel
    gb_crop_radius = 6; % used to crop a region for fitting
    gb_line_px = 2; % the radius of line profile (the total width =
                    % 2*2+1 = 5)
    gb_red_cropped = [];
    gb_green_cropped = [];

    gb_coarse_endpoints = cell(1,1); % in original image coordinate
                                     % system
    
    % fitting
    gb_fit_params = cell(1,1); % gb_fit_params{1} = [x0, y0, sigma,
                               % theta, H, b]
    
    % profiling
    gb_half_len = gb_border_px;
    gb_np = 4*gb_border_px;
    gb_green_head_profiles = cell(1,1);
    gb_red_head_profiles = cell(1,1);

    %% UI

    % Create and then hide the GUI as it is being constructed.
    % [left bottom width height]
    h_main_fig = figure( ...
        'Name', 'MT simple tool', ...
        'Visible','off', ...
        'Position',[1 1 1400 800], ...
        'Units', 'pixels', ...
        'Menubar','none', ...
        'Resize','off');
    set(h_main_fig, ...
        'windowbuttondownfcn', '', ...
        'windowbuttonmotionfcn', '', ...
        'windowbuttonupfcn', '');
    
    % Initialization
    % Construct the components.
    % 1. Axes
    h_img_axes = axes( ...
        'Parent', h_main_fig, ...
        'Units', 'pixels', ...
        'Position', [50 150 800 600], ...
        'userdata', []);
    set(h_img_axes, 'xtick', [], 'ytick', []); 
    imshow(gb_img_display);
    axis(h_img_axes, 'manual');
    
    h_line_axes = axes( ...
        'Parent', h_main_fig, ...
        'Units', 'pixels', ...
        'Position', [50 150 800 600], ...
        'Color', 'none', ...
        'XLim', get(h_img_axes, 'XLim'), ...
        'YLim', get(h_img_axes, 'YLim'), ...
        'ZLim', get(h_img_axes, 'ZLim'), ...
        'XDir', get(h_img_axes, 'XDir'), ...
        'YDir', get(h_img_axes, 'YDir'), ...
        'DataAspectRatio', get(h_img_axes, 'DataAspectRatio'), ...
        'DataAspectRatioMode', get(h_img_axes, 'DataAspectRatioMode'), ...
        'userdata', struct('lines',[],'rects',[],'cl',[]));
    % lines: the MTs
    % rects: the expanded MT ROI
    % cl: current line and current start point
    set(h_line_axes, 'xtick', [], 'ytick', []); 
    axis(h_line_axes, 'manual');

    
    % 2. Slider
    h_img_slider = uicontrol( ...
        'Parent', h_main_fig, ...
        'style','slider', ...
        'position',[50,100,800,20], ...
        'Max', gb_num_frames, ...
        'Min', 1, ...
        'SliderStep',[2 2]./(gb_num_frames-1), ...
        'Callback', @h_img_slider_Callback);
    set(h_img_slider, 'Value', 1);
    addlistener(h_img_slider, ...
                'ContinuousValueChange', ...
                @h_img_slider_Callback);
    
    % 3. Toggle Button - DrawLine
    h_drawline_tbutton = uicontrol( ...
        'Parent', h_main_fig, ...
        'Style', 'togglebutton', ...
        'String', 'DrawLine', ...
        'position', [920, 620, 80, 50], ...
        'Callback', @h_drawline_tbutton_Callback);

    % 4. Button - AddLine
    h_addline_pbutton = uicontrol( ...
        'Parent', h_main_fig, ...
        'Style', 'pushbutton', ...
        'String', 'AddLine', ...
        'Position', [920, 560, 80, 50], ...
        'Callback', @h_addline_pbutton_Callback);

    % 5. Button - PickPoint
    h_pickpoint_pbutton = uicontrol( ...
        'Parent', h_main_fig, ...
        'Style', 'pushbutton', ...
        'String', 'PickPoint', ...
        'Position', [920, 500, 80, 50], ...
        'Callback', @h_pickpoint_pbutton_Callback);
    
    % 6. Button - Fit
    h_fit_pbutton = uicontrol( ...
        'Parent', h_main_fig, ...
        'Style', 'pushbutton', ...
        'String', 'Fit', ...
        'Position', [920, 440, 80, 50], ...
        'Callback', @h_fit_pbutton_Callback);

    % 7. Button - ShowHead
    h_showhead_pbutton = uicontrol( ...
        'Parent', h_main_fig, ...
        'Style', 'pushbutton', ...
        'String', 'ShowHead', ...
        'Position', [920, 380, 80, 50], ...
        'Callback', @h_showhead_pbutton_Callback);

    % Display the main window
    set(h_main_fig, 'Name', 'MT end profiling v1');
    movegui(h_main_fig, 'center');
    set(h_main_fig, 'Visible', 'on');

    
    %% Callbacks
    
    function h_img_slider_Callback(src, evt)
        v = round(get(src, 'Value'));
        gb_img_display(:,:,1) = gb_red_display(:,:,v);
        gb_img_display(:,:,2) = gb_green_display(:,:,v);
        imshow(gb_img_display, 'Parent', h_img_axes);
        drawnow;
    end
    
    function h_drawline_tbutton_Callback(src, evt)
        if(get(src,'value'))
            set(h_fit_pbutton, 'Enable', 'off');
            set(h_addline_pbutton, 'Enable', 'off');
            set(h_pickpoint_pbutton, 'Enable', 'off');
            set(h_main_fig, ...
                'windowbuttondownfcn', @fig_button_down);
        else
            set(h_fit_pbutton, 'Enable', 'on');
            set(h_addline_pbutton, 'Enable', 'on');
            set(h_pickpoint_pbutton, 'Enable', 'on');
            set(h_main_fig, ...
                'windowbuttondownfcn', '');
        end
    end
    
    function fig_button_down(src, evt)
        seltype = get(src, 'SelectionType');
        if strcmp(seltype, 'normal')
            % TODO: to check if the mouse click happens on the axes region
            axes_dim = get(h_img_axes, 'Position');
            p_fig = get(h_main_fig, 'CurrentPoint');
            p_axes = get(h_img_axes, 'CurrentPoint');
            p = p_axes(1,1) + p_axes(1,2)*sqrt(-1);
            h_shapes = get(h_line_axes, 'userdata');
            if(isempty(h_shapes.cl))
                h_shapes.cl(1) = line('XData',real(p),'YData',imag(p), ...
                                             'Marker','p','color', ...
                                             'b');
                h_shapes.cl(2) = line('XData',real(p),'YData',imag(p), ...
                                             'Marker','o','color', ...
                                             'r');
                gb_current_line(1) = p;
                gb_current_line(2) = p;
            else
                d1 = abs(gb_current_line(1)-p);
                d2 = abs(gb_current_line(2)-p);
                % near the existing point?
                if(d1<20 || d2<20)
                    if(d1 < d2)
                        gb_current_line(1) = p;
                    else
                        gb_current_line(2) = p;
                    end
                else
                    gb_current_line(1) = p;
                    gb_current_line(2) = p;
                end
                xdat = [real(gb_current_line(1)), real(gb_current_line(2))];
                ydat = [imag(gb_current_line(1)), imag(gb_current_line(2))];
                set(h_shapes.cl(1), 'XData', xdat);
                set(h_shapes.cl(1), 'YData', ydat);
                set(h_shapes.cl(2), 'XData', [real(gb_current_line(1))]);
                set(h_shapes.cl(2), 'YData', [imag(gb_current_line(1))]);
                drawnow;
            end
            set(h_line_axes, 'userdata', h_shapes);
            set(h_main_fig, 'windowbuttonmotionfcn', @fig_button_motion, ...
                            'windowbuttonupfcn', @fig_button_up);
        end
    end
    
    function fig_button_motion(src, evt)
        p_axes = get(h_img_axes, 'CurrentPoint');
        p = p_axes(1,1) + p_axes(1,2)*sqrt(-1);
        d1 = abs(gb_current_line(1)-p);
        d2 = abs(gb_current_line(2)-p);
        if(d1 < d2)
            gb_current_line(1) = p;
        else
            gb_current_line(2) = p;
        end
        xdat = [real(gb_current_line(1)), real(gb_current_line(2))];
        ydat = [imag(gb_current_line(1)), imag(gb_current_line(2))];
        h_shapes = get(h_line_axes, 'userdata');
        set(h_shapes.cl(1), 'XData', xdat);
        set(h_shapes.cl(1), 'YData', ydat);
        set(h_shapes.cl(2), 'XData', [real(gb_current_line(1))]);
        set(h_shapes.cl(2), 'YData', [imag(gb_current_line(1))]);
        drawnow;
    end

    function fig_button_up(src, evt)
        set(h_main_fig, 'windowbuttonmotionfcn', '');
        set(h_main_fig, 'windowbuttonupfcn', '');
    end

    function h_addline_pbutton_Callback(src, evt)
        p1 = gb_current_line(1);
        p2 = gb_current_line(2);
        [pp1, pp2] = extract_roi_from_2p(p1, p2, gb_border_px);
        x1 = real(pp1);
        x2 = real(pp2);
        y1 = imag(pp1);
        y2 = imag(pp2);
        if(x1<1 || y1<1 || x2>gb_img_width || y2>gb_img_height)
            warndlg('the line is out of range');
            return;
        end
        gb_num_lines = gb_num_lines + 1;
        gb_lines(gb_num_lines,1:2) = gb_current_line;
        xdat = [real(p1), real(p2)];
        ydat = [imag(p1), imag(p2)];
        h_shapes = get(h_line_axes, 'userdata');
        h_shapes.lines(gb_num_lines) = line('XData',xdat,'YData',ydat, ...
                              'Marker','p','color', ...
                              'w');
        gb_lines2(gb_num_lines,1) = pp1;
        gb_lines2(gb_num_lines,2) = pp2;
        h_shapes.rects(gb_num_lines) = rectangle('Position', ...
                                                 [x1, y1, x2-x1, y2-y1], ...
                                                 'EdgeColor', 'm');
        gb_red_cropped = gb_red_ori(y1:y2, x1:x2, :);
        gb_green_cropped = gb_green_ori(y1:y2, x1:x2, :);
    end

    function h_pickpoint_pbutton_Callback(src, evt)
        % to interactively pick endpoints
        endpoints = get_points_from_frames(gb_green_cropped);
        endpoints = round(endpoints);
        % to obtain global endpoint coordinates
        gb_coarse_endpoints{gb_num_lines} = endpoints + ...
            gb_lines2(gb_num_lines,1) - (1+1i);
    end
    
    function h_fit_pbutton_Callback(src, evt)
        set(h_drawline_tbutton, 'Enable', 'off');
        set(h_img_slider, 'Enable', 'off');
        set(h_showhead_pbutton, 'Enable', 'off');
        gb_fit_params{gb_num_lines} = fit_2d_filament_end(gb_green_ori, ...
                                                          gb_crop_radius, ...
                                                          gb_coarse_endpoints{gb_num_lines}, ...
                                                          gb_lines(gb_num_lines,:));
        set(h_drawline_tbutton, 'Enable', 'on');
        set(h_img_slider, 'Enable', 'on');
        set(h_showhead_pbutton, 'Enable', 'on');
    end

    function h_showhead_pbutton_Callback(src, evt)
        gb_red_head_profiles{gb_num_lines} = kymography_head(gb_red_ori, ...
                                                          gb_fit_params{gb_num_lines}, ...
                                                          gb_half_len, ...
                                                          gb_np);
        gb_green_head_profiles{gb_num_lines} = kymography_head(gb_green_ori, ...
                                                          gb_fit_params{gb_num_lines}, ...
                                                          gb_half_len, ...
                                                          gb_np);
        tmp_red_profile_img = gb_red_head_profiles{gb_num_lines};
        tmp_green_profile_img = gb_green_head_profiles{gb_num_lines};
        tmp_blue_profile_img = zeros(size(tmp_red_profile_img));
        % mean profile
        tmp_red_mean_profile = mean(tmp_red_profile_img, 1);
        tmp_green_mean_profile= mean(tmp_green_profile_img, 1);
        tmp_red_std_profile = std(tmp_red_profile_img, 0, 1);
        tmp_green_std_profile= std(tmp_green_profile_img, 0, 1);
        figure('Name', 'line profile');
        tmp_x = 1:length(tmp_red_mean_profile);
        [hAx, hl1, hl2] = plotyy(tmp_x, tmp_red_mean_profile, ...
                                 tmp_x, tmp_green_mean_profile, ...
                                 @(x,y) errorbar(x,y,tmp_red_std_profile), ...
            @(x,y) errorbar(x,y,tmp_green_std_profile));
        ylabel(hAx(1),'red');
        ylabel(hAx(2),'green');
        set(hl1, 'Color', 'r');
        set(hl2, 'Color', 'g');
        % profile image, e.g., kymography
        tmp_red_profile_img = tmp_red_profile_img/ ...
            max(tmp_red_profile_img(:));
        tmp_green_profile_img = tmp_green_profile_img/ ...
            max(tmp_green_profile_img(:));
        tmp_profile_img = cat(3, ...
                              tmp_red_profile_img, ...
                              tmp_green_profile_img, ...
                              tmp_blue_profile_img);
        figure('Name','head kymograph');
        imshow(tmp_profile_img);
    end
    
    %% helper functions
    
    function v = helper_in_region(axes_dim, p)
        x = p(1);
        y = p(2);
        if(x>=axes_dim(1) && x<=(axes_dim(1)+axes_dim(3)) && ...
           y>=axes_dim(2) && y<=(axes_dim(2)+axes_dim(4)))
            v = 1;
        else
            v = 0;
        end
    end
end
