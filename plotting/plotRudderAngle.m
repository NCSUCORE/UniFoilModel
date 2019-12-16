function h = plotRudderAngle(varargin)
tsc = evalin('base','tsc');
if numel(varargin)
    lapNumber = varargin{1};
    times = tsc.currentIterationNumber.time(...
        and(tsc.currentIterationNumber.data>=min(lapNumber),...
        tsc.currentIterationNumber.data<=max(lapNumber)));
    signals = fieldnames(tsc);
    for ii= 1:length(signals)
        tsc.(signals{ii}) =  getsampleusingtime(tsc.(signals{ii}),...
            times(1) ,times(end));
    end
end

h.figure = figure;
subplot(2,1,1)
h.rudderAngleCommandPreSat = plot(tsc.rudderAngleCommandPreSat,...
    'DisplayName','Command Pre Sat',...
    'Color',[0.5 0.5 0.5],'LineStyle','-');

hold on
grid on
h.rudderAngleCommand = plot(tsc.rudderAngleCommand,'DisplayName','Command',...
    'Color','k','LineStyle','-');
% h.rudderAngleUpperLimit = plot(tsc.rudderAngleUpperSaturation,'Color','r',...
%     'DisplayName','Upper Limit');
% h.rudderAngleLowerLimit = plot(tsc.rudderAngleLowerSaturation,'Color','r',...
%     'DisplayName','Lower Limit');
% ylim([min(tsc.rudderAngleLowerSaturation.data)...
%     max(tsc.rudderAngleUpperSaturation.data)])
legend
xlabel('Time, t')
ylabel('Angle, [rad]')
set(gca,'FontSize',24)


subplot(2,1,2)

h.headingAngle = plot(tsc.rudderCommandError,'Color','k','DisplayName','Heading Error');
grid on
hold on
legend
xlabel('Time, t')
ylabel('Angle, [rad]')
set(gca,'FontSize',24)

% avgErr = (1/(times(end)-times(1)))*cumtrapz(times,(tsc.rudderAngleCommandPreSat.data-tsc.rudderAngleCommand.data).^2);
end