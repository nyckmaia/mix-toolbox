function [] = apply_eq(track)
%APPLY_EQ Apply the spectral correction for each track
%   Update the track signal applying the 'eq' vector property 
% using a individual audio equalizer for each track object

    % Get the number of tracks:
    num_tracks = length(track);
    
    % Init the graphicEQ Object:
    equalizer = graphicEQ( ...
        'Bandwidth','1/3 octave', ...
        'Structure','Cascade', ...
        'SampleRate',mix.Defined.SAMPLE_RATE);
    
    % Apply the equalizer correction for each track:
    for tk = 1:num_tracks
        % Get the last 30 positions of the track.eq vector:
        equalizer.Gains = track(tk).eq(2:31);
        
        % Apply the eq in the signal:
        track(tk).signal = equalizer(track(tk).signal);
        
        % Update the track spectrum:
        track(tk).fft();
    end

end

