close all
clear
preLoadCallback

pos(1) = 100;
pos(2) = 5*pi/180;
pos(3) = (90 - p.elev)*pi/180;

sim('headingSetpointCaclulation_th')
%%
bp = [p.width p.height]*pi/180;

[pathAz,pathZn]     = pathShape(bp,p.elev*pi/180,linspace(0,1,10000));
[searchAz,searchZn] = pathShape(bp,p.elev*pi/180,linspace(0,2.5/100,100));
[closeAz,closeZn]   = pathShape(bp,p.elev*pi/180,pathVariable.data);
[targetAz,targetZn] = pathShape(bp,p.elev*pi/180,targetPathVariable.data);

plot(pathAz*(180/pi),(pi/2-pathZn)*(180/pi));
grid on
hold on
plot(searchAz*(180/pi),(pi/2-searchZn)*(180/pi),'Color','g');
scatter(pos(2)*180/pi,(pi/2-pos(3))*180/pi,'Marker','o','CData',[1 0 0]);


scatter(closeAz*180/pi,(pi/2-closeZn)*180/pi,'Marker','x','CData',[1 0 0]);
scatter(targetAz*180/pi,(pi/2-targetZn)*180/pi,'Marker','o','CData',[1 0 0]);
xlabel('Azimuth Angle, deg')
ylabel('Elevation Angle, deg')
set(gca,'FontSize',24)

headingSetpointRad.data(end)*180/pi