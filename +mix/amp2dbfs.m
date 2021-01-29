function [dbfs] = amp2dbfs(sample)
%AMP2DBFS return the sample amplitude value using dBFS scale
%
%   USAGE: 
%   [dbfs] = amp2dbfs(sample)

coder.inline('never');
    
    % Eq. 13
    dbfs = 20 * log10(abs(sample));
    
end

