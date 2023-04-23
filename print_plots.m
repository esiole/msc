function print_plots(L, T, F, X, wavelet_matrix)
    intensity = sum(wavelet_matrix);

    figure('Name', 'Исходный ряд')
    plot(T, F, 'b-');

    figure('Name', 'Восстановленный ряд')
    plot(T, X, 'r-', 'LineWidth', 1)
    grid on
    xticks(T(1:L:end));

    tick_labels = [];
    for a = T(L + 1 : L : length(T))
        tick_labels = [tick_labels, datestr(a)];
    end

    figure('Name', 'Вейвлет-преобразование')
    imagesc(wavelet_matrix)
    grid on
    xlim([0 length(intensity)])
    xticks(0:L:length(F))
    xticklabels(tick_labels)
    ylabel('scales');

    figure('Name', 'Оценка интенсивности аномалий')
    plot(1:length(intensity), intensity, 'LineWidth', 1)
    grid on
    xlim([0 length(intensity)])
    xticks(0:L:length(F))
    xticklabels(tick_labels);

    figure('Name', 'Обнаруженные аномалии')
    subplot(2, 1, 1)
    imagesc(wavelet_matrix)
    grid on
    xlim([0 length(intensity)])
    xticks(0:L:length(F))
    xticklabels(tick_labels)
    ylabel('scales')
    subplot(2, 1, 2)
    plot(1:length(intensity), intensity, 'LineWidth', 1)
    grid on
    xlim([0 length(intensity)])
    xticks(0:L:length(F))
    xticklabels(tick_labels);

end