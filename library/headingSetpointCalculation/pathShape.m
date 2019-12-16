function [azimuth,zenith] = pathShape(basisParams,meanElev,s)

azimuth = (basisParams(1)/2)*cos((3/2+2*s)*pi);
elev    = (basisParams(2)/2)*sin((3/2+2*s)*2*pi)+meanElev;
zenith  = pi/2-elev;

end
