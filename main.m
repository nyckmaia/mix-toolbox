% Compute the elapsed time to processing all things:
start_processing = tic;

%% PART 1.0: 
% 1.0: Read multiple audio files:
[track] = mix.multi_audioread();

% Number of files:
num_files = length(track);

% 1.1: Sum/Mix all signals:
initial_mix = mix.track('mix', 'Initial Mix', mix.sum(track));

%% PART 1.3: Create a reference signal
% 1.3.1: Set the signal generator variables:
white = 0;
pink = 1;

% 1.3.2: Init the signal generator:
generator = dsp.ColoredNoise(pink, (mix.Defined.SAMPLE_RATE * mix.Defined.MIX_LOUD_DURATION));
reference.signal = generator();

% 1.3.3: Normalize reference signal:
reference.signal = mix.norm(reference.signal);

% 1.3.4: Get the 1/3 octave spectrum power:
reference.spectrum = mix.fft(reference.signal);

%% PART 1.5: Set the start/finish points into the track objects:
% 1.5.1: Get the spectrum of each track:
for tk = 1:num_files
    % Set the start/finish loud section points:
    track(tk).loud_start = initial_mix.loud_start;
    track(tk).loud_finish = initial_mix.loud_finish;
    
    % Get the amplitude spectrum of each track:
    track(tk).fft();
end

%% PART 4: Calculate the ideal volume for each track:
% 4.1: Get the minimum amplitude difference between reference and track spectrum:
for tk = 1:num_files
    % Eq. 17:
    track(tk).volume = min(reference.spectrum ./ track(tk).spectrum);

    % Apply volume in the signal:
    track(tk).apply_volume();
end

% 4.2: Sum all signals:
temp_mix = mix.track('mix', 'Temp Mix', mix.sum(track));

% 4.4: Find de maximum spectral difference between the 'temp mix' and the reference:
% Eq. 18:
[over, over_idx] = max(temp_mix.spectrum - reference.spectrum);

% 4.5: Get the amplitude spectrum value for the 'over_idx' band:
over_peak = temp_mix.spectrum(over_idx);

% 4.6: Calculate the volume difference between track and mix spectrum of the 'over_idx' band:
for tk = 1:num_files
    
    % Eq. 19:   
    track(tk).volume(end+1) = 1 - (over/over_peak);
        
    % Apply the volume diference
    track(tk).apply_volume();
end

% 4.8: Sum all signals:
before_comp_mix = mix.track('mix', 'Before Compression', mix.sum(track));

%% Teste de compressao:
for tk = 1:num_files
    
    % Store the RMS before compression:
    track(tk).rms_update();
        
    % Get the threshold and ratio parameters for each track:
    track(tk).compressor_update();
    
    % Apply compressor to the signal:
    track(tk).apply_compressor();
end

%% Mix signals after compression:
% Sum all signals:
after_comp_mix = mix.track('mix', 'After Compression', mix.sum(track));

%% PART 5: Spectral Balance/Correction for each track:

% Get the number of bands:
num_bands = length(mix.Defined.FREQ_BANDS);

for tk = 1:num_files
    
    % Calculate the spectral contribution of the track for the mix:
    % Eq. 20:
    for band = 1:num_bands
        track(tk).spectral_contribution(band) = track(tk).spectrum(band) / after_comp_mix.spectrum(band);
    end
    
    % 5.1: Calculate the band weigth of each track:
    track(tk).band_weigth_update();
    
    % Is better?
    % Calculate the highpass cutoff frequency for each track:
    per_value = mix.special_percentile(track(tk).band_weigth, mix.Defined.PERCENTILE);
    % Set the 'high pass freq' object propertie with the 1/3 octave
    % percentile value:
    %track(tk).high_pass_freq = mix.Defined.FREQ_BANDS(track(tk).band_weigth == per_value);
    % Is better?
    track(tk).high_pass_freq = mix.Defined.FREQ_BANDS(track(tk).band_weigth == max(track(tk).band_weigth));
    
    % Get the resonant frequencies:
    track(tk).reso_freqs_update(mix.Defined.NUM_RESO_FREQ);
    
    % Remove undesired frequencies: resonant frequencies and high pass:
    track(tk).remove_undesired_frequencies();
end

% 5.2: Calculate the equalization values for each track:
mix.track_eq(track, reference, after_comp_mix);

% 5.3: Apply the spectral correction:
mix.apply_eq(track);

%% PART 6: Final Mix Equalized
% Sum all signals:
final_eq_mix = mix.track('mix', 'Final Eq Mix', mix.sum(track));

%% Show the total elapsed time to processing:
fprintf('Total Elapsed Time: %.2f minutes \n', toc(start_processing) / 60);