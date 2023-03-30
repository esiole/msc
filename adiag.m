function [v] = adiag(x, z)
	[N, M] = size(x);
	Z = N + M - 1;
    z_len = min(min(z, Z - z + 1), min(N, M));
	i = max(z, N * (z - N + 1));
	step = N - 1;
	v = x(i : step : i + step * z_len - 1);
end