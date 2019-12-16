if p.verbose
    fprintf('\n--------------------------------\n' )
    fprintf('\nStarting Model.\n')
end
% Switch to the right directory
cd(fileparts(which('CDCJournalModel.slx')))

% Ensure that signal logging is on and set to the right variable name
% set_param('CDCJournalModel','SignalLogging','on');
% set_param('CDCJournalModel','SignalLoggingName','logsout');
% set_param(bdroot,'SimulationCommand','WriteDataLogs');

% Clear persistent variables
vars = whos;
persistentVars = vars([vars.global]);
persistentVarNames = {persistentVars.name};
if ~isempty(persistentVarNames)
    clear(persistentVarNames{:});
end
clearvars logsout tmp_raccel_logsout vars persistentVars persistentVarNames