function [amplitude] = dbfs2amp(dbfs, resolution)
%DBFS2AMP return the positive normalized sample amplitude value.
%
%   USAGE: 
%   [amplitude] = dbfs2amp(dbfs) return the positive normalized 
% sample amplitude between [-1 +1]
%
%   [amplitude] = dbfs2amp(dbfs, resolution) return the positive normalized 
% sample amplitude if it is possible using the given resolution

    if(nargin < 2)
        resolution = mix.Defined.BIT_DEEP;
    end
    
    % Every bit the signal drops a half of resolution:
    floor_scale = resolution * mix.amp2dbfs(0.5);
    
    % Check the possibility of conversion:
    if(dbfs < floor_scale)
        error('You can not get the amplitude of %.2f dBFS using %d bits of resolution', dbfs, resolution);
    else
        % Get the positive amplitude value:
        amplitude = 10 ^ (dbfs/20);
    end
end