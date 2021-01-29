function [amplitude_band, CenterFreq] = fft(signal, CenterFreq, OctaveBand, Fs)
%FFT Compute the amplitude band of the FFT of the signal.
% You can specify the Center Frequency, Fractional octave band (1/3 is default) 
% and the Sample Rate (48000 Hz is default)
% The output amplitude value will be in dBFS unit.
%   
%   USAGE: 
%   [amplitude_band] = fft(signal) return the PowerBand  values
%   using CenterFreq = ISO226:2003, 1/3 octave band and Fs = 48000Hz
%
%   [amplitude_band] = fft(signal, CenterFreq)
%   [amplitude_band] = fft(signal, CenterFreq, OctaveBand)
%   [amplitude_band] = fft(signal, CenterFreq, OctaveBand, Fs)
%
%    Or with two output arguments:
%   [amplitude_band, CenterFreq] = fft(signal, CenterFreq, OctaveBand, Fs)

    % Check if the CenterFreq vector is valid:
    if (nargin < 2 || isempty(CenterFreq))
        CenterFreq = mix.Defined.FREQ_BANDS;
    end
    
    % Check if the Octave Band is valid:
    if (nargin < 3 || isempty(Fs))
        OctaveBand = 1/3;
    end

    % Check if the Sample Rate (Fs) is valid:
    if (nargin < 4 || isempty(Fs))
        Fs = mix.Defined.SAMPLE_RATE;
    end
    
    % Length of signal
    L = length(signal);   

    % FFT:
    Y = fft(signal);

    % Compute the two-sided spectrum P2.
    P2 = abs(Y/L);
    
    % Then compute the single-sided spectrum P1 based on P2 and the even-valued signal length L.
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    
    % Generate the frequency vector:
    freq = Fs * (0:(L/2)) / L;

    % Preallocate the PowerPerBand vector:
    amplitude_band = zeros(length(CenterFreq), 1);
    
    % Half of the band: 1/6 octave band
    half_band = OctaveBand / 2;
    
    for i = 1:length(CenterFreq)
        % The 'freq_indices' is a vector that contains boolean/logical
        % values to each frequency of full spectral range
        % Now we cath only the frequencies that are inside the desired
        % band. To do that we divide the desired band(i) in two equal sides:
        % half_band above and half_band below the center frequency
        freq_indices = (freq < CenterFreq(i)*2^(half_band)) & (freq > CenterFreq(i)*2^(-half_band));
        
        % Then we calculate the amplitude of the all frequencies inside the
        % desired band(i):
        amplitude_band(i) = mean( P1(freq_indices) );
    end
end