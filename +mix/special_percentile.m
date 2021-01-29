function [value] = special_percentile(X, percentile)
%SPECIAL_PERCENTILE Return a percentile value of the elements inside the vector
%
%   USAGE:
%   [value] = special_percentile(X, percentile)

    % Get the length of the X vector:
    len = length(X);
    
    % Round percentile value:
    ind = floor(percentile/100*len);
    
    % Sort X vector:
    newarr = sort(X);
    
    % Get the percentile value:
    value = newarr(ind);
end