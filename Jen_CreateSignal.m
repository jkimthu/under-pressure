function SgO=Jen_CreateSignal(Mn, DiffB, DiffS, XTime, Period, Rate)
% SignalOut=Jen_CreateSignal(Mn, DiffB, DiffS, XTime, Period, Rate)
% Period in Seconds, Rate in samples/seconds
% leave XTime empty ('[]') to use approximate max smooth slope

if isempty(XTime)
    MxSlop=2; %V/s
    w=MxSlop/((abs(DiffS)+abs(DiffB))/2);
    XTime=pi/(2*w);
    t=0:pi/(round(XTime*Rate)-1):pi;
    SgTrn=(1-cos(t'))/2;
    disp(sprintf('Transition time: %0.03f',XTime))
else
    t=0:pi/(round(XTime*Rate)-1):pi;
    SgTrn=(1-cos(t'))/2;
end

% length of buffer and signal sections
% TB is twice as short, as it is repeated twice (sandwiching TS)
TB=round((Period-2*XTime)/4*Rate);
TS=round((Period-2*XTime)/2*Rate);

% build sections of pressure signal
SgB=[ones(TB,1)*(Mn+DiffB),ones(TB,1)*(Mn-DiffB)];
SgS=[ones(TS,1)*(Mn-DiffS),ones(TS,1)*(Mn+DiffS)];

% build transitions (two total: up and down)
SgT=[(Mn+DiffB)-(DiffS+DiffB)*SgTrn,(Mn-DiffB)+(DiffB+DiffS)*SgTrn];
SgT2=SgT(end:-1:1,:);

% putting it all together for one full period
onePeriod=[SgB;SgT;SgS;SgT2;SgB];

% if period is shorter than 15 minutes (900 sec),
% concatentate to generate longer signal
Sg = [];
if Period < 900
    numPeriodsPerSignal = ceil(900/Period);
    for i = 1:numPeriodsPerSignal
        Sg = [Sg;onePeriod];
    end
else
    Sg = onePeriod;
end


% display signal period output
disp(sprintf('\nFinal Parameters:'))
disp(sprintf('Buffer: %0.03f s',length(SgB)/Rate))
disp(sprintf('Transit: %0.03f s',XTime))
disp(sprintf('Nutrient: %0.03f s',length(SgS)/Rate))
disp(sprintf('Transit: %0.03f s',XTime))
disp(sprintf('Buffer: %0.03f s',length(SgB)/Rate))
disp(sprintf('Total Time: %0.03f s',size(onePeriod,1)/Rate))

SgO{1}=Rate;
SgO{2}=Sg;

figure(1)
clf
plot([1:length(onePeriod)]/Rate,onePeriod)
