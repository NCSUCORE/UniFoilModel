function h = plotPaperExampleCourses

fileName = fullfile(fileparts(which('CDCJournalModel')),...
    'paperData','constantWind','2ndDraft',...
    '2_constant_Optimization_1401_114643.mat');
load(fileName)

iterationsToPlot = [1 100];
h.fig = figure;
h.fig.Position = h.fig.Position.*[1 1 0.5 1];
set(gca,'NextPlot','Add')
set(gca,'FontSize',36)

lineStyles = {'-','--'};

for ii = 1:length(iterationsToPlot)
    mask = tsc.currentIterationNumber.data==iterationsToPlot(ii);
    bp = tsc.basisParams.data(mask,:);
    bp = bp(2,:);
    [azimuth,zenith] = pathShape(bp,p.elev*pi/180,linspace(0,1,1000));
    radius = p.initPositionGFS(1)*ones(size(azimuth));
    x = radius.*cos(azimuth).*sin(zenith);
    y = radius.*sin(azimuth).*sin(zenith);
    z = radius.*cos(zenith);
    plot3(x,y,z,...
        'DisplayName',['Iteration ' num2str(iterationsToPlot(ii))],...
        'LineWidth',2,'LineStyle',lineStyles{ii})
    
end
xlabel('x, [m]')
ylabel('y, [m]')
zlabel('z, [m]')
title({'Example 3D Path Geometries','Initial Condition 2'})
grid on
axis equal
view([65 23])

h.leg = legend;
h.leg.Units = 'normalized';
h.leg.Position  = [0.5675    0.7    0.3070    0.1178];


savePlot(h.fig,fullfile(fileparts(which('CDCJournalModel')),'paperFigures'),'exampleCourseGeometries')
end