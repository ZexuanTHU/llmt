import matlab.engine

eng = matlab.engine.connect_matlab('MATLAB_5329')
eng.mt_workflow_gui(nargout=0)
eng.quit()