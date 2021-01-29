function [track] = multi_audioread()
%MULTI_AUDIOREAD Reads all audio files (*.wav) inside the specified folder
%   Returns a matrix of all audio signals 
%   
%   USAGE: 
%   [track] = multi_audioread() 

    % Choose the audio files folder:
    folder_path = uigetdir(pwd, 'Select a folder');
    
    % Get the files metadata:
    file = dir(fullfile(folder_path, '*.wav'));
    
    % Calculate the number of audio files:
    num_files = length(file);
    fprintf('-----> Importing %d audio files: Start <----- \n', num_files);

    % Preallocate a array of track objects:
    track(1, num_files) = mix.track;

    % Create a track object for each audio file:
    for i = 1:num_files
        track(i) = mix.track('audio file', file(i));
    end
    
    disp('-----> Audio import: Complete! <-----');
end

