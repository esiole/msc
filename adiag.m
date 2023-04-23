function [vector] = adiag(matrix, index)
	[nrows, ncols] = size(matrix);
	N = nrows + ncols - 1;
    length = min(min(index, N - index + 1), min(nrows, ncols));
	i = max(index, nrows * (index - nrows + 1));
	step = nrows - 1;
	vector = matrix(i : step : i + step * length - 1);
end