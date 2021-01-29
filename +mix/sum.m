function [stereo_mix] = sum(track)
%SUM Mix/Sum the signal property of track objects
%   Sum audio track signals into a stereo output
%
%   USAGE:
%   [stereo_mix] = sum(track_obj_vector)

    num_files = length(track);
    track_length = length(track(1).signal);

    fprintf('-----> Mixing tracks: Start <----- \n');
    
    tic
    % Stereo audio_matrix:
    audio_matrix_left = zeros(track_length, num_files);
    audio_matrix_rigth = zeros(track_length, num_files);

    % Copy each track.signal to a left/right matrix:
    for i = 1:num_files
        if(track(i).metadata.NumChannels == mix.Constant.Mono)
            % Copy the same signal to left and rigth matrix channel:
            audio_matrix_left(:, i) = track(i).signal(:, mix.Constant.LEFT);
            audio_matrix_rigth(:, i) = track(i).signal(:, mix.Constant.LEFT);
            
%             audio_matrix_left(:, i) = track(i).signal(:, mix.Constant.LEFT) * (track(i).volume / 2);
%             audio_matrix_rigth(:, i) = track(i).signal(:, mix.Constant.LEFT) * (track(i).volume / 2);
        else
            % Copy different signals to each channel:
            audio_matrix_left(:, i) = track(i).signal(:, mix.Constant.LEFT);
            audio_matrix_rigth(:, i) = track(i).signal(:, mix.Constant.RIGHT);
        end
    end
    
    
    % Sum all left signals:
    % Eq. 6
    left = sum(audio_matrix_left, 2);

    % Sum all rigth signals:
    rigth = sum(audio_matrix_rigth, 2);

    % Concatenate left and rigth signals into a stereo signal:
    stereo_mix = [left rigth];

    fprintf('Mix done in %.2f minutes \n', toc/60);
end

