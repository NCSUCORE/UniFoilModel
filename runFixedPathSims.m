% Run simulations with variable wind, fixed path
close all; clear; clc
preLoadCallback
p.saveOnOff     = 1;
p.verbose       = 1;
textOnOff       = 1;
p.windVariant   = 3;
p.numOptimizationLaps   = inf;
p.T                     = 2*60*60;
p.runMode       = 'baseline';
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
            'String', ['IC ' p.ic ' NREL Wind, Baseline - Performance Index'], ...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center','FontSize',32);
        if p.saveOnOff
            savePlot(gcf,...
                fullfile(fileparts(which('CDCJournalModel')),'figures'),...
                ['IC_' ics{ii} '_NREL_Bsl_Perf']);
        end
        plotBasisParameters(tsc);
        annotation('textbox', [0 0.9 1 0.1], ...
            'String', ['IC ' p.ic ' NREL Wind, Baseline - Basis Parameters'], ...
            'EdgeColor', 'none', ...
            'HorizontalAlignment', 'center','FontSize',32);
        if p.saveOnOff
            savePlot(gcf,...
                fullfile(fileparts(which('CDCJournalModel')),'figures'),...
                ['IC_' ics{ii} '_NREL_Bsl_BPs']);
        end
    catch ME
        if textOnOff
            textMe('Error')
        end
        rethrow(ME)
    end
end

textMe('Done')

