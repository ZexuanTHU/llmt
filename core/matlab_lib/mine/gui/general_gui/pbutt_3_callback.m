function pbutt_3_callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% reference
% https://cn.mathworks.com/help/matlab/ref/zoom.html
% https://cn.mathworks.com/help/matlab/creating_guis/...
% add-code-for-components-in-callbacks.html

global TOOLBAR_INFO;
global CANVAS_INFO;

TOOLBAR_INFO.curr_butt = 3;
deact_all_pbutt();
this_pbutt = TOOLBAR_INFO.pbutts{TOOLBAR_INFO.curr_butt};
setappdata(this_pbutt,'is_on',1);

zoom_axes(CANVAS_INFO.h_axes,CANVAS_INFO.mag_factor);

end