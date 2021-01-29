function [mix] = mix(varargin)
%MIX Mix/Sum any set of signals
%   Returns the sum of the signals.
%   Each input signal must be formated like: [n rows, 1 collumn]
%
%   USAGE:
%   [mix] = mix(varargin)

    %% Calculate the output signal length:
    
    % Preallocate a vector to store the original length of the all signals:
    original_length = zeros(nargin, 1);
    
    % Store the length of the given signals:
    for i = 1:nargin
        original_length(i) = length(varargin{i});  
    end
    
    % Get the max length of the signals:
    max_length = max(original_length);

    %% Generate output signal:
    % Preallocate the output signal:
    mix = zeros(max_length, 1);
    
    % Mix/Sum all signals
    for i = 1:nargin
        % We need to be sure that all signals have the same vector length.
        % If there is a signal with smaller dimension, we complete white
        % zeros at the end of the vector
        zeros_complete = length(mix) - length(varargin{i});
        mix(:, i) = [varargin{i}; zeros(zeros_complete, 1)];
    end
    
    % Sum each collum to generate the output signal
    mix = sum(mix, 2);
end