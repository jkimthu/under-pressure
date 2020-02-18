function SgO=Jen_CreateSignal_glycogen(Mn, DiffHigh, DiffLow, XTime, Rate)

% last update: jen, 2018 Oct 02
% commit: 4:50 low, 0:10 high, 0:10 low (5min 10 sec total)

% last update: jen, 2018 Nov 23
% newest: 4:50 low, 0:30 high, 0:10 low (5min 30 sec total)   

% Mn = mean pressure into device
% DiffHigh = pressure input such that higher fluid overtakes lower
% DiffLow = pressure input (absolute value) such that lower fluid overtakes
% XTime = leave empty ('[]') to approximate max smooth slope
% shiftHour = time of upshift in hours
% maxTime = full signal duration in hours
% rate = signal inputs per second
% 


% 1. calculate transition signal and timing
if isempty(XTime)
    MaxSlope = 2; %V/s
    w = MaxSlope/((abs(DiffLow)+abs(DiffHigh))/2);
    XTime = pi/(2*w);
    t = 0:pi/(round(XTime*Rate)-1):pi;
    transitionSignal=(1-cos(t'))/2;
    disp(sprintf('Transition time: %0.03f',XTime))
else
    t = 0:pi/(round(XTime*Rate)-1):pi;
    transitionSignal = (1-cos(t'))/2;
end


% 3. adjust time in phase 1 and phase 2 based on transition timing, so that transition fits
% phase 1 = 4:50 low
% phase 2 = 0:10 high
% phase 3 = 0:10 low
phase1_raw = 4*(60)+ 50;      % raw time of phase 1 in seconds
%phase2_raw = 10;
phase2_raw = 30;
phase3_raw = 10;

phase1_time = round((phase1_raw-(XTime))*Rate); % adjusted for transition
phase2_time = round((phase2_raw-(XTime))*Rate);
phase3_time = phase3_raw*Rate;



% 5. build saturated sections of signal
signalLow1 = [ones(phase1_time,1)*(Mn-DiffLow),ones(phase1_time,1)*(Mn+DiffLow)];
signalHigh = [ones(phase2_time,1)*(Mn+DiffHigh),ones(phase2_time,1)*(Mn-DiffHigh)];
signalLow2 = [ones(phase3_time,1)*(Mn-DiffLow),ones(phase3_time,1)*(Mn+DiffLow)];


% 6. build transitions (two total: up and down)of signal
transition_downshift = [(Mn+DiffHigh)-(DiffLow+DiffHigh)*transitionSignal,(Mn-DiffHigh)+(DiffHigh+DiffLow)*transitionSignal];
transition_upshift = transition_downshift(end:-1:1,:);


% 7. concatenate and output signal
oneSignal = [];
oneSignal = [signalLow1; transition_upshift; signalHigh; transition_downshift; signalLow2];


% 8. display full signal
disp(sprintf('\nFinal Parameters:'))
disp(sprintf('Phase1 (low): %0.03f s',length(signalLow1)/Rate))
disp(sprintf('Transition: %0.03f s',XTime))
disp(sprintf('Phase2 (high): %0.03f s',length(signalHigh)/Rate))
disp(sprintf('Transition: %0.03f s',XTime))
disp(sprintf('Phase1 (low): %0.03f s',length(signalLow2)/Rate))
disp(sprintf('Total Time: %0.03f s',size(oneSignal,1)/Rate))
disp(sprintf('Signal length: %0.03f',size(oneSignal,1)))



figure(1)
clf
plot([1:length(oneSignal)]/Rate/3600,oneSignal) % in hours
xlabel('time (hr)')
ylabel('calibration value')
title('full signal')


% 9. because signal is shorter than 15 min (900 sec), concatentate to generate longer signal
secondsOfSignal = size(oneSignal,1)/Rate;

Sg = [];
if secondsOfSignal < 900
    numSignals2Repeat = ceil(900/secondsOfSignal);
    for i = 1:numSignals2Repeat
        Sg = [Sg;oneSignal];
    end
else
    Sg = oneSignal;
end


% 10. output Signal data for running experiment
SgO{1} = Rate;
SgO{2} = Sg;
