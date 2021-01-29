function [window_idx, loudness] = loudness(signal, loud_duration, Fs)
%LOUDNESS Return a of Integrated Loudness of the mono/stereo signal
%    Output a loudness vector and a matrix that stores the middle time period of
%    the each loudness value and the number of the window analysed
%   
%    The 'loud_duration' input argument is in seconds
%
%   USAGE:
%   [time, window_idx, loudness] = loudness(signal, loud_duration, Fs)

    %% Check the input arguments:
    if (nargin < 2 || isempty(loud_duration))
        % Set the default Loudness Window Duration (seconds):
        loud_duration = mix.Defined.MIX_LOUD_DURATION;
    end

    if (nargin < 3 || isempty(Fs))
        Fs = mix.Defined.SAMPLE_RATE;
    end

    %% Match the loudness window and signal lengths
    % Window to meassure loudness (samples):
    loud_window = Fs * loud_duration;

    % Find the rest samples of windowing:
    rest_samples = mod(length(signal), loud_window);

    % Rest samples:
    complete_samples = loud_window - rest_samples;
    
    % Create matrix of zeros (0 x mono/stereo):
    zero_vec = zeros(complete_samples, size(signal, 2));

    % Append zeros_vec in the end of signal:
    signal = [signal; zero_vec];

    % Number of windows:
    num_windows = length(signal) / loud_window;

    %% Calculate the loudness of each loudness window:
    % Preallocate loudness vector:
    loudness = zeros(num_windows, 1);
    
    % Preallocate middle time vector:
    window_idx = zeros(num_windows, 1);

    % Get loudness values for each second of signal:
    for i = 1:num_windows
        
        % Store the analysed window:
        window_idx(i) = i;
        
        % Set interval of samples to analize the loudness:
        start = (loud_window * (i-1)) + 1;
        finish = (i) * loud_window;

        % Find the audio section of the inverval above:
        section = signal((start:finish), 1:end);

        % Get the loudness value of this interval:
        loudness(i) = integratedLoudness(section, mix.Defined.SAMPLE_RATE);
    end
end

