function [U,S,V,SF] = tSVD(T,opt)	

% Compute mode-3 FFT
T = fft(T,[],3);

% Compute SVD on each mode-3 slice
if(nargin == 1)
    [U,S,V] = pagesvd(T);
else
    [U,S,V] = pagesvd(T,opt);
end

SF=S;
% Compute mode-3 IFFTs
U = ifft(U,[],3);
S = ifft(S,[],3);
V = ifft(V,[],3);
