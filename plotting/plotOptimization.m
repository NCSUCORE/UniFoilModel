% Script to animate the evolution in design space of the optimization
idx  = round(tsc.fitCoefficients.Time./p.Ts);
bp   = tsc.basisParams.data(idx,:)*180/pi;

h.fig = figure;
h.ax = gca;
set(h.ax,'NextPlot','Add')

xLims = [min(bp(:,1)) max(bp(:,1))];
yLims = [min(bp(:,2)) max(bp(:,2))];
set(gca,'XLim',xLims)
set(gca,'YLim',yLims)
widths  = linspace(xLims(1), xLims(2), 100);
heights = linspace(yLims(1), yLims(2), 100);
[widths,heights] = meshgrid(widths,heights);
J = fitSurface(tsc.fitCoefficients.data(10,:),widths,heights);
h.contour = contour(widths,heights,J,'ShowText','on')
h.currentBP = scatter(bp(1,1),bp(1,2),'Marker','x','CData',[1 0 0]);
h.nextBP   = scatter(bp(2,1),bp(2,2),'Marker','o','CData',[0 0 1]);
h.gradient = quiver(bp(1,1),bp(1,2),...
    tsc.estGradient.data(10,1),tsc.estGradient.data(10,2));
xlabel('Width')
ylabel('Height')
set(gca,'FontSize',24)
for ii = 12:size(tsc.fitCoefficients.data,1)
    
    
end


function J = fitSurface(c,w,h)
J = c(1)+c(2).*w+c(3).*w.^2+c(4).*h+c(5).*h^2;
end