function calc_tform_gui
%% CALC_TFORM_GUI calculates the transform matrix 
% from a series of bead images.
    
%% Global var
% Input: (None)
% Output:
    global gb_bead_file_list gb_bead_file_num gb_tform;
    gb_bead_file_list = {};
    gb_bead_file_num = 0;

    %% GUI
    
    h_calc_tform_fig = figure( ...
        'Name', 'Load Images', ...
        'NumberTitle', 'off', ...
        'Visible','off', ...
        'Position',[1 1 420 200], ...
        'Units', 'pixels', ...
        'Menubar','none', ...
        'Resize','off');
    set(h_calc_tform_fig, ...
        'windowbuttondownfcn', '', ...
        'windowbuttonmotionfcn', '', ...
        'windowbuttonupfcn', '');

    % 1. add beads
    h_add_beads_pbutt = uicontrol( ...
        'Parent', h_calc_tform_fig, ...
        'Style', 'pushbutton', ...
        'String', 'Add Bead File', ...
        'Position', [10, 120, 150, 40], ...
        'Callback', @h_add_beads_pbutt_Callback);
    h_add_beads_edit = uicontrol( ...
        'Parent', h_calc_tform_fig, ...
        'Style', 'edit', ...
        'String', '', ...
        'Position', [170, 80, 240, 110], ...
        'Max',10, ...
        'Enable', 'on');

    % 3. ok push button
    h_calc_pbutt = uicontrol( ...
        'Parent', h_calc_tform_fig, ...
        'Style', 'pushbutton', ...
        'String', 'Calculate', ...
        'Position', [165, 20, 90, 40], ...
        'Callback', @h_calc_pbutt_Callback);

    % Display the main window
    movegui(h_calc_tform_fig, 'center');
    set(h_calc_tform_fig, 'Visible', 'on');
    uiwait(gcf);

    %% Callbacks

    function h_add_beads_pbutt_Callback(src,evt)
        [filenames,pathname] = uigetfile( ...
            {'*.tif';'*.tiff';'*.*'}, ...
            'Choose Bead Files', ...
            'MultiSelect', 'on');
        if numel(filenames) == 0
            return;
        end
        if ~iscell(filenames)
            gb_bead_file_num = gb_bead_file_num + 1;
            complete_filename = strcat(pathname, filenames);
            gb_bead_file_list{gb_bead_file_num} = complete_filename;
        else
            num_files = numel(filenames);
            for i=1:num_files
                gb_bead_file_num = gb_bead_file_num + 1;
                complete_filename = strcat(pathname, filenames{i});
                gb_bead_file_list{gb_bead_file_num} = complete_filename;
            end
        end
        update_text(h_add_beads_edit, gb_bead_file_list);
    end

    function h_calc_pbutt_Callback(src,evt)
        gb_tform = calc_tform(gb_bead_file_list);
        close(h_calc_tform_fig);
    end

    %% helper function
    function update_text(h_text, str)
        if ~iscell(str)
            set(h_text, 'String', str);
        else
            n_str = numel(str);
            all_str = '';
            for i = 1:n_str
                all_str = strcat(all_str, str{i}, sprintf('\n'));
            end
            % all_str = sprintf(all_str);
            set(h_text, 'String', all_str);
        end
    end

end