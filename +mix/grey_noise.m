%% Perform Fractional Octave-Band Filtering
% Set the color variables to MATLAB signal generator object:
white_signal = 0;
pink_signal = 1;

% Sample Rate (Hz):
Fs = 44100;
% Signal Duration (s):
duration = 10;
% Signal Length (samples):
signal_length = Fs * duration;

% Init signal generator MATLAB object:
signal_generator = dsp.ColoredNoise(white_signal, signal_length);
% Generate signal from object:
signal = signal_generator();
% Normalize the signal between [-1 1];
signal = signal / max(signal);

% Read audio file:
% [signal, Fs] = audioread('./white_noise.wav');

%% Filter definition:

bw = '1/3 octave'; % Band width
filter_order = 6; % Filter Order

% One third octave central frequencies:
centerFreq = [20 25 31.5 40 50 63 80 100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150 4000 5000 6300 8000 10000 12500];

% Preallocate the filter bank:
octaveFilterBank = cell(1, length(centerFreq));
for i = 1:length(centerFreq)
    octaveFilterBank{i} = octaveFilter(centerFreq(i), 'FilterOrder', filter_order, 'Bandwidth', bw, 'SampleRate', Fs);
end

%% Create a filter vector:
% s = '';
% str = cell(1, length(centerFreq));
% 
% for i = 1:length(centerFreq)
%     if (i ~= length(centerFreq))
%         str{i} = strcat('getFilter(octaveFilterBank{', num2str(i),  '}), ');
%     else
%         str{i} = strcat('getFilter(octaveFilterBank{', num2str(i),  '}) ');
%     end
%     s = strcat(s, str(i));
% end

% a = char(s);
% plotter = fvtool(getFilter(octaveFilterBank{1}), ...
%     getFilter(octaveFilterBank{2}), ...
%     'FrequencyScale', 'log', ...
%     'Fs', Fs);
  
%     getFilter(octaveFilterBank{3}), ...
%     getFilter(octaveFilterBank{4}), ...


%% Init Scope:
scope2 = dsp.SpectrumAnalyzer('SampleRate', Fs, ...
    'PlotAsTwoSidedSpectrum',false, ...
    'FrequencyScale','Log', ...
    'FrequencyResolutionMethod','WindowLength', ...
    'WindowLength',1024, ...
    'Title','Octave-Band Filtering' ...
    );
 
    %'ShowLegend',true, ...
    %'ChannelNames',{'Original signal','Band 1', 'Band 2', 'New Signal'}...
 
%% Filter signal
% Preallocate bands vector:
bands = zeros(length(signal), length(centerFreq));

% Filter each band
for i = 1:length(centerFreq)
    bands(:, i) = octaveFilterBank{i}(signal);
end

%% Sum filtered bands
% Preallocate new_signal vector:
new_signal = zeros(length(signal), 1);

% Sum all bands to get the new signal:
for i = 1:length(centerFreq)
    new_signal = new_signal + bands(:, i);
end

%% Scope all signals:
tic
while toc < duration
    %scope2([white_noise , bands, new_signal])
    scope2([signal , new_signal])
end

%% Band Power
% Preallocate powerPerBand vector:
powerPerBand = zeros(length(centerFreq), 1);

% Calculate the power per band:
for i = 1:length(centerFreq)
    powerPerBand(i) = bandpower(bands(:, i));
end

%% Plot band power:
semilogx(centerFreq, powerPerBand);
% Define plot limits:
axis ([min(centerFreq) max(centerFreq) min(powerPerBand) max(powerPerBand)]);

% Configure the axis:
% Frequency Label to X axis plot:
freq_label = ["20"; "25"; "31.5"; "40"; "50"; "63"; "80"; "100"; "125"; "160"; "200"; "250"; "315"; "400"; ...
        "500"; "630"; "800"; "1k"; "1.25k"; "1.6k"; "2k"; "2.5k"; "3.15k"; "4k"; "5k"; ...
        "6.3k"; "8k"; "10k"; "12.5k"];
    
% Configure Ticks:
set(gca, 'Xtick', centerFreq);
set(gca, 'XtickLabel', freq_label);
set(gca, 'XMinorGrid','off');
set(gca, 'XMinorTick','off');
grid on;

% Put the figure legend:
title('Power Distribution of Octave Band Filter Bank')
xlabel('Center Frequency of Octave Band Filter (Hz)')
ylabel('Normalized Power')


