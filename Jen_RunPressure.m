function Jen_RunPressure(Signal,FlName,MxTime)

% Jen_RunPressure(Signal,FlName,MxTime)
% Signal = {rate,data}
% FlName = name of nd2 file (without ".nd2")
% MxTime = max length of run (in hrs)

session = daq.createSession('ni');
%Select which channels you want to use
session.addAnalogOutputChannel('cDAQ1Mod1',0,'Voltage');
session.addAnalogOutputChannel('cDAQ1Mod1',1,'Voltage');
session.Rate = Signal{1};
session.IsContinuous = true;

Time0=now;
%Initiate Buffer
session.queueOutputData(Signal{2});
lh = session.addlistener('DataRequired', @(src,event)...
     QNewData(src,Signal{2},Time0));


if ~isempty(FlName)  
disp('Waiting for File Initialization...\n');
while ~exist([FlName,'.nd2'])
end
end
Time0=now;
disp(['Running! ',datestr(Time0)])
session.startBackground();


dT=datevec(now-Time0);
dTm=dT(4)+dT(5)/60+dT(6)/(60*60);
while(dTm<MxTime)
    pause(60);  % shortening the pause to 20 during a 20 sec period run prolongs it!
    % commenting out the pause kills the run even faster than pause(60)
    dT=datevec(now-Time0);
    dTm=dT(4)+dT(5)/60+dT(6)/(60*60);
end
    
session.stop()
delete(lh)

%Reinitialize Pressure
session.queueOutputData(Signal{2});
session.startBackground();
session.stop()

disp(['Ended! ',datestr(now)])