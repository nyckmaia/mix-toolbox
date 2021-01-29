function [signal] = gain(signal, db)
%GAIN Add/Reduce gain (dB) of the given signal
%
%   USAGE:
%   [signal] = gain(signal, db)

coder.inline('never');

    % Amplitude gain ratio:
    ratio = mix.dbfs2amp(db);
    
    % Future max power:
    max_amplitude = max(abs(signal * ratio));
    
    % Check audio cliping:
    if (max_amplitude <= mix.Constant.MAX_AMPLITUDE)
        signal = signal * ratio;
    else
        error('Msg: Audio would cliping adding %f dB. \nNo gain was applied.', db)
    end
    
end

