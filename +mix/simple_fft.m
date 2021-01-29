function [freq, P1] = simple_fft(signal, Fs)
%SIMPLE_FFT Return a single-side amplitude spectrum
%
%   USAGE: [freq, P1] = simple_fft(signal)
%          [freq, P1] = simple_fft(signal, Fs)


    % Check if the Sample Rate (Fs) is valid:
    if (nargin < 2 || isempty(Fs))
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
end