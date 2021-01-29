function [signal] = norm(signal)
%NORM Normalize the signal between [-1 +1]
%
%   USAGE:
%   [signal] = norm(signal)

    if (size(signal, 2) == mix.Constant.Mono)
        % Normalize Mono signal between [-1 +1]
        signal = signal / max(abs(signal));    
    else
        % Normalize Stereo signal between [-1 1];
        Left = signal(:, mix.Constant.LEFT) / max(abs(signal(:, mix.Constant.LEFT)));
        Right = signal(:, mix.Constant.RIGHT) / max(abs(signal(:, mix.Constant.RIGHT)));
    
        signal = [Left Right];
    end
end

