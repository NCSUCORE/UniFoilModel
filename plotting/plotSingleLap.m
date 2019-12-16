function h = plotSingleLap(lapNumber)
% Extract the apropriate data
tsc = evalin('base','tsc');
p = evalin('base','p');
signals = fieldnames(tsc);
times = tsc.(signals{1}).time(tsc.currentIterationNumber.data==lapNumber);
% tsc = getsampleusingtime(tsc,times(1),times(end));

for ii= 1:length(signals)
   tsc.(signals{ii}) =  getsampleusingtime(tsc.(signals{ii}),...
       times(1) ,times(end));
end

[sphereX,sphereY,sphereZ] = sphere(tsc.positionGFS.data(1,1));
sphereX = p.initPositionGFS(1)*sphereX;
sphereY = p.initPositionGFS(1)*sphereY;
sphereZ = p.initPositionGFS(1)*sphereZ;

h.fig = createFigure();

h.sphere = surf(sphereX,sphereY,sphereZ,...
    'EdgeColor','none','FaceAlpha',0.25);
hold on
set(h.sphere,'FaceColor',[0 0 0])

basisParams = tsc.basisParams.data(1,:);

[pathAzimuth,pathZenith] = pathShape(basisParams,p.elev*pi/180,linspace(0,1,1000));
[targetAz,targetZn]      = pathShape(basisParams,p.elev*pi/180,tsc.targetPathVariable.data);

[pathX,pathY,pathZ]       = sphere2cart(p.initPositionGFS(1),pathAzimuth,pathZenith);
[targetX,targetY,targetZ] = sphere2cart(p.initPositionGFS(1),targetAz   ,targetZn);

positionsGFC = tsc.positionGFC.data;
plot3(pathX,pathY,pathZ,'DisplayName','Path','LineStyle','-','LineWidth',2,'Color','r')
% plot3(targetX,targetY,targetZ,'DisplayName','Target','LineStyle','-','LineWidth',2,'Color','g')
plot3(positionsGFC(:,1),positionsGFC(:,2),positionsGFC(:,3),...
    'DisplayName','SystemPosition','Color','b','LineWidth',2);
axis equal
% xlim([min(pathX) max(pathX)])
% ylim([min(pathY) max(pathY)])
% zlim([min(pathZ) max(pathZ)])
set(gca,'FontSize',36)
view(60,30)
legend
end