classdef Constant
   properties (Constant)
       %% Sample Rate:
       Fs_44K1 = 44100;
       Fs_48K = 48000;
       
       %% Bit Deep (resolution):
       Bit_Deep_16_bits = 16;
       Bit_Deep_24_bits = 24;
       
       %% Other:
       % Input Channel Format:
       Mono = 1;
       Stereo = 2;
       
       % Stereo side:
       LEFT = 1;
       RIGHT = 2;
       
       % Max normalized audio amplitude
       MAX_AMPLITUDE = 1;
       
       % Min normalized audio amplitude
       MIN_AMPLITUDE = -1;
       
       %% Frequency Vector Types:
       % ISO 226:2003 frequency vector 1/3 octave:
       iso226freq = [20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 ...
        500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500];
       
       % Full range spectrum 1/3 octave:
       F20_20K = [20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 ...
        500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500 16000 20000];
    
       % ISO 226:2003 frequency label:
       iso226_freq_label = ["20"; "25"; "31.5"; "40"; "50"; "63"; "80"; "100"; "125"; "160"; "200"; "250"; "315"; "400"; ...
            "500"; "630"; "800"; "1k"; "1.25k"; "1.6k"; "2k"; "2.5k"; "3.15k"; "4k"; "5k"; ...
            "6.3k"; "8k"; "10k"; "12.5k"];
        
       % Full range spactrum frequency label:
       F20_20K_freq_label = ["20"; "25"; "31.5"; "40"; "50"; "63"; "80"; "100"; "125"; "160"; "200"; "250"; "315"; "400"; ...
            "500"; "630"; "800"; "1k"; "1.25k"; "1.6k"; "2k"; "2.5k"; "3.15k"; "4k"; "5k"; ...
            "6.3k"; "8k"; "10k"; "12.5k"; "16K"; "20K"];
        
       Y_TICKS_FFT = ([-100 -90 -80 -70 -60  -50 -40 -30 -20 -10 0]);
       Y_TICKS_FFT_LABELS = ({"-100", "-90", "-80", "-70", "-60", "-50", "-40", "-30", "-20", "-10", "0"});
       
       %% Loudness Duration Types:
       % Set the interval of the loudness measurement:
       mix_loud_duration_5 = 5;
       mix_loud_duration_10 = 10;
       mix_loud_duration_15 = 15;
       
       track_loud_duration_1 = 1;
       track_loud_duration_3 = 3;
       track_loud_duration_5 = 5;
       
       %% Frame size:
       FRAME_LENGTH_512 = 512;
       
       %% Percentile:
       PERCENTILE_90 = 90;
       
       %% Resonant Frequencies:
       % Number of resonant frequencies to localize:
       NUM_RESO_FREQ_3 = 3;
       NUM_RESO_FREQ_4 = 4;
       NUM_RESO_FREQ_5 = 5;
       NUM_RESO_FREQ_6 = 6;
       NUM_RESO_FREQ_7 = 7;
       
       % Highpass Slope:
       HIGHPASS_SLOPE_3 = 3;
       HIGHPASS_SLOPE_6 = 6;
       HIGHPASS_SLOPE_12 = 12;
       HIGHPASS_SLOPE_18 = 18;
       HIGHPASS_SLOPE_24 = 24;
       
       % Equalizer Parameters:
       MAX_Q_FACTOR_50 = 50;
       
       %% Bounce Track:
       ACTUAL_FOLDER = './';
       BOUNCE_PATH = '../bounce/';
   end
end


