function play_gui_with_point(img, centers)
%% PLAY_GUI play image as movies
% img: the images to be played
        
%% UI

    [img_height, img_width, num_frames] = size(img);
    [np, nl] = size(centers); 

    % centers = [gb_mt_end_params.center];
    if(np==1)
        centers = repmat(centers,num_frames,1);
        np = num_frames;
    end
    
    if(num_frames~=np)
        msgbox(['the number of points must be equal to image frame ' ...
                'number']);
        return;
    end
    
    x = real(centers);
    y = imag(centers);
    
    % Create and then hide the GUI as it is being constructed.
    % [left bottom width height]
    h_main_fig = figure( ...
        'Visible','off', ...
        'Position',[1 1 900 700], ...
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
        'Position', [50 80 800 600], ...
        'userdata', []);
    set(h_img_axes, 'xtick', [], 'ytick', []); 
    imshow(img(:,:,1),[]);
    axis(h_img_axes, 'manual');

    h_line_axes = axes( ...
        'Parent', h_main_fig, ...
        'Units', 'pixels', ...
        'Position', [50 80 800 600], ...
        'Color', 'none', ...
        'XLim', get(h_img_axes, 'XLim'), ...
        'YLim', get(h_img_axes, 'YLim'), ...
        'ZLim', get(h_img_axes, 'ZLim'), ...
        'XDir', get(h_img_axes, 'XDir'), ...
        'YDir', get(h_img_axes, 'YDir'), ...
        'DataAspectRatio', get(h_img_axes, 'DataAspectRatio'), ...
        'DataAspectRatioMode', get(h_img_axes, 'DataAspectRatioMode'), ...
        'userdata', struct('lines',[]));
    % lines: MT ends
    set(h_line_axes, 'xtick', [], 'ytick', []);
    h_lines = get(h_line_axes, 'userdata');
    for jj=1:nl
        h_lines.lines(jj) = line('XData',0, 'YData', 0, ...
                                 'Marker', 'p', 'color', 'r');
        if(~isnan(x(1,jj)) || ~isnan(y(1,jj)))
            set(h_lines.lines(jj), 'XData', x(1,jj), ...
                              'YData', y(1,jj));
        end
    end
    axis(h_line_axes, 'manual');

    % 2. Slider
    h_img_slider = uicontrol( ...
        'Parent', h_main_fig, ...
        'style','slider', ...
        'position',[50,30,800,20], ...
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
        'Parent', h_main_fig, ...
        'style','text', ...
        'FontSize', 24, ...
        'position',[400,50,100,30], ...
        'Callback', '');
    set(h_img_slider_idx, ...
        'String', ...
        round(get(h_img_slider, 'Value')));

    % Display the main window
    set(h_main_fig, 'Name', 'playing movie');
    movegui(h_main_fig, 'center');
    set(h_main_fig, 'Visible', 'on');

    
    %% Callbacks
    
    function h_img_slider_Callback(src, evt)
        v = round(get(src, 'Value'));
        imshow(img(:,:,v), [], 'Parent', h_img_axes);
        set(h_img_slider_idx, 'String', v);
        for jj=1:nl
            tmpx = 0;
            tmpy = 0;
            if(~isnan(x(v,jj)) || ~isnan(y(v,jj)))
                tmpx = x(v,jj);
                tmpy = y(v,jj);
            end
            set(h_lines.lines(jj), 'XData', tmpx, ...
                              'YData', tmpy);
        end
        drawnow;
    end
    
end
