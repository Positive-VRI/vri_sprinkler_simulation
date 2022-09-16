function [yOut,xOut] = interpolate_time(xIn,yIn,xOut)
  nIn = length(xIn);
  if (length(yIn) ~= nIn) 
    error(['tIn and vIn must have equal size: length tIn ' num2str(length(t)) ' v ' num2str(length(v))]);
  end
  if (rows(xIn) > columns(xIn))
    warning('use row vectors: xIn is transposed');    
    xIn = xIn';
  end
  if (rows(yIn) > columns(yIn))
    warning('use row vectors: yIn is transposed');    
    yIn = yIn';
  end
  if (rows(xOut) > columns(xOut))
    warning('use row vectors: xOut is transposed');    
    xOut = xOut';
  end
  % Computes for each xOut(k) the index of the first value
  % xIn(idxPrev(k)) s.t. xOut(xIn(idxPrev(k))) < xOut(k) 
  % E.g.  
  %   xIn = [0 1.5 3.0 5.0 7.2 9.4]
  %   xOut = [-1 0 1 2 3 4 5 6 7 8 9 10]
  %   idxPrev = [1 2 2 3 4 4 5 5 5 6 6 7]
  %     index 7 is out of bound of xIn (lenght(xIn) == 6)
  %   xIn(idxPrev) = 1 0 0 1 2 2 3 3 3 4 4 5]
  idxPrev = nIn - sum(xOut < xIn');
  idxNext = idxPrev+1;
  idxUnder = find(idxPrev < 1);
  idxPrev(idxUnder) = 1;
  idxOver = find(idxNext > nIn);
  idxNext(idxOver) = nIn;
  t = (xOut - xIn(idxPrev)) ./ (xIn(idxNext) - xIn(idxPrev));
  t(idxUnder) = 1.0;
  t(idxOver) = 0.0;
  yOut = yIn(idxPrev) + t .* (yIn(idxNext) - yIn(idxPrev));
end