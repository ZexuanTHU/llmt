function check_erfc_fitting(img, erfc_params,varargin)
%% PLAY_GUI play image as movies
% img: the images to be played
% erfc_params: ONE fitting model

%% UI

    [img_height, img_width, num_frames] = size(img);
    if(nargin>2)
        num_line = varargin{1};
    else
        num_line = 1;
    end
    erfc_params = erfc_params(num_line);

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
    h_line_axes = axes( ...
        'Parent', h_main_fig, ...
        'Units', 'pixels', ...
        'Position', [50 80 800 600]);
    % lines: MT ends
    hold(h_line_axes,'on');
    [x,ori_y,fit_y,str] = get_xy(1);
    if(numel(x)>0)
        plot(h_line_axes,x,ori_y,'ro');
        plot(h_line_axes,x,fit_y,'k-');
        y_max = max(max(ori_y),max(fit_y));
        y_min = min(min(ori_y),min(fit_y));
    end
    text(mean(xlim(h_line_axes)), mean(ylim(h_line_axes)),str,'FontSize',14);
    hold(h_line_axes,'off');
    drawnow;

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

    %% helper functions
    function [x, ori_y, fit_y, str] = get_xy(ind_frame)
        x = [];
        ori_y = [];
        fit_y = [];
        str = '';
        c = erfc_params.center(ind_frame);
        s = erfc_params.sigma(ind_frame);
        d = erfc_params.direction(ind_frame);
        b = erfc_params.baseline(ind_frame);
        m = erfc_params.amplitude(ind_frame);
        if(isnan(c) || isnan(s) || isnan(d) || ...
           isnan(b) || isnan(m))
            str = 'NaN';
            return;
        end
        w = s*3; % profiling width
        n = round(w*4);
        x = linspace(-w,w,n);
        % get the original data
        ps = c - w * ( cos(d) + sqrt(-1) * sin(d) );
        pe = c + w * ( cos(d) + sqrt(-1) * sin(d) );
        xdat = [real(ps),real(pe)];
        ydat = [imag(ps),imag(pe)];
        if(xdat(1)<1.5 | xdat(1)>(img_width-0.5) | ...
           xdat(2)<1.5 | xdat(2)>(img_width-0.5) | ...
           ydat(1)<1.5 | ydat(1)>(img_height-0.5) | ...
           ydat(2)<1.5 | ydat(2)>(img_height-0.5))
            str = strcat('Out of range; sigma: ',num2str(s));
            return;
        end
        if(abs(xdat(2)-xdat(1))<1 | ...
           abs(ydat(2)-ydat(1))<1 )
            str = strcat('sigma too small: ',num2str(s));
            return;
        end
        ori_y = my_line_profile(img(:,:,ind_frame), ...
                                xdat, ...
                                ydat, ...
                                1, ...
                                n);
        % get the fitted data
        fit_y = mt_erfc([0,s,m,b],x);
        str = strcat('sigma: ',num2str(s));
    end


    %% Callbacks

    function h_img_slider_Callback(src, evt)
        v = round(get(src, 'Value'));
        set(h_img_slider_idx, 'String', v);

        hold(h_line_axes,'on');
        [x,ori_y,fit_y,str] = get_xy(v);
        cla(h_line_axes);
        if(numel(x)>0)
            plot(h_line_axes,x,ori_y,'ro');
            plot(h_line_axes,x,fit_y,'k-');
            y_max = max(max(ori_y),max(fit_y));
            y_min = min(min(ori_y),min(fit_y));
        end
        text(mean(xlim(h_line_axes)), mean(ylim(h_line_axes)),str,'FontSize',14);
        hold(h_line_axes,'off');
        drawnow;
    end

end
