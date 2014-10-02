function onLoad()
%ONLOAD Add the src directories to the matlab path
    srcDir = [fileparts(mfilename('fullpath')) filesep 'src'];
    verInfoDir = fullfile(srcDir, 'semvername');
    addpath(srcDir, '-end');
    addpath(verInfoDir, '-end');
end

