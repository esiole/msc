file = 'data/data_all_period.csv';
title = ' Весь период (27.10.2021 - 04.11.2021)';
T = readtable(file);
L = 1440;
I = [1, 2, 3]; % Компоненты, которые будут участвовать в восстановлении ряда

t = T.start_date_time;
y = T.RCORR_P;

z = ssa(y, t, L, I);

[rez, sumNM] = set_rez(L, 2.5, z);

print_plots(title, L, t, y, z, rez, sumNM);