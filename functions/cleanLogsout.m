function logsout = cleanLogsout(logsout)


% If the signal name doesnt exist, get rid of it and warn the user
signals = logsout.getElementNames;
sigToRemove = find(cellfun(@isempty, signals));
for ii = 1:length(sigToRemove)
    blockPath = logsout.getElement(sigToRemove(ii)).BlockPath.convertToCell;
    warning('Removing unnamed signal from logsout.\n Signal origin: %s',blockPath{1})
end
logsout = logsout.removeElement(unique(sigToRemove));

% If the signal appears multiple times, get rid of duplicates and
% warn the user
signals = logsout.getElementNames;
signalsUnique = unique(signals);
sigToRemove = [];
for ii = 1:length(signalsUnique)
    if sum(strcmp(signalsUnique{ii},signals))>1
        occurrences = find(strcmp(signalsUnique{ii},signals));
        sigToRemove = [sigToRemove; occurrences(2:end)];
    end
end
logsout = logsout.removeElement(unique(sigToRemove));
end