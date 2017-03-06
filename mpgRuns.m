% used for testing fluorescent sequence aquisition

% run experiment
session = daq.createSession('ni');
session.addAnalogOutputChannel('cDAQ1Mod1',0,'Voltage');
session.addAnalogOutputChannel('cDAQ1Mod1',1,'Voltage');
session.Rate = Signal{1};
session.IsContinuous = true;

Jen_RunPressure(Signal, 'NDSequence', 9);



% halt pressure in fluc vials
session = daq.createSession('ni');
session.addAnalogOutputChannel('cDAQ1Mod1',0,'Voltage');
session.addAnalogOutputChannel('cDAQ1Mod1',1,'Voltage');

Jen_CalibPressure(session,0,0);
disp(['zeroPressure! ',datestr(now)]);