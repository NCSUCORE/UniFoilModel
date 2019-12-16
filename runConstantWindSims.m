% Run simulations with constant wind
close all; clear; clc
preLoadCallback
p.saveOnOff     = 1;
p.verbose       = 1;
textOnOff       = 1;
p.windVariant   = 1;
p.numOptimizationLaps   = 500;
p.T                     = inf;
p.runMode       = 'Optimization';
ics             = {'1','2','3'};
for ii = 1:length(ics)
    try
        p.ic = ics{ii};
        tic
        sim('CDCJournalModel')
        toc
        close all
        plotPerformanceIndex(tsc);
        annotation('textbox', [0 0.9 1 0.1], ...
            'String', ['IC ' p.ic ' Constant Wind - Performance Index'], ...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center','FontSize',32);
        if p.saveOnOff
            savePlot(gcf,...
                fullfile(fileparts(which('CDCJournalModel')),'figures'),...
                ['IC_' ics{ii} '_Const_Opt_Perf']);
        end
        plotBasisParameters(tsc)
        annotation('textbox', [0 0.9 1 0.1], ...
            'String', ['IC ' p.ic ' Constant Wind - Basis Parameters'], ...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center','FontSize',32);
        if p.saveOnOff
            savePlot(gcf,...
                fullfile(fileparts(which('CDCJournalModel')),'figures'),...
                ['IC_' ics{ii} '_Const_Opt_BPs']);
        end
    catch ME
        if textOnOff
            textMe('Error')
        end
        rethrow(ME)
    end
end
if textOnOff
    textMe('Done')
end
