function [mono_signal] = stereo2mono(signal)
%STEREO2MONO Convert stereo audio files to mono
%
%   USAGE: [mono_signal] = stereo2mono(signal)
      
    mono_signal = sum(signal, 2) / size(signal, 2);

end

