
preLoadCallback;
% remember to turn off dropbox sync and comment out the preload callback
% from the model.
clc
close all
bdclose all
initialConditions = {'short','both','wide'};

p.windVariant = 1;
p.runMode = 'optimization';
p.soundOnOff = 0;
p.forgettingFactor = 0.999;

% for ii = 1:length(initialConditions)
%     p.ic = initialConditions{ii};
%     removeCompiledModel
%     try
%         fprintf('\nSimulating\n')
%         sim('CDCJournalModel') 
%     catch
%         fprintf('\nFailed Simulation\n')
%     end
% end

p.windVariant = 3;
p.runMode = 'optimization';
p.forgettingFactor = 0.999;

for ii = 1:length(initialConditions)
    p.ic = initialConditions{ii};
    removeCompiledModel
    try
        fprintf('\nSimulating\n')
        sim('CDCJournalModel')
    catch
        fprintf('\nFailed Simulation\n')
    end
    
    
end

p.windVariant = 3;
p.runMode = 'baseline';

for ii = 1:length(initialConditions)
    p.ic = initialConditions{ii};
    removeCompiledModel
    try
        fprintf('\nSimulating\n')
        sim('CDCJournalModel')
    catch
        fprintf('\nFailed Simulation\n')
    end
    
    
end