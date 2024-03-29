function [F] = ssa(F, L, I)
    F = normalize(F);

    % Stage 1: Decomposition
    % Step 1: Embedding

    N = length(F);
    if L > N / 2 then
        L = N - L;
    end
    K = N - L + 1;
    
    % Time-delayed embedding of y, the trajectory matrix
    X = zeros(L, K);
    for i = 1 : K
        X(:, i) = F(i : i + L - 1);
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
    F = zeros(N, 1);
    for i = 1 : K + L - 1
        v = adiag(X, i);
        F(i) = sum(v) / length(v);
    end
    
    F = real(F);
end