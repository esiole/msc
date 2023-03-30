function print_plots(title, L, t, y, z, rez, sumNM)
    step = L;

    figure('Name', strcat('Исходный ряд. ', title))
    plot(t, y, 'b-');

    figure('Name', strcat('Восстановленный ряд. ', title))
    plot(t, z, 'r-', 'LineWidth', 1)
    grid on
    xticks(t(1:step:end));

    
    ticksValues = [];
    for a = t(L+1:step:length(t))
        ticksValues = [ticksValues, datestr(a)]
    end

    figure('Name', strcat('Восстановленный ряд. ', title))
    h = subplot(1,1,1);
    %grid on;
    imagesc(rez);
    set(gca);
    set(h,'XGrid','on','YGrid','on','XLim',[0 length(sumNM)],'XTick', 0:step:length(y), 'XTickLabel', ticksValues);
    ylabel('scales');

    figure('Name', strcat('Восстановленный ряд. ', title))
    plot(1:length(sumNM), sumNM, 'LineWidth', 1)
    grid on
    xlim([0 length(sumNM)])
    xticks(0:step:length(y));
    xticklabels(ticksValues);


    figure('Name', strcat('Восстановленный ряд. ', title))
    h1=subplot(2,1,1);
    %grid on;
    imagesc(rez);
    set(gca);
    set(h1,'XGrid','on','YGrid','on','XLim',[0 length(sumNM)],'XTick', 0:step:length(y), 'XTickLabel', {});
    ylabel('scales');
    subplot(2,1,2);
    %grid on;
    plot(1:length(sumNM), sumNM, 'LineWidth', 1)
    grid on;
    xlim([0 length(sumNM)])
    xticks(0:step:length(y));
    xticklabels(ticksValues);

end