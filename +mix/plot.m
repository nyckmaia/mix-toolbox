function [h] = plot(varargin)
%PLOT plot 1/3 octave FFT of the signal
%   To use this function, firt cumpute the FFT of the signal using mix.fft
%   function. Use that output as input arguments of the mix.plot function.
%   
%   USAGE: 
%   h = plot(amplitude) plot 1/3 octave FFT of the signal
%   using Fs = 48000 Hz.
%
%   h = plot(amplitude, y_scale) being that 'y_scale' must be set to
%   'linear' or 'dbfs'.
%
%   h = plot(freq, amplitude, y_scale) being that 'freq' is the output frequency
%   vector of the mix.fft function.

    switch (nargin)
        case 1
            freq = mix.Defined.FREQ_BANDS;
            amplitude = varargin{1};
            y_scale = 'dbfs';
            
        case 2
            freq = mix.Defined.FREQ_BANDS;
            amplitude = varargin{1};
            y_scale = varargin{2};
            
        case 3
            freq = varargin{1};
            amplitude = varargin{2};
            y_scale = varargin{3};
                 
        otherwise
            error('You must set the right arguments');
    end

    if (strcmp(y_scale, 'linear'))
        % Use linear Y amplitude scale:
        
        % Plot:
        h = semilogx(freq, amplitude);

        % Define plot limits:
        axis ([min(freq) max(freq) 0 max(amplitude)]);

        % Configure X axis Ticks:
        set(gca, 'Xtick', freq);
        set(gca, 'XtickLabel', mix.Defined.FREQ_BANDS_LABEL);
        % Configure X axis Grid:
        set(gca, 'XMinorGrid','off');
        set(gca, 'XMinorTick','off');
        grid on;

        title('Amplitude Spectrum')
        xlabel('1/3 Octave Band Frequencies (Hz)')
        ylabel('Amplitude (linear)')
    else
        % Use dBFS Y amplitude scale:
        
        % Change linear amplitude values to dBFS scale just to be easy to
        % see on plot:
        amp_db = arrayfun(@(a) mix.amp2dbfs(a), amplitude);

        % Plot:
        h = semilogx(freq, amp_db);

        % Define plot limits:
        axis ([min(freq) max(freq) min(amp_db) 0]);

        % Configure Y axis Ticks:
        set(gca, 'Ytick', mix.Constant.Y_TICKS_FFT);
        set(gca, 'YtickLabel', mix.Constant.Y_TICKS_FFT_LABELS);
        % Configure X axis Ticks:
        set(gca, 'Xtick', freq);
        set(gca, 'XtickLabel', mix.Defined.FREQ_BANDS_LABEL);
        % Configure X axis Grid:
        set(gca, 'XMinorGrid','off');
        set(gca, 'XMinorTick','off');
        grid on;

        title('Amplitude Spectrum')
        xlabel('1/3 Octave Band Frequencies (Hz)')
        ylabel('Amplitude (dBFS)')
    end
    
end


