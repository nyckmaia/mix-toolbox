%%
center_freq = [100 1000 10000];
q_factor = [1 1 1];
gain = [5 -5 10];
high_pass_freq = 80;
high_pass_slope = 24;

%[signal_eq] = mix.parametric_eq(reference.signal, center_freq, q_factor, gain);
[signal_eq] = mix.parametric_eq(reference.signal, center_freq, q_factor, gain, high_pass_freq, high_pass_slope);


spectrum_a = mix.fft(reference.signal);
spectrum_b = mix.fft(signal_eq);

figure
mix.plot(spectrum_a);
hold on
mix.plot(spectrum_b);