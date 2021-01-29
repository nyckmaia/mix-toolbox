% First of all, you need to load your audio in the 'reference' variable
ref = reference;

% Init the graphicEQ Object:
equalizer = graphicEQ( ...
    'Bandwidth','1/3 octave', ...
    'Structure','Cascade', ...
    'SampleRate',mix.Defined.SAMPLE_RATE);

% Get the last 30 positions of the track.eq vector:
equalizer.Gains = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

% Apply the eq in the signal:
ref.signal = equalizer(ref.signal);
ref.spectrum = mix.fft(ref.signal);

figure
mix.plot(reference.spectrum);
hold on
mix.plot(ref.spectrum);

