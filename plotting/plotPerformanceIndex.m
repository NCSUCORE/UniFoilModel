function h = plotPerformanceIndex(tsc)
mask = circshift(tsc.waypointUpdateTrigger.data,-1);

h.figure1 = figure();

h.ax1 = subplot(2,2,1);
plot(tsc.performanceIndex.time(mask)/60,tsc.performanceIndex.data(mask))
grid on
xlabel('Time, $t$ [min]')
ylabel({'Performance','Index'})

h.ax2 = subplot(2,2,3);
plot(tsc.currentIterationNumber.data(mask),tsc.performanceIndex.data(mask))
grid on
xlabel('Iteration Number, $j$ [s]')
ylabel({'Performance','Index'})

h.ax3 = subplot(2,2,2);
plot(tsc.currentIterationNumber.data(mask),tsc.energyGenerationTerm.data(mask))
grid on
xlabel('Iteration Number')
ylabel({'Energy Gen.'})

h.ax4 = subplot(2,2,4);
plot(tsc.currentIterationNumber.data(mask),tsc.spatialErrorTerm.data(mask))
grid on
xlabel('Iteration Number')
ylabel({'Spatial Err.'})

set(findall(gcf,'Type','Axes'),'FontSize',32)
linkaxes([h.ax2 h.ax3 h.ax4], 'x');

end