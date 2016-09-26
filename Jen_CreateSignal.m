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

TB=round((Period-2*XTime)/4*Rate);
TS=round((Period-2*XTime)/2*Rate);

SgB=[ones(TB,1)*(Mn+DiffB),ones(TB,1)*(Mn-DiffB)];
SgS=[ones(TS,1)*(Mn-DiffS),ones(TS,1)*(Mn+DiffS)];

SgT=[(Mn+DiffB)-(DiffS+DiffB)*SgTrn,(Mn-DiffB)+(DiffB+DiffS)*SgTrn];
SgT2=SgT(end:-1:1,:);

Sg=[SgB;SgT;SgS;SgT2;SgB];
% Sg=Sg(:,2:-1:1);

disp(sprintf('\nFinal Parameters:'))
disp(sprintf('Buffer: %0.03f s',length(SgB)/Rate))
disp(sprintf('Transit: %0.03f s',XTime))
disp(sprintf('Nutrient: %0.03f s',length(SgS)/Rate))
disp(sprintf('Transit: %0.03f s',XTime))
disp(sprintf('Buffer: %0.03f s',length(SgB)/Rate))
disp(sprintf('Total Time: %0.03f s',size(Sg,1)/Rate))

SgO{1}=Rate;
SgO{2}=Sg;

figure(1)
clf
plot([1:length(Sg)]/Rate,Sg)
