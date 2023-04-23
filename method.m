function method(T, F, L, I)
    signal = ssa(F, L, I);
    wavelet_matrix = wavelet_transform(signal, L, 2.5);
    print_plots(L, T, F, signal, wavelet_matrix);
end