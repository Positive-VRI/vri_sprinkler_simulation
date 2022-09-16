function [v2,t2] = resample_time(t,v,dt)
  n = length(t);
  if (length(v) ~= n) 
    error(['t and v must have equal size: length t ' num2str(length(t)) ' v ' num2str(length(v))]);
  end
  if (rows(t) > columns(t))
    warning('use row vectors: t is transposed');    
    t = t';
  end
  if (rows(v) > columns(v))
    warning('use row vectors: v is transposed');    
    v = v';
  end
  dt_val = t(2:n) - t(1:n-1);
  dv_val = v(2:n) - v(1:n-1);
  dn_val = [1 ceil(dt_val ./ dt)];
  n2 = sum(dn_val);
  idx = cumsum(dn_val);
  t2 = t(1);
  v2 = v(1);
  for k=2:n
    inc = (1:dn_val(k)) / dn_val(k);
    t2 = [t2, t(k-1) + inc .* dt_val(k-1)];
    v2 = [v2, v(k-1) + inc .* dv_val(k-1)];
  end
end