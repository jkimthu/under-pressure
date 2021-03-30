function Jen_RunPressure_upshift(Signal,FlName,MxTime)

% last edit: 2018 Aug 02
% commit: accommodate edited CreateSignal_single_upshift function, which
%         provides a third vector with how to break up signal based on timing
% 

% Signal = {rate, fullSignal, assignments to divide signal into 15 min fragments}
% FlName = name of nd2 file (without ".nd2")
% MxTime = max length of run (in hrs) -- needs to match with what was used
%          to create signal

session = daq.createSession('ni');
session.addAnalogOutputChannel('cDAQ1Mod1',0,'Voltage'); %Select which channels you want to use
session.addAnalogOutputChannel('cDAQ1Mod1',1,'Voltage');
%session.addAnalogInputChannel()... to measure pressure from regulators
session.Rate = Signal{1};
session.IsContinuous = true;


 % wait for presence of nd2 file in current folder
 if ~isempty(FlName)
     disp('Waiting for File Initialization...\n');
     while ~exist([FlName,'.nd2'])
     end
 end

% upon nd2 file creation... 
% now = reports current date and time as date time array
Time0=now;                          % generate timestamp for start of session
disp(['Running! ',datestr(Time0)])  % report start and timestamp

% Initiate initial signal to dAQ
session.queueOutputData(Signal{2});

% Initiate listener, which will run in background forever until stopped
lh = session.addlistener('DataRequired', @(src,event)QNewData(src,Signal{2},Time0));
session.startBackground();          % begin running signal

% subtract start time from current time
dT=datevec(now-Time0);

% calculate time in hours since start of session 
dTm=dT(4)+dT(5)/60+dT(6)/(60*60);

% repeat signal while time since start < designated end time
while(dTm < MxTime)
    pause(60);
    dT=datevec(now-Time0);
    dTm=dT(4)+dT(5)/60+dT(6)/(60*60);
end

% once max time is exceeded...
session.stop()
delete(lh) % stop listener

%Reinitialize Pressure
%session = daq.createSession('ni');
%session.addAnalogOutputChannel('cDAQ1Mod1',0,'Voltage');
%session.addAnalogOutputChannel('cDAQ1Mod1',1,'Voltage');
%Jen_CalibPressure(session,0,0)

disp(['Ended! ',datestr(now)])