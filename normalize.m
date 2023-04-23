function [vector] = normalize(vector)
    vector = vector - mean(vector);
    vector = vector / std(vector, 1);
end