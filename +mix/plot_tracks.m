function [] = plot_tracks(track, reference)
%PLOT_TRACKS Plot all tracks spectrum and referece spectrum
%   Plot actual spectrum of each track object and reference spectrum
%   
%   'track' is a track object vector that contains all tracks
%   'reference' is a track object that contains the reference signal
%
%   USAGE: 
%   h = plot_tracks(track, reference)

    num_tracks = length(track);

    figure;
    % Plot 1/3 octave amplitude spectrum of the reference signal:
    mix.plot(reference.spectrum);
    hold on
    
    % Plot the 1/3 amplitude spectrum of each track signal:
    for tk = 1:num_tracks
        mix.plot(track(tk).spectrum);
    end
    
end