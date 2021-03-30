function runPressure(Signal,FlName,MxTime)

% last edit: 2021 March 29
% commit: rename function to be less narcissistic

% Jen_RunPressure(Signal,FlName,MxTime)
% Signal = {rate,data}
% FlName = name of nd2 file (without ".nd2")
% MxTime = max length of run (in hrs)


% initialize RunPressure with this 5 lines manually
session = daq.createSession('ni');
session.addAnalogOutputChannel('cDAQ1Mod1',0,'Voltage'); %Select which channels you want to use
session.addAnalogOutputChannel('cDAQ1Mod1',1,'Voltage');
session.Rate = Signal{1};
session.IsContinuous = true;
%


Time0=now; % now reports current date and time as date time array

%Initiate Buffer
session.queueOutputData(Signal{2});
lh = session.addlistener('DataRequired', @(src,event)...
     QNewData(src,Signal{2},Time0));

 % wait for presence of nd2 file in current folder
 if ~isempty(FlName)
     disp('Waiting for File Initialization...\n');
     while ~exist([FlName,'.nd2'])
     end
 end

% upon nd2 file creation... 
Time0=now;                          % generate timestamp for start of session
disp(['Running! ',datestr(Time0)])  % report start and timestamp
session.startBackground();          % begin running signal

% subtract start time from current time
dT=datevec(now-Time0);

% calculate time in hours since start of session 
dTm=dT(4)+dT(5)/60+dT(6)/(60*60);

% repeat signal while time since start < designated end time
while(dTm<MxTime)
    pause(60);
    dT=datevec(now-Time0);
    dTm=dT(4)+dT(5)/60+dT(6)/(60*60);
end

% once max time is exceeded...
session.stop()
delete(lh)

% commented out June 26, 2019
% for single shift experiments

%Reinitialize Pressure
%session = daq.createSession('ni');
%session.addAnalogOutputChannel('cDAQ1Mod1',0,'Voltage');
%session.addAnalogOutputChannel('cDAQ1Mod1',1,'Voltage');
%Jen_CalibPressure(session,0,0)

disp(['Ended! ',datestr(now)])