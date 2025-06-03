function AtubeB = tProduct(A,B)

AtubeB  = ifft(pagemtimes(fft(A,[],3),fft(B,[],3)),[],3);

end