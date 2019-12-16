function initializeBusses
% This function initializes the busses 

%% Create the plant feedback bus automatically
busElementData = {...
    'gammaWing',1,'double';...
    'gammaRudder',1,'double';...
    'positionGFS',3,'double';...
    'positionGFC',3,'double';...
    'heading',1,'double';...
    'headingDot',1,'double';...
    'BFXDot',1,'double';...
    'vAppWindGFC',3,'double';...
    'MzBFC',1,'double';...
    'BFY_GFC',3,'double';...
    };
createBusInBaseWorkspace(busElementData,'busPlantFeedback')

%% Create the controller output bus automatically
clear busElementData
busElementData = {'wingAngleCommand',1,'double';...
    'rudderAngleCommand',1,'double'};
createBusInBaseWorkspace(busElementData,'busControllerOutput')

%% If we're running the optimization controller, then create the controller feedback bus
p = evalin('base','p');
if ~strcmpi(p.runMode,'SpatialILC')
    % Create the controller feedback bus automatically
    clear busElementData
    busElementData = {...
        'basisParams',2,'double';...
        'performanceIndex',1,'double';...
        'energyGenerationTerm',1,'double';...
        'spatialErrorTerm',1,'double';...
        'minimumDistanceToPath',1,'double';...
        'waypointUpdateTrigger',1,'boolean';...
        };
    createBusInBaseWorkspace(busElementData,'busControllerFeedback')
end

end