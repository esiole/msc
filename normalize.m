function [X] = normalize(X)
    X = X - mean(X);
    X = X / std(X, 1);
end