classdef Defined
   properties (Constant)
       
       SAMPLE_RATE = mix.Constant.Fs_48K; % number
       
       BIT_DEEP = mix.Constant.Bit_Deep_24_bits; % number
       
       FREQ_BANDS = mix.Constant.F20_20K; % number vector
       
       FREQ_BANDS_LABEL = mix.Constant.F20_20K_freq_label; % string
       
       MIX_LOUD_DURATION = mix.Constant.mix_loud_duration_10; % seconds
       
       TRACK_LOUD_DURATION = mix.Constant.track_loud_duration_5; % seconds
       
       MAX_RESONANT_FREQ = 2000; % Hz
       
       MIN_RESONANT_FREQ = 50; % Hz
       
       STEP_RESONANT_FREQ = 2; % Hz
       
       EQ_PEAK_THRESHOLD = 6; % dB
       
       MAX_SPECTRAL_DISTORTION = 6; % 6 dB
       
       FRAME_LENGTH = mix.Constant.FRAME_LENGTH_512; % Samples
       
       PERCENTILE = mix.Constant.PERCENTILE_90; % Percent
       
       NUM_RESO_FREQ = mix.Constant.NUM_RESO_FREQ_3; % Number
       
       HIGHPASS_SLOPE = mix.Constant.HIGHPASS_SLOPE_6; % [dB/ocatve]
              
       MAX_Q_FACTOR = mix.Constant.MAX_Q_FACTOR_50; % [adimensional]
       
       BOUNCE_PATH = mix.Constant.BOUNCE_PATH; % String
    
   end
end


