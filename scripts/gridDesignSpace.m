clear all
clc
preLoadCallback
% Note, put model in normal or accelerator mode for rapid restart to avoid
% recompile (does not work in rapid accelerator)

p.runMode = 'grid';
heights = linspace(0,20,10);
widths  = linspace(20,100,10);
[widths,heights] = meshgrid(widths,heights);
J = zeros(size(widths));
energyTerm = zeros(size(widths));
spatialTerm = zeros(size(widths));

for ii = 1:numel(widths)
    fprintf('\nStarting Simulation %s\n',num2str(ii))
    tic
    p.width = widths(ii);
    p.height = heights(ii);
    sim('CDCJournalModel')
    toc
    J(ii) = tsc.performanceIndex.data(end);
    energyTerm(ii) = tsc.energyGenerationTerm.data(end);
    spatialTerm(ii) = tsc.spatialErrorTerm.data(end)/p.weightSE;
    close all
    figure
    subplot(1,2,1)
    surf(widths,heights,energyTerm)
    xlabel('Width')
    ylabel('Height')
    zlabel('Energy Gen Term')

    
    subplot(1,2,2)
    surf(widths,heights,-spatialTerm)
    xlabel('Width')
    ylabel('Height')
    zlabel('Negative of Spatial Error Term')


    set(findall(gcf,'Type','Axes'),'FontSize',24)
    
    drawnow
    
    figure
    surf(widths,heights,J)
    xlabel('Width')
    ylabel('Height')
    zlabel('Performance Index')
    
end

textMe('Simulation Complete')

