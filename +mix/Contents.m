% MIX TOOLBOX
%
% Author: Nycholas Maia, Arts Institute - State University of Campinas (Brazil)
% Email: nyckmaia@gmail.com
%
% Last modification: Jul. 05, 2018.
%
%   fft                       - Compute the amplitude band of the FFT of the signal.
%   grey_noise                - Perform Fractional Octave-Band Filtering
%   plot                      - plot 1/3 octave FFT of the signal
%   dbfs2amp                  - return the positive normalized sample amplitude value.
%   gain                      - Add/Reduce gain (dB) of the given signal
%   mix                       - Mix/Sum any set of signals
%   norm                      - Normalize the signal between [-1 +1]
%   amp2dbfs                  - return the sample amplitude value using dBFS scale
%   multi_audioread           - Reads all audio files (*.wav) inside the specified folder
%   stereo2mono               - Convert stereo audio files to mono
%   loudness                  - Return a of Integrated Loudness of the mono/stereo signal
%   sum                       - Mix/Sum the signal property of track objects
%   loud_spectrum             - Compute the FFT of the audio only in the loudest section
%   simple_fft                - Return a single-side amplitude spectrum
%   apply_eq                  - Apply the spectral correction for each track
%   track_eq                  - Calculate the amplitude gain (dB) of each band for each track
%   track_reso_freqs          - Remove the resonante frequencies of each track signal
%   parametric_eq             - Apply a parametric equalizer in the input signal
%   plot_tracks               - Plot all tracks spectrum and referece spectrum
%   special_percentile        - Return a percentile value of the elements inside the vector
%   find_resonant_frequencies - Find resonant frequencies of the audio signal


