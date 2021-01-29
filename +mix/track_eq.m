function [] = track_eq(track, reference, mixed)
%TRACK_EQ Calculate the amplitude gain (dB) of each band for each track
%   Update the 'eq' property of the track object

    % Get the number of tracks:
    num_tracks = length(track);
    % Get the number of bands:
    num_bands = length(mix.Defined.FREQ_BANDS);
    
    %% ==========
    % 3.2: Difference between the reference spectrum and the mixed spectrum:
    % Eq. 21:
    eq_diff = reference.spectrum ./ mixed.spectrum;
    
    % Compute the eq values for each band for each track:
    for tk = 1:num_tracks
        for band = 1:num_bands
            % Calculate the spectral contribuition of each band:
            % Eq. 22:
            linear_eq = eq_diff(band) * track(tk).spectral_contribution(band);
            
            % Convert the linear amplitude value to db unit:
            track(tk).eq(band) = mix.amp2dbfs(linear_eq);
        end  
        
        % Remove unnecessary gain:
        % Eq. 23:
        track(tk).eq = track(tk).eq - min(track(tk).eq);
        
        % Limit the max gain to +6dB:
        % Eq. 24:
        track(tk).eq(track(tk).eq > mix.Defined.MAX_SPECTRAL_DISTORTION) = 0;
    end
    
end

