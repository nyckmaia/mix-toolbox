classdef track < handle    
    %TRACK Define the audio track object
    %   The track object will store the signal and
    %   all metadata of the audio file
    %   
    %   You must define the track object type:
    %   'audio file': individual audio file
    %   'mix': summing track signals into stereo format
    %   'master': copy a mix track and modify it
    %
    %   USAGE: mix.track('audio file', audio_file_meta)
    %          mix.track('mix', 'Track Name', sum_audio_vector)
    %          mix.track('master', 'Track Name', stereo_audio_vector)
    %
    %   Where:
    %   'audio_file_meta' is a struct that contains: 'name' and 'metadata'
    %   fields
    %
    %   'sum_audio vector' is usually a vector that contains a audio track sum
    %
    %   'stereo_audio_vector' is usually a vector that contains a stereo
    %   audio samples
    %
    %   Obs.: The easy way to import audio files is: 
    %   [track] = mix.multi_audioread();
    
    properties
        name = '';
        pan = 0;
        metadata = '';
        loud_start = 0;
        loud_finish = 0;
        signal = [];
        volume = [];
        eq = [];
        spectral_contribution = [];
        high_pass_freq = 20;
    end
    
    
    properties (SetAccess = private)
        peak = [];
        spectrum = [];
        loudness = [];
        signal_rms = [];
        comp = struct('threshold', 0, 'ratio', 1);
        band_weigth = [];
        reso = [];
        player;
    end
    
    
    methods 
        
        function this = track(varargin)
            %CONSTRUCTOR Construct an instance of this class
            % Init the track object:
            
            % Check if is just preallocating or filling with audio data:
            if(nargin ~= 0)
                switch(varargin{1})
                    case 'audio file'
                        %% Create a track object of 'audio file' type:
                        
                        % Get the 'file object':
                        file = varargin{2};
                        
                        % We are importing a Wav audio file:
                        fprintf("Loading: %s \n", file.name);
                        
                        % Get the track name without the audio extension:
                        this.name = file.name(1:end-4);
                        
                        % Get file metadata:
                        this.metadata = audioinfo(file.name);
                        
                        % Get the signal:
                        if(this.metadata.NumChannels == mix.Constant.Mono)
                            % Read the Mono audio file:
                            [mono_signal, Fs] = audioread(file.name);
                            
                            % Split the mono channel to left and right channels:
                            this.signal = [mono_signal/2 mono_signal/2];
                        else
                            % Read the stereo audio file:
                            [this.signal, Fs] = audioread(file.name);
                        end
                        
                        % Check audio file sample rate:
                        if (Fs ~= mix.Defined.SAMPLE_RATE)
                            error('The sample rate of the file %s (%d Hz) is different of the project sample rate (%d Hz)\n', this.name, Fs, mix.Defined.SAMPLE_RATE);
                        end
                                                
                    case 'mix'
                        %% Create a track object of 'mix' type:
                        
                        % Set mix name:
                        this.name = varargin{2};
                        
                        % Set and normalize the mix signal:
                        this.signal = mix.norm(varargin{3});
                        
                             
                    case 'master'
                        %% Create a track object of 'master' type:
                        
                        % Set master name:
                        this.name = varargin{2};
                        
                        % Set and normalize the mix signal:
                        this.signal = mix.norm(varargin{3});
                        
                    otherwise
                        error('The track type must be: audio file, mix or master');
                end
                
                % Get the Loudness Curve:
                [loud_idx, loudness] = mix.loudness(this.signal);
                        
                % Get mix amplitude spectrum:
                [~, this.spectrum, this.loud_start, this.loud_finish] = mix.loud_spectrum(this.signal, loud_idx, loudness);
                
                % Get the absolute peak value:
                this.peak_update();
                        
                % Get the RMS value:
                this.rms_update();
                
                % Create a audio player for listen the signal:
                this.player = audioplayer(this.signal, mix.Defined.SAMPLE_RATE, mix.Defined.BIT_DEEP);
                
            else
                % Only for preallocating a empty track object case.
                % This is necessary only for create a track object vector
                % in optimizated way 
            end
            
            
        end
    end
    
    methods %(Access = private)
        %% GET THE TRACK LOUD SPECTRUM:
        function this = fft(this)
            fprintf("%s: Doing FFT (Loud Section) \n", this.name);
            % Get the track spectrum of the music loudest section:
            this.spectrum = mix.fft(this.signal(this.loud_start:this.loud_finish));
        end
        
        %% APPLY VOLUME CHANGES:
        function this = apply_volume(this)
            
            fprintf("%s: Applying the track volume change \n", this.name);
            
            % Apply volume into the track signal:
            % Eq. 16
            this.signal = this.signal * this.volume(end);
            
            % Apply volume into the spectrum curve:
            this.spectrum = this.spectrum * this.volume(end);
            
            % Peak Update:
            this.peak_update();
            
        end

        %% PEAK UPDATE::
        function this = peak_update(this)
            fprintf("%s: Updating Peak value...\n", this.name);
            % Eq. 12
            this.peak(end+1) = max(abs(this.signal(:)));
        end
        
        %% RMS UPDATE:
        function this = rms_update(this)
            fprintf("%s: Updating RMS value...\n", this.name);
            % Eq. 11
            this.signal_rms(end+1) = rms(this.signal(:, mix.Constant.LEFT));
        end
        
        %% RATIO UPDATE:
        function this = compressor_update(this)
            fprintf("%s: Updating Ratio value...\n", this.name);
            
            % Define the compressor threshold:
            this.comp.threshold(end+1) = floor(mix.amp2dbfs(this.signal_rms(end)));

            % Define the compressor ratio:
            % Eq. 15:            
            this.comp.ratio(end+1) = this.peak(end) / this.signal_rms(end);
            
        end
        
        %% BAND WEIGTH UPDATE:
        function this = band_weigth_update(this)
            fprintf("%s: Updating band weigth value...\n", this.name);
            
            % Get the number of bands:
            num_bands = length(mix.Defined.FREQ_BANDS);
            
            % Sum energy of each band of this track:
            total_energy_spectrum = sum(this.spectrum);
            
            % Compute the normalized weigth for each band:
            for band = 1:num_bands
                % Eq. 7
                this.band_weigth(band) = this.spectrum(band) / total_energy_spectrum;
            end
        end
        
        %% RESONANT FREQUENCIES UPDATE:
        function [this] = reso_freqs_update(this, num_reso_freqs)
    
            fprintf('%s: Finding Resonant Frequencies... \n', this.name);
        
             % Get the Loudness Curve:
            [loud_idx, this.loudness] = mix.loudness(this.signal);
        
            % Find the vector index of max loudness:
            loud_peak_idx = loud_idx(this.loudness == max(this.loudness));
        
            % Window to meassure loudness (samples):
            loud_window = mix.Defined.SAMPLE_RATE * mix.Defined.TRACK_LOUD_DURATION;
        
            % Find the loud section sample interval:
            start = (loud_window * (loud_peak_idx - 1)) + 1;
            finish = loud_peak_idx * loud_window;
        
            % Find the audio section of the given loudness:
            loud_section = this.signal(start:finish, :);
            
            % Get the resonant band central frequencies, ratio and q factor:
            reso_matrix = mix.find_resonant_frequencies(loud_section, num_reso_freqs);
            
            % Update object properties:
            this.reso.freq = reso_matrix(:, 1)';
            this.reso.q_factor = reso_matrix(:, 2)';
            this.reso.ratio = reso_matrix(:, 3)';        
        end
        
        %% REMOVE UNDESIRED FREQUENCIES:
        function [this] = remove_undesired_frequencies(this)
            
            fprintf('%s: Removing undesired frequencies... \n', this.name);
            
            % Remove undesired frequencies of the audio signal:
            % We put the minus signal before the 'ratio' because in this
            % case we want to reduce the gain in this frequencies
            this.signal = mix.parametric_eq(this.signal, ...
                this.reso.freq, ...
                this.reso.q_factor, ...
                -this.reso.ratio, ...
                this.high_pass_freq, ...
                mix.Defined.HIGHPASS_SLOPE);
            
            % Spectrum update:
            this.spectrum = this.fft();
        end
        
        %% APPLY COMPRESSOR:
        function [this] = apply_compressor(this)
            
            fprintf('%s: Applying the compressor settings... \n', this.name);
            
            % Init the compressor object:
            dRC = compressor( ...
                this.comp.threshold(end), ...
                this.comp.ratio(end), ...
                'MakeUpGainMode', 'Auto', ...
                'SampleRate', mix.Defined.SAMPLE_RATE);
            
            % Visualize the compressor transfer function:
            %visualize(dRC)
            
            this.signal = dRC(this.signal);
                        
            % Update the peak value:
            this.peak_update();
            
            % Update the RMS value:
            this.rms_update();
            
            % release the compressor object:
            release(dRC)
        end
        
        %% PLOT SPECTRUM:
        function [] = plot_spectrum(this, y_scale)
            switch (nargin)
                case 1
                    mix.plot(this.spectrum);
                case 2
                    mix.plot(this.spectrum, y_scale);
                otherwise
                    error('PLOT SPECTRUM: You must set the right arguments');
            end
            
        end
        
        %% BOUNCE:
        function [] = bounce(this, path, sample_rate, bit_deep)
            
            % Check if the 'bit_deep' string is valid:
            if (nargin < 4 || isempty(bit_deep))
                bit_deep = mix.Defined.BIT_DEEP;
            end
            
            % Check if the 'sample_rate' string is valid:
            if (nargin < 3 || isempty(sample_rate))
                sample_rate = mix.Defined.SAMPLE_RATE;
            end
            
            % Check if the 'path' string is valid:
            if (nargin < 2 || isempty(path))
                path = mix.Defined.BOUNCE_PATH;
            end
            
            % Check if the user writed 'path' correctly:
            if (~strcmp(path(end), '/'))
                % Add a slash bar in the end of 'path' string
                path = strcat(path, '/');
            end
            
            % Add the file name and audio extension to the bounce path:
            full_path = strcat(path, this.name, '.wav');

            % Bounce audio to disk:
            audiowrite(full_path, this.signal, sample_rate, 'BitsPerSample', bit_deep);
            
            % Print: Done!
            fprintf('%s: Bounce: Done! \n', this.name);
        end
        
        %% PLAY SOUND:
        function [] = play(this)
            play(this.player);
        end
        
        %% STOP SOUND:
        function [] = stop(this)
            stop(this.player);
        end
    end   
end

