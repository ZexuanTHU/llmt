function fitting_tool_gui(sig)
%% FITTING_TOOL_GUI is a small tool for fitting line segments by
% mouse clicking.

    N = numel(sig);
    sig = reshape(sig, [N,1]);
    sig_max = max(sig);
    sig_min = min(sig);
    t = [1:N]'; % time

    time_interval = 0.0;
    nm_pixel = 0.0;
    enabled_extension = false;

    tdata = zeros(0, 8); % #, dt, 1/dt, k, t1, t2, sig1, sig2
                      
    idx = 0;
    t12 = [t(1), t(end)];
    t0 = (t12(1)+t12(2))/2;
    current_vert = 1; % indicator for vertical line movement

    %% UI
    h_fitting_tool_fig = figure( ...
        'Name', 'Fitting Tool', ...
        'Visible','off', ...
        'Position',[1 1 1400 800], ...
        'Units', 'pixels', ...
        'Menubar','none', ...
        'Resize','off');
    set(h_fitting_tool_fig, ...
        'windowbuttondownfcn', '', ...
        'windowbuttonmotionfcn', '', ...
        'windowbuttonupfcn', '');

    % Initialization
    % Construct the components.
    % 0. Axes Title
    h_title_text = uicontrol( ...
        'Parent', h_fitting_tool_fig, ...
        'Style', 'text', ...
        'String', 'Plot', ...
        'FontSize', 24, ...
        'Position', [325, 758, 200, 34]);

    % 1. Axes
    h_line_axes = axes( ...
        'Parent', h_fitting_tool_fig, ...
        'Units', 'pixels', ...
        'Position', [50 150 800 600] ...
        );
    sig_line = line('XData', t, ...
                    'YData', sig, ...
                    'Parent', h_line_axes, ...
                    'Color', 'r');
    verts = cell(2,1);
    verts{1} = line('XData', [t12(1), t12(1)], ...
                    'YData', [sig_min, sig_max], ...
                    'Parent', h_line_axes, ...
                    'Color', 'b', ...
                    'LineStyle', '--');
    verts{2} = line('XData', [t12(2), t12(2)], ...
                    'YData', [sig_min, sig_max], ...
                    'Parent', h_line_axes, ...
                    'Color', 'b', ...
                    'LineStyle', '--');
    fitted = cell(0,0);
    set(h_line_axes, 'xtick', [], 'ytick', []); 
    axis(h_line_axes, [t(1)-0.04*N, ...
                       t(N)+0.04*N, ...
                       sig_min-0.04*(sig_max-sig_min), ...
                       sig_max+0.04*(sig_max-sig_min)]);

    % 2. Unit
    h_x_unit_text = uicontrol( ...
        'Parent', h_fitting_tool_fig, ...
        'Style', 'text', ...
        'String', 'time interval(s)', ...
        'FontSize', 18, ...
        'Position', [100, 80, 190, 35]);
    h_x_unit_edit = uicontrol( ...
        'Parent', h_fitting_tool_fig, ...
        'Style', 'edit', ...
        'String', '', ...
        'FontSize', 18, ...
        'Position', [300, 80, 90, 35], ...
        'Enable', 'on');

    h_y_unit_text = uicontrol( ...
        'Parent', h_fitting_tool_fig, ...
        'Style', 'text', ...
        'String', 'nm/pixel', ...
        'FontSize', 18, ...
        'Position', [450, 80, 190, 35]);
    h_y_unit_edit = uicontrol( ...
        'Parent', h_fitting_tool_fig, ...
        'Style', 'edit', ...
        'String', '', ...
        'FontSize', 18, ...
        'Position', [650, 80, 90, 35], ...
        'Enable', 'on');

    % 3. Button
    h_set_pbutt = uicontrol( ...
        'Parent', h_fitting_tool_fig, ...
        'Style', 'pushbutton', ...
        'String', 'Set Unit', ...
        'FontSize', 14, ...
        'Position', [120, 25, 100, 35], ...
        'Callback', @h_set_pbutt_Callback);
    h_draw_tbutt = uicontrol( ...
        'Parent', h_fitting_tool_fig, ...
        'Style', 'togglebutton', ...
        'String', 'Draw', ...
        'FontSize', 14, ...
        'Position', [250, 25, 100, 35], ...
        'Enable', 'off', ...
        'Callback', @h_draw_tbutt_Callback);
    h_calc_pbutt = uicontrol( ...
        'Parent', h_fitting_tool_fig, ...
        'Style', 'pushbutton', ...
        'String', 'Calc', ...
        'FontSize', 14, ...
        'Position', [450, 25, 100, 35], ...
        'Enable', 'off', ...
        'Callback', @h_calc_pbutt_Callback);

    % 4. CheckBox
    h_extend_cb = uicontrol( ...
        'Parent', h_fitting_tool_fig, ...
        'Style', 'checkbox', ...
        'String', 'Enable Extension', ...
        'FontSize', 14, ...
        'Position', [560, 25, 180, 35], ...
        'Callback', @h_extend_cb_Callback);

    % 5. Fitting Title
    h_fittint_text = uicontrol( ...
        'Parent', h_fitting_tool_fig, ...
        'Style', 'text', ...
        'String', 'Fitting Result', ...
        'FontSize', 24, ...
        'Position', [1125-120, 758, 240, 34]);

    % 6. Table
    h_table = uitable( ...
        'Parent', h_fitting_tool_fig, ...
        'Position', [875, 100, 500, 650], ...
        'ColumnName', {'#', ...
                       'dt', '1/dt', ...
                       'k', ...
                       't1', 't2', ...
                       'sig1', 'sig2' ...
                      } ...
        );

    % 7. Table Button
    h_export_pbutt = uicontrol( ...
        'Parent', h_fitting_tool_fig, ...
        'Style', 'pushbutton', ...
        'String', 'Export', ...
        'FontSize', 14, ...
        'Position', [1100, 25, 100, 35], ...
        'Callback', @h_export_pbutt_Callback);

    % Display the main window
    movegui(h_fitting_tool_fig, 'center');
    set(h_fitting_tool_fig, 'Visible', 'on');
    %     uiwait(gcf);


    %% Callbacks
    function h_set_pbutt_Callback(src,evt)
        val = get(h_y_unit_edit, 'String');
        if isempty(val)
            msgbox('Please Input nm/pixel Value');
            return;
        end
        nm_pixel = str2num(val);
        val = get(h_x_unit_edit, 'String');
        if isempty(val)
            msgbox('Please Input time interval Value');
            return;
        end
        time_interval = str2num(val);
        set(h_draw_tbutt, 'Enable', 'on');
        set(h_calc_pbutt, 'Enable', 'on');
    end

    function h_draw_tbutt_Callback(src,evt)
        if(get(src,'value'))
            set(h_fitting_tool_fig, ...
                'windowbuttondownfcn', @fig_button_down);
        else
            set(h_fitting_tool_fig, ...
                'windowbuttondownfcn', '');
        end
    end

    function fig_button_down(src, evt)
        seltype = get(src, 'SelectionType');
        if strcmp(seltype, 'normal')
            p_axes = get(h_line_axes, 'CurrentPoint');
            p = p_axes(1,1) + p_axes(1,2)*sqrt(-1); % current point
            t0 = p_axes(1,1);
            if abs(t0-t12(1))<abs(t0-t12(2))
                t12(1) = t0;
                current_vert = 1;
            else
                t12(2) = t0;
                current_vert = 2;
            end
            set(verts{current_vert}, ...
                'XData', [t12(current_vert), ...
                          t12(current_vert)...
                         ]...
                );
            drawnow;
            set(h_fitting_tool_fig, ...
                'windowbuttonmotionfcn', @fig_button_motion, ...
                'windowbuttonupfcn', @fig_button_up);

        end
    end
    
    function fig_button_motion(src, evt)
        p_axes = get(h_line_axes, 'CurrentPoint');
        p = p_axes(1,1) + p_axes(1,2)*sqrt(-1);
        t0 = p_axes(1,1);
        t12(current_vert) = t0;
        set(verts{current_vert}, ...
            'XData', [t12(current_vert), ...
                      t12(current_vert)...
                     ]...
            );
        drawnow;
    end

    function fig_button_up(src, evt)
        set(h_fitting_tool_fig, 'windowbuttonmotionfcn', '');
        set(h_fitting_tool_fig, 'windowbuttonupfcn', '');
    end


    function h_calc_pbutt_Callback(src,evt)
        t1 = round(min(t12));
        t2 = round(max(t12));
        tt = t(t1:t2);
        ss = sig(t1:t2);
        A = linear_fit(tt,ss);
        sig1 = A(1)*t1+A(2);
        sig2 = A(1)*t2+A(2);
        idx = idx+1;
        fitted{idx} = line('Parent', h_line_axes, ...
                           'XData', [t1, t2], ...
                           'YData', [sig1, sig2], ...
                           'Color', 'k', ...
                           'LineStyle', '-', ...
                           'Marker', 'p');
        tdata(idx,:) = [idx, ...
                        (t2-t1)*time_interval, ...
                        1/((t2-t1)*time_interval), ...
                        A(1)*nm_pixel/time_interval, ...
                       t1, t2, sig1, sig2];
        set(h_table, 'Data', tdata);
        drawnow;
    end

    function h_export_pbutt_Callback(src,evt)
        assignin('base', 'tdata', tdata);
    end
    
    function h_extend_cb_Callback(src,evt)
        enabled_extension = logical(get(h_extend_cb, 'Value'));
    end

end