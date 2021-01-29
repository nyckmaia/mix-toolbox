function [reso_freq] = track_reso_freqs(track, num_reso_freqs, loud_duration)
%TRACK_RESO_FREQS Remove the resonante frequencies of each track signal
%   The output is a 3D matrix [Freq x Ratio x Q Factor] x Track:
%   'Freq' is the resonant band Central Frequency
%   'Ratio' is the amplitude (dB) of the resonant band
%   'Q Factor' is related with the frequency range of the resonant band
%   'Track' is the audio track number
%
%   USAGE:
%   [reso_freq] = track_reso_freqs(track, num_reso_freqs)
%   [reso_freq] = track_reso_freqs(track, num_reso_freqs, loud_duration)


    % Check if the loud_duration is valid:
    if (nargin < 3 || isempty(loud_duration))
        loud_duration = mix.Defined.TRACK_LOUD_DURATION;
    end
    
    fprintf('-----> Resonant Frequencies Process: Start <----- \n');
    
    % Get the number of tracks:
    num_files = length(track);
    
    % Preallocate a 3D matrix: Resonant frequencies X Ratio X Track:
    reso_freq = zeros(num_reso_freqs, 3, num_files);
    
    for tk = 1:num_files
        
        fprintf('%s: Finding Resonant Frequencies... \n', track(tk).name);
        
        % 1.2.1: Get the Loudness Curve:
        [loud_idx, loudness] = mix.loudness(track(tk).signal);
        
        % Find the vector index of max loudness:
        loud_peak_idx = loud_idx(loudness==max(loudness));
        
        % Window to meassure loudness (samples):
        loud_window = mix.Defined.SAMPLE_RATE * loud_duration;
        
        % Find the loud section sample interval:
        start = (loud_window * (loud_peak_idx - 1)) + 1;
        finish = loud_peak_idx * loud_window;
        
        % Find the audio section of the given loudness:
        loud_section = track(tk).signal(start:finish, :);
        
        % Get the resonant frequencies, ratio and frequency range for each track:
        reso_freq(:, :, tk) = mix.find_resonant_frequecies(loud_section, num_reso_freqs);
    end
    
    fprintf('-----> Resonant Frequencies Process: Done! <----- \n');
end