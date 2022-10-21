function [yOut,xOut] = interpolate_3_linear(xA,xB,yA,yB,xPerc,yPerc,xOut)
  if (rows(xOut) > columns(xOut))
    warning('use row vectors: xOut is transposed');    
    xOut = xOut';
  end
  if (xPerc < 0.0 | xPerc > 0.5 | yPerc < 0.0 | yPerc > 0.5)
    disp(['invalid parameters xPerc ' num2str(xPerc) ' or yPerc ' num2str(yPerc)]);    
    disp('0 <= xPerc <= 0.5 AND 0 <= yPerc <= 0.5');
    error('invalid parameters xPerc or yPerc');
  end
  
  dxAB = (xB-xA);
  dyAB = (yB-yA);
  xA2 = xA + xPerc * dxAB;
  xB2 = xB - xPerc * dxAB;
  yA2 = yA + yPerc * dyAB;
  yB2 = yB - yPerc * dyAB;
  dBorder = (dyAB * yPerc) / (dxAB * xPerc);
  dMiddle = (dyAB * (1-2*yPerc)) / (dxAB * (1-2*xPerc));
  
  % For simplicity, we use the normalized. 
  %   t = 
  % Smooth function intervals:
  %  y1(x) = 
  %  y2(x) = xA2 + dMid * x      xA2 <= x <= xB2;
##  enable1 = (xA <= xOut & xOut < xA2)
##  enable2 = (xA2 <= xOut & xOut <= xB2)
##  enable3 = (xB2 < xOut & xOut <= xB)
##  yOut1 = yA + dBorder .* (xOut - xA)
##  yOut2 = yA2 + dMiddle .* (xOut - xA2)
##  yOut3 = yB2 + dBorder .* (xOut - xB2)
##  yOut = enable1 .* yOut1 + enable2 .* yOut2 + enable3 .* yOut3;
  idx1 = find(xA <= xOut & xOut < xA2);
  idx2 = find(xA2 <= xOut & xOut <= xB2);
  idx3 = find(xB2 < xOut & xOut <= xB);
  xOut1 = xOut(idx1);
  xOut2 = xOut(idx2);
  xOut3 = xOut(idx3);
  yOut1 = yA + dBorder .* (xOut1 - xA);
  yOut2 = yA2 + dMiddle .* (xOut2 - xA2);
  yOut3 = yB2 + dBorder .* (xOut3 - xB2);
  xOut = [xOut1, xOut2, xOut3];
  yOut = [yOut1, yOut2, yOut3];
end