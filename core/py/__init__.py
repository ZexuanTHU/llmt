import os
import matlab.engine
import sys
import signal

pid = os.getpid()
print(pid)
root_path = os.path.abspath('..')
print(root_path)
names = matlab.engine.find_matlab()
if(names):
    print('MATLAB already started...Connecting to {}...'.format(names[0]))
    eng = matlab.engine.connect_matlab(names[0])
    print('Connect to MATLAB')
else:
    print('Starting MATALB...')
    eng = matlab.engine.start_matlab()
    print('Done!')

add_paths_path = root_path + '/matlab_lib/mine/file/'
eng.cd(add_paths_path)
eng.add_paths(os.path.abspath('../../../'), nargout=0)
eng.mt_workflow_gui(nargout=0)

print('PATH add!')
print('lalala')
