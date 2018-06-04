function add_line_gui
%% ADD_LINE_GUI is a tool to trace MT head
%% Remember: just to trace the mt head
    
%% global var
% Input: gb_mt_imgs
% Output: gb_mt_lines;
    global gb_mt_imgs;
    global gb_mt_lines; 
    % position: position in original img (int)
    % line: start and end of line in orinal img (complex)
    % kymograph: local x-t ordinate (complex)
    gb_mt_lines = struct('position', {}, ... % x, y, w, h
                         'line', {}, ... % start, end
                         'kymograph', {} ... % x1+i*t1, ...
                         );
% parameters
    global gb_params;
    
    %% local var
    current_line = [0+0i, 0+0i]; % the current line being edited
    [img_h, img_w, num_frames] = ...
        size(gb_mt_imgs);
    img_display = zeros(size(gb_mt_imgs));
    for i = 1:num_frames
        img_display(:,:,i) = gb_mt_imgs(:,:,i)/max(max(gb_mt_imgs(:,:,i)));
    end
    num_lines = 0;        
    
    %% UI
    h_add_line_fig = figure( ...
        'Name', 'Add MT Line', ...
        'Visible','off', ...
        'Position',[1 1 1100 800], ...
        'Units', 'pixels', ...
        'Menubar','none', ...
        'Resize','off');
    set(h_add_line_fig, ...
        'windowbuttondownfcn', '', ...
        'windowbuttonmotionfcn', '', ...
        'windowbuttonupfcn', '');
    
    % Initialization
    % Construct the components.
    % 1. Axes
    h_img_axes = axes( ...
        'Parent', h_add_line_fig, ...
        'Units', 'pixels', ...
        'Position', [50 150 800 600], ...
        'userdata', []);
    set(h_img_axes, 'xtick', [], 'ytick', []); 
    imshow(img_display(:,:,1));
    axis(h_img_axes, 'manual');
    
    h_line_axes = axes( ...
        'Parent', h_add_line_fig, ...
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
        'Parent', h_add_line_fig, ...
        'style','slider', ...
        'position',[50,100,800,20], ...
        'Max', num_frames, ...
        'Min', 1, ...
        'SliderStep',[2 2]./(num_frames-1), ...
        'Callback', @h_img_slider_Callback);
    set(h_img_slider, 'Value', 1);
    addlistener(h_img_slider, ...
                'ContinuousValueChange', ...
                @h_img_slider_Callback);
    % 2.1. Slider Index
    h_img_slider_idx = uicontrol( ...
        'Parent', h_add_line_fig, ...
        'style','text', ...
        'FontSize', 24, ...
        'position',[400,50,100,30], ...
        'Callback', '');
    set(h_img_slider_idx, ...
        'String', ...
        round(get(h_img_slider, 'Value')));
    
    % 3. Toggle Button - DrawLine
    h_drawline_tbutton = uicontrol( ...
        'Parent', h_add_line_fig, ...
        'Style', 'togglebutton', ...
        'String', 'DrawLine', ...
        'position', [920, 620, 80, 50], ...
        'Callback', @h_drawline_tbutton_Callback);

    % 4. Button - AddLine
    h_addline_pbutton = uicontrol( ...
        'Parent', h_add_line_fig, ...
        'Style', 'pushbutton', ...
        'String', 'AddLine', ...
        'Position', [920, 560, 80, 50], ...
        'Callback', @h_addline_pbutton_Callback);

    % 5. Button - Done
    h_done_pbutton = uicontrol( ...
        'Parent', h_add_line_fig, ...
        'Style', 'pushbutton', ...
        'String', 'Done', ...
        'Position', [920, 500, 80, 50], ...
        'Callback', @h_done_pbutton_Callback);
    
    % Display the main window
    set(h_add_line_fig, 'Name', 'Add MT Line');
    movegui(h_add_line_fig, 'center');
    set(h_add_line_fig, 'Visible', 'on');
    uiwait(gcf);
    
    %% Callbacks
    
    function h_img_slider_Callback(src, evt)
        imshow(img_display(:,:,round(get(src, 'Value'))), ...
               'Parent', h_img_axes);
        set(h_img_slider_idx, ...
            'String', ...
            round(get(h_img_slider, 'Value')));
        drawnow;
    end
    
    function h_drawline_tbutton_Callback(src, evt)
        if(get(src,'value'))
            set(h_addline_pbutton, 'Enable', 'off');
            set(h_done_pbutton, 'Enable', 'off');
            set(h_add_line_fig, ...
                'windowbuttondownfcn', @fig_button_down);
        else
            set(h_addline_pbutton, 'Enable', 'on');
            set(h_done_pbutton, 'Enable', 'on');
            set(h_add_line_fig, ...
                'windowbuttondownfcn', '');
        end
    end
    
    function fig_button_down(src, evt)
        seltype = get(src, 'SelectionType');
        if strcmp(seltype, 'normal')
            % TODO: to check if the mouse click happens on the axes region
            axes_dim = get(h_img_axes, 'Position');
            p_fig = get(h_add_line_fig, 'CurrentPoint');
            p_axes = get(h_img_axes, 'CurrentPoint');
            p = p_axes(1,1) + p_axes(1,2)*sqrt(-1); % current point
            h_shapes = get(h_line_axes, 'userdata'); %
                                                     % visualization
                                                     % of lines
            % create new line handle
            if(isempty(h_shapes.cl))
                h_shapes.cl(1) = line('XData',real(p),'YData',imag(p), ...
                                      'Marker','p','color', ...
                                      'b');
                h_shapes.cl(2) = line('XData',real(p),'YData',imag(p), ...
                                      'Marker','o','color', ...
                                      'r');
                current_line(1) = p;
                current_line(2) = p;
            % modify existing line handle
            else
                d1 = abs(current_line(1)-p);
                d2 = abs(current_line(2)-p);
                % near the existing point?
                if(d1<20 || d2<20)
                    if(d1 < d2)
                        current_line(1) = p;
                    else
                        current_line(2) = p;
                    end
                else
                    current_line(1) = p;
                    current_line(2) = p;
                end
                xdat = [real(current_line(1)), real(current_line(2))];
                ydat = [imag(current_line(1)), imag(current_line(2))];
                set(h_shapes.cl(1), 'XData', xdat);
                set(h_shapes.cl(1), 'YData', ydat);
                set(h_shapes.cl(2), 'XData', [real(current_line(1))]);
                set(h_shapes.cl(2), 'YData', [imag(current_line(1))]);
                drawnow;
            end
            set(h_line_axes, 'userdata', h_shapes);
            set(h_add_line_fig, 'windowbuttonmotionfcn', @fig_button_motion, ...
                              'windowbuttonupfcn', @fig_button_up);
        end
    end
    
    function fig_button_motion(src, evt)
        p_axes = get(h_img_axes, 'CurrentPoint');
        p = p_axes(1,1) + p_axes(1,2)*sqrt(-1);
        d1 = abs(current_line(1)-p);
        d2 = abs(current_line(2)-p);
        if(d1 < d2)
            current_line(1) = p;
        else
            current_line(2) = p;
        end
        xdat = [real(current_line(1)), real(current_line(2))];
        ydat = [imag(current_line(1)), imag(current_line(2))];
        h_shapes = get(h_line_axes, 'userdata');
        set(h_shapes.cl(1), 'XData', xdat);
        set(h_shapes.cl(1), 'YData', ydat);
        set(h_shapes.cl(2), 'XData', [real(current_line(1))]);
        set(h_shapes.cl(2), 'YData', [imag(current_line(1))]);
        drawnow;
    end

    function fig_button_up(src, evt)
        set(h_add_line_fig, 'windowbuttonmotionfcn', '');
        set(h_add_line_fig, 'windowbuttonupfcn', '');
    end

    function h_addline_pbutton_Callback(src, evt)
        p1 = current_line(1);
        p2 = current_line(2);
        [pp1, pp2] = extract_roi_from_2p(p1, ...
                                         p2, ...
                                         gb_params.border_px);
        x1 = real(pp1);
        x2 = real(pp2);
        y1 = imag(pp1);
        y2 = imag(pp2);
        if(x1<1 || y1<1 || x2>img_w || y2>img_h)
            warndlg('the line is out of range');
            return;
        end
        num_lines = num_lines + 1;
        gb_mt_lines(num_lines).position = [x1, y1, x2-x1+1, y2-y1+1];
        gb_mt_lines(num_lines).line = current_line;
        xdat = [real(p1), real(p2)];
        ydat = [imag(p1), imag(p2)];
        h_shapes = get(h_line_axes, 'userdata');
        h_shapes.lines(num_lines) = line('XData',xdat,'YData',ydat, ...
                                            'Marker','p','color', ...
                                            'w');
        h_shapes.rects(num_lines) = rectangle('Position', ...
                                                 [x1, y1, x2-x1, y2-y1], ...
                                                 'EdgeColor', 'm');
    end

    function h_done_pbutton_Callback(src, evt)
        close(h_add_line_fig);
    end
    
end
