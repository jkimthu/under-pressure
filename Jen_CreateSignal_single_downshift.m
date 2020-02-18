function SgO=Jen_CreateSignal_single_downshift(Mn, DiffHigh, DiffLow, XTime, shiftHour, maxTime, Rate)

% last update: jen, 2018 Aug 02
% commit: initiates shift down in nutrient at designated time

% Mn = mean pressure into device
% DiffHigh = pressure input such that higher fluid overtakes lower
% DiffLow = pressure input (absolute value) such that lower fluid overtakes
% XTime = leave empty ('[]') to approximate max smooth slope
% shiftHour = time of upshift in hours after running signal
% maxTime = full signal duration in hours
%           note: to run experiment longer than maxTime, maintain pressure
%                 after signal ends such that high continues to flow until
%                 experiment is taken down/liquid runs out.
% Rate = signal inputs per second


% 1. convert time of shift to seconds
shiftSeconds = shiftHour * 3600;                     % time of shift in seconds


% 2. calculate time in seconds after shift
secondsAfterShift = (maxTime * 3600) - shiftSeconds; % time remaining after shift in seconds


% 3. calculate transition signal and timing
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


% 4. adjust time in high and low based on transition timing, so that transition fits
phase2_time = round((secondsAfterShift-(XTime/2)));
phase1_time = round((shiftSeconds-(XTime/2)));


% 5. build saturated sections of signal
signalLow = [ones(phase2_time*Rate,1)*(Mn-DiffLow),ones(phase2_time*Rate,1)*(Mn+DiffLow)];
signalHigh = [ones(phase1_time*Rate,1)*(Mn+DiffHigh),ones(phase1_time*Rate,1)*(Mn-DiffHigh)];



% 6. build transitions (two total: up and down)of signal
transition_downshift = [(Mn+DiffHigh)-(DiffLow+DiffHigh)*transitionSignal,(Mn-DiffHigh)+(DiffHigh+DiffLow)*transitionSignal];
transition_upshift = transition_downshift(end:-1:1,:);


% 7. concatenate and output signal
fullSignal = [];
fullSignal = [signalHigh;transition_downshift;signalLow];


% 8. display full signal
disp(sprintf('\nFinal Parameters:'))
disp(sprintf('Phase1 (high): %0.03f s',length(signalHigh)/Rate))
disp(sprintf('Transition: %0.03f s',XTime))
disp(sprintf('Phase2 (low): %0.03f s',length(signalLow)/Rate))
disp(sprintf('Total Time: %0.03f s',size(fullSignal,1)/Rate))
disp(sprintf('Signal length: %0.03f s',size(fullSignal,1)))

figure(1)
clf
plot([1:length(fullSignal)]/(Rate*3600),fullSignal) % in hours
xlabel('time (hr)')
ylabel('calibration value')
title('full signal')


% 9. break signal into bite sized pieces (15 min)
numFragments = (length(fullSignal))/(15*60); % 15 min in seconds
signalFragments = ceil((1:length(fullSignal))/numFragments);

% 10. output Signal data for running experiment
SgO{1} = Rate;
SgO{2} = fullSignal;
SgO{3} = signalFragments';