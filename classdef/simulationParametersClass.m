classdef simulationParametersClass < handle
    properties
        % Simulation Time
        T = inf;
        Ts = 0.002;  % Sample time
        
        % Output Settings (0 to turn off , 1 to turn on)
        verbose         = 1; % Text output to command window
        plotsOnOff      = 0; % Generate plots
        animationOnOff  = 0; % Generate animations
        saveOnOff       = 1; % Save data to the hard drive
        soundOnOff      = 0; % Turn on/off gong noise at end of simulation 
        decimation      = 1; % Log data every N points
        
        % Simulation Switches
        runMode     = 'optimization'; % 'optimization','baseline', 'grid', or 'spatialILC'
        modelName   = 'CDCJournalModel'; % Name of the model to run
        windVariant = 1;% 1 for constant wind, 2 for Dr. Archers Data, 3 for NREL data
        
        % Environmental Conditions Switches
        gravityOnOff    = 1; % 0 turns gravity off
        
        vWind           = 7; % Mean wind speed (used when windVariant = 1)
        windDirection   = 0; % Wind heading in degrees
        turbulenceOnOff = 0; % 0 for off, 1 for on (0 sets wind speed to Dr. Archers data, linearly interpolated)
        windAltitude    = 146; % Must be one of the available altitudes from Dr. Archer's data
        noiseSeeds      = [23341 23342 23343 23344];  % Noise seeds used in white noise generators for von Karman turbulence
        rho             = 1.225;     % density of air kg/m^3
        viscosity       = 1.4207E-5; % Kinematic viscosity of air (I think this is only used in Reynolds number calculation)
        g               = 9.80665;   % Acceleration due to gravity
        
        % Performance Index Weights
        weightME   = 1;     % Weight on Mean Energy in performance index
        weightPAR  = 1;     % Weight on Power Augmentation Ratio in performance index
        weightSE   = 20;    % Weight on Spatial Error in performance index
        
        % Optimization Settings
        updateTypeSwitch            = 2;    % 1 for Newton-based ILC update law, 2 for gradient-based ILC update law
        persistentExcitationSwitch  = 2;    % 1 for sin and cos, 2 for white noise
        
        KLearningNewton             = .1;   % ILC learning gain for Newton-based update
        KLearningGradient           = 5; % ILC learning gain for gradient-based update
        azimuthDistanceLim          = 3;    % Size of trust region degrees
        zenithDistanceLim           = 1;     % Size of trust region degrees
        
        % RLS Settings
        numOptimizationLaps     = 200;
        numInitializationLaps   = 5;    % 5 or 9 point initialization
        forgettingFactor        = 0.98;    % Forgetting factor used in RLS response surface update
        azimuthOffset           = 5;    % degrees, initialization grid step size
        zenithOffset            = 1;  % degrees, initialization grid step size
        azimuthNormalizationFactor = 1; % degrees
        zenithNormalizationFactor = 1; % degrees
        
        
        % Persistent Excitation Settings
        azimuthPerturbationPeriod    = 4;     % azimuth basis parameter excitation period (when using sin/cos)
        zenithPerturbationPeriod     = 4;     % zenith basis parameter excitation period (when using sin/cos)
        azimuthPerturbationAmplitude = 0.75;   % azimuth basis parameter excitation amplitude
        zenithPerturbationAmplitude  = 0.2;     % zenith basis parameter excitation amplitude
        
        % Waypoints Settings
        ic     = '1';       % which set of initial conditions to use, if 'userspecified' then must set width and height manually in calling script
        elev   = 40;           % mean course elevation
        
        % Path Following Parameters
        projectionTolerance = 10^-4; % Tolerance on path variable for projection
        initialPathVariable = 0; % Initial path variable
        leadLength          = 0.02;         % range of total path variable that the carrot is ahead
        searchDistance      = 0.01;  % range of path variable to search
        
        % Rudder Controller
        kr1  = 100; % Controller gain
        kr2  = 100; % Controller gain
        tauR = 0.03;  % Ref model time const: 1/(tauR*s+1)^2
        
        % Lifting Body Physical Parameters
        mass      = 100; % Mass
        momentArm = 7; % Length of moment arm for rudder
        massFractionWing = 0.6;
        massFractionFuselage = 0.35;
        massFractionRudder = 0.05;
        
        % Aerodynamic Parameters
        oswaldEfficiency  = 0.8; % For both wing and rudder
        refLengthWing     = 1; % Chord length of airfoil
        wingSpan          = 7; % Wing span
        refLengthRudder   = 1; % Rudder reference length (chord)
        rudderSpan        = 1.5; % Rudder span
        
        % Initial Conditions
        initVelocity      = 25; % Initial straight line speed (BFX direction)
        initOmega         = 0;  % Initial twist rate
        tetherLength        = 100;

        
        % Airfoil lift/drag coefficient fitting limits
        % Defines the range of angles of attack over which we fit a line
        wingClStartAlpha    = -0.1;
        wingClEndAlpha      = 0.1;
        wingCdStartAlpha    = -0.1;
        wingCdEndAlpha      = 0.1;
        rudderClStartAlpha  = -0.1;
        rudderClEndAlpha    = 0.1;
        rudderCdStartAlpha  = -0.1;
        rudderCdEndAlpha    = 0.1;
        
        % Rotor aerodynamics
        numRotors = 4; % Number of rotors
        rotorDiameter = 0.25; % Diameter of a single rotor
        dragCoefficientRotor = 0.7; % Drag coefficient of a single rotor
        
        % Spatial ILC
        waypointPathIndices = [0.25 0.75];
        exponentialGainAmplitude = 0.25*pi/180;
        exponentialWidth = 60;
    end
    properties (Dependent = false) % Property value is not stored in object
        
    end
    properties (Dependent = false) % Property value is stored in object
        runModeSwitch                    % Switch used in simulation to determine what data gets passed
        numSettlingLaps                  % Must be at least 1 (I don't reccomend less than 3 though).
        height                           % Initial course width
        width                            % Initial course height
        refAreaWing                      % Wing reference area
        refAreaRudder                    % Rudder reference area
        J                                % Moment inertia about body fixe z axis
        initializationBasisParameters
        initTwist                        % Initial twist angle, compliment to velocity angle
        initVelocityGFS                  % Initla velocity in ground fixe spherical coords
        AR                               % Aspect ratio of the main wing
        modelPath                        % Path to the model
        wingTable                        % Aerodynamic table for the main wing
        rudderTable                      % Aerodynamic table for the rudder
        useablePower                     % Useable power for this design, defined from wikipedia
        initPositionGFS                  % Initial position in ground fixed spherical coordinates
        saveFile                         % File name of the resulting data file
        savePath                         % Path to the resulting data file
        windVariantName                  % String describing the wind variant
        firstOptimizationIterationNum    % Have to calculate this because the if block doesn't accept "+" operator
        spatialILCWeightingMatrix
        basisParameterNormalizationFactors
        trustRegionDimensions
        refAreaRotor
    end

    methods
        function val = get.refAreaRotor(obj)
            val = pi*(obj.rotorDiameter/2)^2 ;
        end
        function val = get.basisParameterNormalizationFactors(obj)
            val = [obj.azimuthNormalizationFactor obj.zenithNormalizationFactor];
        end
        function val = get.trustRegionDimensions(obj)
            val = [obj.azimuthDistanceLim obj.zenithDistanceLim];
        end
        function val = get.firstOptimizationIterationNum(obj)
            val = obj.numInitializationLaps+obj.numSettlingLaps+1;
        end
        function val = get.runModeSwitch(obj)
            switch lower(obj.runMode)
                case 'grid'
                    val = 2;
                otherwise
                    val = 1;
            end
        end
        function val = get.numSettlingLaps(obj)
            switch lower(obj.runMode)
                case 'baseline'
                    val = inf;
                case 'optimization'
                    val = 5;
                case 'grid'
                    val = 10;
                otherwise
                    val = 5;
            end
        end
        function val = get.numInitializationLaps(obj)
            val = size(obj.initializationBasisParameters,1);
        end
        % Functions to initialize the waypoints
        function val = get.height(obj)
            switch lower(obj.ic)
                case '1'%
                    val = 20;
                case '2'%
                    val = 15;
                case '3'%
                    val = 15;
                case 'custom'
                    val = 10;
                otherwise
                    val = obj.height;
            end
        end
        function val = get.width(obj)
            switch lower(obj.ic)
                case '1'%
                    val = 130;
                case '2'%
                    val = 150;
                case '3'%
                    val = 60;
                case 'custom'
                    val = 110;
                otherwise
                    val = obj.width;
            end
        end
        % Functions for saving data
        function val = get.savePath(obj)
            val = fullfile(fileparts(obj.modelPath),'data',filesep);
        end
        function val = get.windVariantName(obj)
            switch obj.windVariant
                case 1
                    val = 'Constant';
                case 2
                    val = 'Archer';
                case 3
                    val = 'NREL';
            end
        end
        function val = get.saveFile(obj)
            val = sprintf('%s_%s_%s_%s.mat',obj.ic,lower(obj.windVariantName),obj.runMode,datestr(now,'ddmm_hhMMss'));
        end
        function val = get.refAreaWing(obj)
            val = obj.refLengthWing*obj.wingSpan; % Reference area of wing
        end
        function val = get.refAreaRudder(obj)
            val = obj.refLengthRudder*obj.rudderSpan; % Reference area of wing
        end
        function val = get.J(obj) % Rotational inertia about body fixed z axis (approx with (ml^2)/12))
            JWing       = (obj.mass*obj.massFractionWing    *obj.wingSpan^2)/12;
            JFuselage   = (obj.mass*obj.massFractionFuselage*obj.momentArm^2)/3;
            JRudder     = (obj.mass*obj.massFractionRudder  *obj.momentArm^2);
            val = JWing + JFuselage + JRudder;
        end
        function val = get.initializationBasisParameters(obj)
            val = [...
                obj.width + obj.azimuthOffset obj.height;...
                obj.width                     obj.height+obj.zenithOffset;...
                obj.width - obj.azimuthOffset obj.height;...
                obj.width                     obj.height-obj.zenithOffset;...
                obj.width obj.height;...
                ];
        end
        function val = get.initTwist(obj)
            val = atan2(-obj.height,obj.width/2);
        end
        function val = get.initPositionGFS(obj)
            val = [obj.tetherLength 0  (pi/2)-obj.elev*pi/180]; % Initial position in spherical coordinates
        end
        function val = get.initVelocityGFS(obj)
            % Initial velocity in GFS
            val(1) = 0 ;
            val(2) = (obj.initVelocity*cos( obj.initTwist))/...
                (obj.initPositionGFS(1)*sin(obj.initPositionGFS(3)));
            val(3) = (obj.initVelocity*sin(-obj.initTwist))/(obj.initPositionGFS(1));
        end
        function val = get.AR(obj)
            val = obj.wingSpan/obj.refLengthWing;
        end
        function val = get.modelPath(obj)
            val = which([obj.modelName '.slx']);
        end
        function val = get.wingTable(obj)
            val =  buildAirfoilTable(obj,'wing');
        end
        function val = get.rudderTable(obj)
            val = buildAirfoilTable(obj,'rudder');
        end
        function val = get.useablePower(obj)
            % Useable power for this design
            % https://en.wikipedia.org/wiki/Crosswind_kite_power
            val = (2/27)*obj.rho*obj.refAreaWing*obj.wingTable.kl1*(max(obj.wingTable.cl./obj.wingTable.cd))^2*obj.vWind^3;
        end
    end
end