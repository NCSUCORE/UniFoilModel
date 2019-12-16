

file = fullfile(fileparts(fileparts(which(mfilename))));

% if the simulink cache file exists, delete it
if exist(fullfile(file,'CDCJournalModel.slxc'),'file')==2
    delete(fullfile(file,'CDCJournalModel.slxc'));
end

% if there's a directory containing the compiled model "slprj" then delete
if exist(fullfile(file,'slprj'),'dir')==7
    % If the directory is on the path, remove it
    if any(strcmpi(fullfile(file,'slprj'), regexp(path, pathsep, 'split')))
        rmpath(fullfile(file,'slprj'));
    end
    % Delete the directory
    rmdir(fullfile(file,'slprj'),'s')
end

clearvars file
