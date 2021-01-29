%% Plot Mixes:
mix.plot(reference.spectrum);
hold on
mix.plot(initial_mix.spectrum);
mix.plot(temp_mix.spectrum);
mix.plot(before_comp_mix.spectrum);
mix.plot(after_comp_mix.spectrum);
mix.plot(final_eq_mix.spectrum);
legend('Reference', 'Initial Mix', 'Temp Mix', 'Before Comp Mix', 'After Comp Mix', 'Final Eq Mix')

%% Plot time domain:
plot(track(1).signal);
hold on
plot(track(2).signal);
plot(track(3).signal);

%% Bounce files:
initial_mix.bounce();
temp_mix.bounce();
before_comp_mix.bounce();
after_comp_mix.bounce();
final_eq_mix.bounce();
disp('Bounce all files: Done!');

%%