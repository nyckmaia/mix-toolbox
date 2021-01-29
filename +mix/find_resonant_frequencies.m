function [main_reso_band] = find_resonant_frequencies(signal, num_reso_bands, low_freq, high_freq, step_freq)
%FIND_RESONANT_FREQUENCIES Find resonant frequencies of the audio signal
%   The output is a 2D matrix [Center Freq x Q Factor X Ratio]:
%   'Central Freq' is the resonant band Central Frequency [Hz]
%   'Q Factor' is related with the frequency range of the resonant band
%   'Ratio' is the amplitude (dB) of the resonant band
%
%   USAGE:
%   [main_reso_band] = find_resonant_frequecies(signal, num_reso_bands)
%   [main_reso_band] = find_resonant_frequecies(signal, num_reso_bands, low_freq, high_freq, step_freq)

    % Check if the step_freq is valid:
    if (nargin < 5 || isempty(step_freq))
        step_freq = mix.Defined.STEP_RESONANT_FREQ;
    end

    % Check if the high_freq is valid:
    if (nargin < 4 || isempty(high_freq))
        high_freq = mix.Defined.MAX_RESONANT_FREQ;
    end
    
    % Check if the low_freq is valid:
    if (nargin < 3 || isempty(low_freq))
        low_freq = mix.Defined.MIN_RESONANT_FREQ;
    end
    
    
    % Init the Parametric Eq:
    mPEQ = multibandParametricEQ( ...
        'NumEQBands', 1, ...
        'Frequencies', 50, ...
        'QualityFactors', 10, ...
        'PeakGains', 18, ...
        'SampleRate', mix.Defined.SAMPLE_RATE);

    % Get the peak (dBFS) of the original signal:
    original_peak = mix.amp2dbfs(max(abs(signal(:))));
    
    % Define the number of scanned frequencies in specific frequency range:
    num_scanned_freq = (high_freq - low_freq) / step_freq;
    
    % Preallocate a 3D matrix: [Freq X Ratio] X Band
    resonant = zeros(num_scanned_freq, 2, num_reso_bands);
    
    % Set the resonant frequency index to 1:
    reso_idx = 1;
    
    % Set the initial resonant frequency band to 1:
    founded_band = 1;
    
    % Eq. 10 & Eq. 14
    % Search resonant frequencies:
    for freq = low_freq:step_freq:high_freq
        
        % Update the Equalizer frequency:
        mPEQ.Frequencies = freq;
        
        % Visualize the Eq filter:
        visualize(mPEQ)
        
        % Equalize the audio signal:
        equalized_signal = mPEQ(signal);
        
        % Get the peak (dBFS) of the equalized signal:
        equalized_peak = mix.amp2dbfs(max(abs(equalized_signal(:))));
        
        % Get the peak raio (dB) between original and equalized peaks:
        peak_ratio = equalized_peak - original_peak;
        
        % Eq. 14
        % Is there a resonant frequency?:
        if (peak_ratio >= mix.Defined.EQ_PEAK_THRESHOLD)
            % We found a resonant frequency:
            
            % Get the last indice added:
            last_idx = reso_idx - 1;
            
            % Check if this 'reso_idx' is not the first element into the matrix:
            if (reso_idx ~= 1)
                % Is this frequency in the same actual band or not?:
                if(freq > (resonant(last_idx, 1, founded_band) + step_freq))
                    % We catch a new resonant band:
                    founded_band = founded_band + 1;
                    % Reset the resonant indice for a new band:
                    reso_idx = 1;
                end
            end
            
            % Store the frequency, the ratio (dB) and band in the 'resonant' 3D matrix:
            resonant(reso_idx, :, founded_band) = [mPEQ.Frequencies peak_ratio];
 
            % Keep searching resonant frequencies:
            reso_idx = reso_idx + 1;
        end
    end
    
    % Release the Eq object:
    release(mPEQ);
    
    % Set the initial number of resonant bands:
    num_requested_bands = size(resonant, 3);
    
    % Preallocate bands matrix:
    bands = zeros(num_requested_bands, 3);
    
    % Get the main frequency and ratio inside each band:
    for i = 1:num_requested_bands
        
        % Get the 2D band matrix version [Freq x Ratio]:
        band_2D = resonant(:, :, i);
        
        % Remove lines with only zeros [Freq x Ratio]:
        non_zero_band = band_2D(any(band_2D, 2), :);
            
        % Check if there is a resonant frequency inside 'non_zero_band' matrix:
        if (~nnz(non_zero_band) == 0)
            
            % Calculate the band width of each resonant band:
            band_width = max(non_zero_band(:, 1)) - min(non_zero_band(:, 1));
            
            % Calculate the Q Factor of each resonant band:
            % Eq. 9: Atualizar no PDF
            %q_factor = sqrt(2^band_width) / ((2^band_width) - 1);
            q_factor = mean(non_zero_band(:, 1)) / band_width;
            
            % Check if 'q factor' is a valid value:
            if(q_factor > mix.Defined.MAX_Q_FACTOR)
                q_factor = mix.Defined.MAX_Q_FACTOR;
            end
            
            % Calculate the Central Frequency of the resonant band:
            freq = sum(resonant(:, 1, i) .* resonant(:, 2, i)) / sum(resonant(:, 2, i));
            
            % Get the closest ratio of the Central Frequency:
            [~, freq_idx] = min(abs(freq - resonant(:, 1, i)));
        else
            % Set the band values to default:
            freq = 0;
            freq_idx = 1;
            q_factor = 10; % Narrow Q ~ 1/8 octave 
        end
     
        % Store [Central Frequency x Q Factor x Ratio] in the bands matrix:
        bands(i, :) = [freq q_factor resonant(freq_idx, 2, i)];
    end

    % Find the largest ratio of resonant bands:
    [~, main_resonant_idx] = maxk(bands(:, 2), num_reso_bands);
 
    % Get the largest resonant bands that have max ratios:
    main_reso_band = bands(main_resonant_idx, :);  
end