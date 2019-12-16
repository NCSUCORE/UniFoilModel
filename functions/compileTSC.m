function tsc = compileTSC(logsout)
% function to extract all timeseries into a structure called "tsc"

signals = logsout.getElementNames;

for ii = 1:length(signals)
    
    eval(sprintf('tsc.%s = logsout.getElement(''%s'').Values;',...
        replace(signals{ii},{'<','>'},''),signals{ii}))
    
end

end

