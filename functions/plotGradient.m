function plotGradient(tsc)

h.figure = figure;
subplot(2,1,1)
plot(tsc.estGradient.data(:,1))
grid on

subplot(2,1,2)
plot(tsc.estGradient.data(:,2))
grid on


set(findall(gcf,'Type','Axes'),'FontSize',32)
linkaxes(findall(gcf,'Type','Axes'), 'x');


end