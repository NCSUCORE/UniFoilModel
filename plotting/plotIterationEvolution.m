function h = plotIterationEvolution()
%% Create plots of the basis parameters under constant wind
files = dir(fullfile(pwd,'paperData','constantWind'));
files = files(3:end);
files = {files.name};
files = split(files,'.');
files = files(:,:,1);

iterations = [11 15 20 40];
lineStyles = {'-','--',':'};
colors = {'k',0.33*[1 1 1],0.66*[1 1 1]};

for ii = 1:length(files)
    h{ii}.fig = createFigure();
    h{ii}.axTop = gca;
    xlabel('Path Variable, s')
    ylabel('EAR')
    h{ii}.axTop.FontSize = 36;
    hold on
    grid on
    
%     title('')
%     h{ii}.axBottom = subplot(2,1,2);
%     xlabel('Path Variable, s')
%     ylabel({'Spatial','Error [m]'})
%     h{ii}.axBottom.FontSize = 36;
%     hold on
%     grid on
    
    load(fullfile(pwd,'paperData','constantWind',files{ii}))
    
    for jj = 1:length(iterations)
        tscc = getsampleusingtime(tsc,iter.startTimes(iterations(jj)),iter.endTimes(iterations(jj)+1));
        plot(tscc.targetWaypointIndex.data(2:end),...
            tscc.meanPAR.data(2:end),'Parent',...
            h{ii}.axTop,'LineStyle',lineStyles{jj},'LineWidth',1.5,...
            'Color',colors{jj})
%         plot(tscc.targetWaypointIndex.data(2:end),tscc.minimumDistanceToPath.data(2:end),'Parent',h{ii}.axBottom)
    end
    
end

end