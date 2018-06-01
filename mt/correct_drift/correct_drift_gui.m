function correct_drift_gui
%% CORRECT_DRIFT_GUI is the gui for correcting drift with
% transformation matrix calculated by ImageJ/MultiStackReg plugin.
% The program is used for 2D images

%% global var
global gb_imagej_tf_file;
global gb_mt_imgs gb_map_imgs;
% Input:
% Output:

%% GUI
    h_correct_drift_fig = figure( ...
        'Name', 'Correct Drift', ...
        'NumberTitle', 'off', ...
        'Visible','off', ...
        'Position',[1 1 300 200], ...
        'Units', 'pixels', ...
        'Menubar','none', ...
        'Resize','off');
    set(h_correct_drift_fig, ...
        'windowbuttondownfcn', '', ...
        'windowbuttonmotionfcn', '', ...
        'windowbuttonupfcn', '');

    th = 40; % text height
    tw = 260; % text width

    % text and edit
    % 1. MT file
    h_load_tf_pbutt = uicontrol( ...
        'Parent', h_correct_drift_fig, ...
        'Style', 'pushbutton', ...
        'String', 'Load Transformation Matrix', ...
        'FontSize', 12, ...
        'Position', [20, 140, tw, th], ...
        'Callback', @h_load_tf_pbutt_Callback);
    h_load_tf_edit = uicontrol( ...
        'Parent', h_correct_drift_fig, ...
        'Style', 'edit', ...
        'String', '', ...
        'FontSize', 12, ...
        'Position', [20, 80, tw, th], ...
        'Enable', 'on');


    % 3. ok push button
    h_correct_pbutt = uicontrol( ...
        'Parent', h_correct_drift_fig, ...
        'Style', 'pushbutton', ...
        'String', 'Correct', ...
        'Position', [95, 20, tw/4, th], ...
        'Callback', @h_correct_pbutt_Callback);

    % Display the main window
    movegui(h_correct_drift_fig, 'center');
    set(h_correct_drift_fig, 'Visible', 'on');
    uiwait(gcf);

%% Callbacks
function h_load_tf_pbutt_Callback(srt, env)
    [filename,pathname] = uigetfile( ...
        {'*.txt';'*.*'}, ...
        'Choose Transformation File');
    if filename == 0
        return;
    end
    complete_filename = strcat(pathname, filename);
    gb_imagej_tf_file = complete_filename;
    update_text(h_load_tf_edit, gb_imagej_tf_file);
end

function h_correct_pbutt_Callback(srt, env)
    if(exist(gb_imagej_tf_file, 'file')==0)
        msgbox('No Transformation Matrix File');
        return;
    end
    if(exist('gb_mt_imgs', 'var')==0)
        msgbox('No MT Images');
        return;
    end
    gb_mt_imgs = correct_drift(gb_mt_imgs, gb_imagej_tf_file);
    if(exist('gb_map_imgs', 'var')==1)
        gb_mt_imgs = correct_drift(gb_mt_imgs, gb_imagej_tf_file);
    end
    uiwait(msgbox('Done')); % another useful trick:)
    close(h_correct_drift_fig);
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