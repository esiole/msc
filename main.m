% ssa('data_normal.csv', ' Спокойное время (27.10.2021 - 29.10.2021)');
% ssa('data_before_storm.csv', ' Перед бурей (01.11.2021 - 03.11.2021)');
% ssa('data_storm.csv', ' Буря (02.11.2021 - 04.11.2021)');
% ssa('data_all_period.csv', ' Весь период (27.10.2021 - 04.11.2021)');
% ssa('march.csv', ' Март (01.03.2022 - 31.03.2022)');

% ssa('oulu_oct_2021.csv', ' OULU 08.10.2021 - 19.10.2021'); % L = 1440
% ssa('thul_may_2019.csv', ' THUL 01.05.2019 - 13.05.2019'); % L = 1440
% ssa('invk_may_2019.csv', ' INVK 01.05.2019 - 13.05.2019'); % L = 1440
% ssa('thul_may_2_2019.csv', ' THUL 23.05.2019 - 30.05.2019'); % L = 1440
% ssa('invk_may_2_2019.csv', ' INVK 23.05.2019 - 30.05.2019'); % L = 1440
 ssa('data/sopo_may_2_2019.csv', ' SOPO 23.05.2019 - 30.05.2019'); % L = 1440

function ssa(file, title)
    T = readtable(file);

    L = 1440;                   % Длина окна (1440 записей = 1 день)
    %L = 720;                   % Длина окна (720 записей = 1 день)
    step = L;
    
    I = [1, 2, 3];              % Компоненты, которые будут участвовать в восстановлении ряда

    N = length(T.RCORR_P);      % Длина исходного ряда
    t = (1:N)';
    t = T.start_date_time;
    y = normalize(T.RCORR_P);
    % y = T.RCORR_P;
    
    ticksValues = [];
    for a = t(L+1:step:length(t))
        ticksValues = [ticksValues, datestr(a)]
    end

    %figure('Name', strcat('Исходный ряд. ', title))
    %plot(t, y, 'b-');

    % Stage 1: Decomposition
    % Step 1: Embedding

    N = length(y);
    if L > N / 2 then
        L = N - L;
    end
    K = N - L + 1;

    % Time-delayed embedding of y, the trajectory matrix
    X = zeros(L, K);
    for i = 1 : K
        X(:, i) = y(i : i + L - 1);
    end

    % Step 2: Singular value decomposition
    C = X * X' / K; % Covariance matrix

    [U, LAMBDA] = svd(C);
    LAMBDA = sqrt(diag(LAMBDA));    % The eigenvalues of C are the squared eigenvalues of X

    % Principal components
    V = X' * U;
    for i = 1 : L
        V(:, i) = V(:, i) / LAMBDA(i);
    end

    [K, L] = size(V);
    N = K + L - 1;

    % Stage 2: Reconstruction
    % Step 3: Grouping

    LAMBDA_U = U(:, I);
    for i = I
        LAMBDA_U(:, i) = LAMBDA(i) * U(:, i);
    end

    X = LAMBDA_U(:, I) * V(:, I)';  % Reconstructed components

    % Step 4: Diagonal averaging
    y = zeros(N, 1);
    for i = 1 : K + L - 1
        v = adiag(X, i);
        y(i) = sum(v) / length(v);
    end
    y = real(y);
    
    disp(t(1:step:end));
    figure('Name', strcat('Восстановленный ряд. ', title))
    plot(t, y, 'r-', 'LineWidth', 1)
    grid on
    xticks(t(1:step:end));
    
    [rez, sumNM] = setREZ(L, 2.5, y);
    figure('Name', strcat('Восстановленный ряд. ', title))
    h=subplot(1,1,1);
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

function [X] = normalize(X)
    X = X - mean(X);    % remove mean value
    X = X / std(X, 1);  % normalize to standard deviation 1 
end
    
function [v] = adiag(x, z)
	[N, M] = size(x); 
	Z = N + M - 1;
	z_len = min(min(z, Z - z + 1), min(N, M));
	i = max(z, N * (z - N + 1));
	step = N - 1;
	v = x(i : step : i + step * z_len - 1);
end

function [REZ, sumNM] = setREZ(windL,T_p,A1)
    signal2=padarray(A1,5760,'sym','both'); 
    Fs = 0.016; 
    fc = centfrq('coif2');
    freqrange = [0.000005 0.016 ]; 
    scalerange = fc./(freqrange*(1/Fs));
    scales = scalerange(end):1:scalerange(1); 
    Coeffs = cwt(signal2,scales,'coif2'); 
    Coeffs=Coeffs'; 
    coefftest=Coeffs(5760:length(signal2)-5760,:); 
    coefftest=coefftest'; 
    for q=1:length(scales) 
        for i=1:length(A1)  
            m(1,i)=coefftest(q,i);
        end 
        z=1;
        while z <= length(A1)- windL   
            dSR = mean(m(z:z+windL-1));  
            dMED=median(m(z: windL-1+z));
            sm=0;
            for k=z: windL-1+z              
                sm=sm+(m(k)- dSR)*( m(k)- dSR);
            end
            St= sqrt((1/windL)*sm);            
            Pad=T_p*St;             
            n=1;
            dMOD = abs(abs(m(z+windL))- dMED);      
            if dMOD > Pad               
                REZ(q,z)= m(z+windL);
            else
                REZ(q,z)=0;
            end
        z=z+1;
        end
    end
    sumNM = sum(REZ);
end