function s=Jen_CalibPressure(session,Mn,Dff)

if nargin==2
Dff=Mn;
Mn=session;

session = daq.createSession('ni');
session.addAnalogOutputChannel('cDAQ1Mod1',0,'Voltage');
session.addAnalogOutputChannel('cDAQ1Mod1',1,'Voltage');
end

Rt=1000;
T=.1;
session.Rate = Rt;

session.queueOutputData([ones(T*Rt,1)*(Mn+Dff),ones(T*Rt,1)*(Mn-Dff)]);
session.startForeground();

if nargout==1
    s=session;
end