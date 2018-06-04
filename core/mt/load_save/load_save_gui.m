function load_save_gui
%% LOAD_IMAGES_GUI loads MT and MAP images
% The file to be loaded is required to be saved by this program
% too; otherwise, the "global" property of vars would be wrong.
    
%% Global var
% Input (All global vars)
% Output (All global vars)
    mat_file = '';
    
%% GUI
    h_load_save_fig = figure( ...
        'Name', 'Load Images', ...
        'NumberTitle', 'off', ...
        'Visible','off', ...
        'Position',[1 1 380 140], ...
        'Units', 'pixels', ...
        'Menubar','none', ...
        'Resize','off');
    set(h_load_save_fig, ...
        'windowbuttondownfcn', '', ...
        'windowbuttonmotionfcn', '', ...
        'windowbuttonupfcn', '');

    % text and edit
    % 1. matlab mat file
    h_mat_file_pbutt = uicontrol( ...
        'Parent', h_load_save_fig, ...
        'Style', 'pushbutton', ...
        'String', 'mat file', ...
        'FontSize', 12, ...
        'Position', [20, 80, 80, 40], ...
        'Callback', @h_mat_file_pbutt_Callback);
    h_mat_file_edit = uicontrol( ...
        'Parent', h_load_save_fig, ...
        'Style', 'edit', ...
        'String', '', ...
        'FontSize', 12, ...
        'Position', [120, 80, 240, 40], ...
        'Enable', 'on');

    % 2. load push button
    h_load_pbutt = uicontrol( ...
        'Parent', h_load_save_fig, ...
        'Style', 'pushbutton', ...
        'String', 'Load', ...
        'Position', [55, 20, 80, 40], ...
        'Callback', @h_load_pbutt_Callback);

    % 3. save push button
    h_save_pbutt = uicontrol( ...
        'Parent', h_load_save_fig, ...
        'Style', 'pushbutton', ...
        'String', 'Save', ...
        'Position', [245, 20, 80, 40], ...
        'Callback', @h_save_pbutt_Callback);

    % Display the main window
    movegui(h_load_save_fig, 'center');
    set(h_load_save_fig, 'Visible', 'on');
    uiwait(gcf);

    %% Callbacks

    function h_mat_file_pbutt_Callback(src,evt)
        [filename,pathname] = uigetfile( ...
            {'*.mat'}, ...
            'Choose mat File');
        if filename == 0
            return;
        end
        complete_filename = strcat(pathname, filename);
        mat_file = complete_filename;
        update_text(h_mat_file_edit, mat_file);
    end

    function h_load_pbutt_Callback(src,evt)
        if isempty(mat_file)
            msgbox('Invalid mat file');
            return;
        end
        % MATLAB will take care of the "global" property of a
        % variable :)
        names = whos('-file', mat_file);
        num_gb_vars = numel(names);
        if num_gb_vars > 0
            for i = 1 : num_gb_vars
                name = names(i).name;
                eval(sprintf('global %s', name));
                load(mat_file, name);
            end
        end
        close(h_load_save_fig);
    end
    
    function h_save_pbutt_Callback(src,evt)
    % the file doesn't exist
        if exist(mat_file) ~= 2
            mat_file = strcat(pwd, '/', date, '_result.mat');
        end
        % MATLAB will take care of the "global" property of a
        % variable :)
        names = whos('global');
        num_gb_vars = numel(names);
        if num_gb_vars > 0
            name = names(1).name;
            eval(sprintf('global %s', name));
            save(mat_file, name);
            for i = 2 : num_gb_vars
                name = names(i).name;
                eval(sprintf('global %s', name));
                save(mat_file, name, '-append');
            end
        end
        close(h_load_save_fig);
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
