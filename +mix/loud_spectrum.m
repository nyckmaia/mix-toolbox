function [CenterFreq, amplitude, start, finish] = loud_spectrum(signal, loud_idx, loudness, loud_duration)
%LOUD_SPECTRUM Compute the FFT of the audio only in the loudest section
%   'loud_idx' is a vector with loudness indices for each loudness value
%   'loudness' is a vector with loudness values
%   'loud_duration' is in seconds and must be the same of the loudness
%   function computation
%   'start' output argument is the loudest start sample point of the signal
%   'finish' output argument is the loudest finish sample point of the
%   signal
%
%   USAGE:
%   [CenterFreq, amplitude] = loud_spectrum(signal, loud_idx, loudness)
%   [CenterFreq, amplitude] = loud_spectrum(signal, loud_idx, loudness, loud_duration)
%   [CenterFreq, amplitude, start, finish] = loud_spectrum(signal, loud_idx, loudness, loud_duration)

    % Check if the loud_duration is valid:
    if (nargin < 4 || isempty(loud_duration))
        loud_duration = mix.Defined.MIX_LOUD_DURATION;
    end

    % Find the vector index of max loudness:
    loud_peak_idx = loud_idx(loudness==max(loudness));

    % Window to meassure loudness (samples):
    loud_window = mix.Defined.SAMPLE_RATE * loud_duration;

    % Find the loud section sample interval:
    start = (loud_window * (loud_peak_idx - 1)) + 1;
    finish = loud_peak_idx * loud_window;

    % Find the audio section of the given loudness:
    loud_section = signal(start:finish, :);

    % Calculate the power mean for each band:
    [amplitude, CenterFreq] = mix.fft(loud_section);
end

