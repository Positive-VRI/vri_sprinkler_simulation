function [Grid,idx_unique,inc_unique] = grid_increment(Grid,irow,icol,inc)
  if (rows(irow) ~= rows(icol) | columns(irow) ~= columns(icol) |...
      rows(irow) ~= rows(inc) | columns(irow) ~= columns(inc))
      disp(['irow: ' num2str(rows(irow)) ' x ' num2str(columns(irow))]);
      disp(['icol: ' num2str(rows(icol)) ' x ' num2str(columns(icol))]);
      disp(['inc: ' num2str(rows(inc)) ' x ' num2str(columns(inc))]);
      error(['irow, icol and inc must have the same size']);
  end
  rg = rows(Grid);
  cg = columns(Grid);
  %row_col_inc_indices = [irow' icol' inc']
  % Selects the pairs of indices (irow, icol) s.t. they are inside the grid limits. 
  in_range = find(1 <= irow & irow <= rg & 1 <= icol & icol <= cg);
  irow = irow(in_range);
  icol = icol(in_range);
  inc = inc(in_range);
  %row_col_inc_indices_in_range = [irow' icol' inc']
  
  % It performs the following operations:
  % 1) transform the pairs of indices (irow, icol) to the vector idx of single indices 
  % 2) remove the repeated values of idx and store them in idx_unique;
  %    j(k) = position of item k-th of idx, i.e. idx(k), in idx_unique
  %      idx_unique(j) == idx
  %    Note: vector inc has the same size of inc! 
  % 3) find 
  idx = sub2ind(size(Grid),irow,icol); 
  [idx_unique,i,j] = unique(idx); 
  %tab_j_inc = [j, inc]
  inc_unique = accumdim(j, inc);
  Grid(idx_unique) = Grid(idx_unique) + inc_unique;
end