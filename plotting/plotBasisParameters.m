function h = plotBasisParameters(tsc)

h.figure = figure;

h.figure.Position(1)=-0.5; % Make half-screen
h.figure.Position(3)=0.5; % Make half-screen

ax1 = subplot(4,1,1);
plot(tsc.basisParams.time/60,tsc.basisParams.data(:,1)*180/pi)
grid on
xlabel('Time, t [min]')
ylabel('$W_j$ [deg]')

ax2 = subplot(4,1,2);
plot(tsc.currentIterationNumber.data,tsc.basisParams.data(:,1)*180/pi)
grid on
xlabel('Iteration Number, $j$')
ylabel('$W_j$ [deg]')

ax3 = subplot(4,1,3);
plot(tsc.basisParams.time/60,tsc.basisParams.data(:,2)*180/pi)
grid on
xlabel('Time, t [min]')
ylabel('$H_j$ [deg]')

ax4 = subplot(4,1,4);
plot(tsc.currentIterationNumber.data,tsc.basisParams.data(:,2)*180/pi)
grid on
xlabel('Iteration Number, $j$')
ylabel('$H_j$ [deg]')

linkaxes([ax1 ax3],'x')
linkaxes([ax2 ax4],'x')

set(findall(gcf,'Type','Axes'),'FontSize',16)
set(findall(gcf,'Type','Axes'), 'XLimSpec', 'Tight');
end