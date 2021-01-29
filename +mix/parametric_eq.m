function [signal_eq] = parametric_eq(varargin)
%PARAMETRIC_EQ Apply a parametric equalizer in the input signal
%   'signal' is the original signal to be equalized
%   'center_freq' is a center frequencies vector [Hz]
%   'q_factor' is a Q Factor vector
%   'gain' is a gain vector of each band [db]
%   'high_pass_freq' is the highpass cutoff frequency [Hz]
%   'high_pass_slope' is the highpass slope [db/octave]
%   'fs' is the sample rate [Hz]
%   'signal_eq' is the equalized signal
%
%   USAGE:
%   [signal_eq] = parametric_eq(signal, center_freq, q_factor, gain)
%   [signal_eq] = parametric_eq(signal, center_freq, q_factor, gain, fs)
%   [signal_eq] = parametric_eq(signal, center_freq, q_factor, gain, high_pass_freq, high_pass_slope)
%   [signal_eq] = parametric_eq(signal, center_freq, q_factor, gain, high_pass_freq, high_pass_slope, fs)

    % Set input arguments:
    signal = varargin{1};
    center_freq = varargin{2}; 
    q_factor = varargin{3};
    gain = varargin{4};
    
    % Get the number of equalizer bands:
    num_eq_bands = length(center_freq);

    switch(nargin)
        case 4
            % Set sample rate variable:
            fs = mix.Defined.SAMPLE_RATE;
            
            % Init the multiband parametric equalizer:
            mPEQ = multibandParametricEQ( ...
                'NumEQBands', num_eq_bands, ...
                'Frequencies', center_freq, ...
                'QualityFactors', q_factor, ...
                'PeakGains', gain, ...
                'SampleRate', fs);
        
        case 5
            % Set sample rate variable:
            fs = varargin{5};
            
            % Init the multiband parametric equalizer:
            mPEQ = multibandParametricEQ( ...
                'NumEQBands', num_eq_bands, ...
                'Frequencies', center_freq, ...
                'QualityFactors', q_factor, ...
                'PeakGains', gain, ...
                'SampleRate', fs);
        
        case 6
            % Set hipass filter variables:
            high_pass_freq = varargin{5};
            high_pass_slope = varargin{6};
            
            % Set sample rate variable:
            fs = mix.Defined.SAMPLE_RATE;
            
            % Init the multiband parametric equalizer:
            mPEQ = multibandParametricEQ( ...
                'NumEQBands', num_eq_bands, ...
                'Frequencies', center_freq, ...
                'QualityFactors', q_factor, ...
                'PeakGains', gain, ...
                'HasHighpassFilter',true, ...
                'HighpassCutoff', high_pass_freq, ...
                'HighpassSlope', high_pass_slope, ...
                'SampleRate', fs);
        
        case 7
            % Set hipass filter variables:
            high_pass_freq = varargin{5};
            high_pass_slope = varargin{6};
            
            % Set sample rate variable:
            fs = varargin{7};
            
            % Init the multiband parametric equalizer:
            mPEQ = multibandParametricEQ( ...
                'NumEQBands', num_eq_bands, ...
                'Frequencies', center_freq, ...
                'QualityFactors', q_factor, ...
                'PeakGains', gain, ...
                'HasHighpassFilter',true, ...
                'HighpassCutoff', high_pass_freq, ...
                'HighpassSlope', high_pass_slope, ...
                'SampleRate', fs);
            
        otherwise
            error('Wrong number of input arguments');      
    end

    
    % Check if input arguments have the same size:
    if(length(center_freq) ~= length(q_factor) ||  length(center_freq) ~= length(gain))
        error('The size of center_freq, q_factor and gain must be the same');
    end
    
    % Check the maximum possible equalizer band:
    if(length(center_freq) > 10)
        error('This equalizer have a maximum of 10 bands');
    end

    % Visualize the equalizer curve:
    visualize(mPEQ)

    % Processing singal:
    signal_eq = mPEQ(signal);
    
    % Release the multiband parametric equalizer:
    release(mPEQ)
end