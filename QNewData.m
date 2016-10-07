function QNewData(src,Sg,Tm)

src.queueOutputData(Sg)
dTm=datevec(now-Tm); % now returns current date and time as a serial number
disp(sprintf('%0.04f',dTm(4)*60*60+dTm(5)*60+dTm(6)))