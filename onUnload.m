function onUnload()
%ONUNLOAD Remove the src directories from the matlab path
    srcDir = [fileparts(mfilename('fullpath')) filesep 'src'];
    verInfoDir = fullfile(srcDir, 'semvername');
    rmpath(srcDir);
    rmpath(verInfoDir);
end

