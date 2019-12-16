% Run simulations with constant wind
% USE THIS SCRIPT TO GENERATE RESULTS FOR WINDLIFT
% Note that CL and CD in the aerodynamics of the main wing have been
% overwritten by constant, hard coded numbers.
close all; clear; clc
preLoadCallback
p.saveOnOff     = 1;
p.verbose       = 1;
textOnOff       = 1;

p.numOptimizationLaps   = 500;
p.T                     = 6700;

p.runMode       = 'baseline';
p.ic            = 'custom';
p.windVariant   = 3;% 1 for constant wind, 2 for Dr. Archers Data, 3 for NREL data

p.vWind         = 8;
p.mass          = 75;
p.wingSpan      = 15; % These wind dimensions approximately match the AR of windlift
p.refLengthWing = 1;
p.tetherLength  = 150;
p.initVelocity  = 45;
p.rotorDiameter = 1.1;
p.elev = 30;
p.dragCoefficientRotor = 0.7;

turbineCp = 0.5;

sim('CDCJournalModel')


%%
fprintf('Mean Power\n')
mean(tsc.turbinePower.data)

figure('Position',[-0.9995    0.0380    0.4990    0.8833])
subplot(2,1,1)
tsc.turbinePower.plot('LineWidth',2)
xlabel('Time, [s]')
ylabel('Power [w]')
title('')


subplot(2,1,2)
tsc.BFXDot.plot('LineWidth',2)
xlabel('Time, [s]')
ylabel('Speed,[m/s]')
title('')

set(findall(gcf,'Type','axes'),'FontSize',24)

figure('Position',[     0    0.0370    1.0000    0.8917])
set(gca,'NextPlot','add')
plot3(tsc.positionGFC.data(:,1),...
    tsc.positionGFC.data(:,2),...
    tsc.positionGFC.data(:,3),'LineWidth',2)
scatter3(0,0,0,'CData',[1 0 0])
grid on
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')
axis square
axis equal
title('Flight Path')
set(findall(gcf,'Type','axes'),'FontSize',24)
view(52.3231,15.5450)

%% Plot rotor drag over wing drag.  should be about 0.5
figure('Position',[-0.4995    0.5194    0.4990    0.4019])
plot(tsc.FDragRotor.Time,...
    tsc.FDragRotor.Data./tsc.FDragWing.Data,...
    'LineWidth',1.5)
xlabel('Time, [s]')
ylabel('$F_D^{Turb}/F_D^{Wing}$')
set(findall(gcf,'Type','axes'),'FontSize',24)
