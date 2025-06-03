function [outAngle, sinValues]=tubal_principal_angle_Fourier_pages(U,V)

Uf=fft(U,[],3);
Vf=fft(V,[],3);

X= pagemtimes(Vf,'ctranspose',Uf,'none');

cosValues = pagesvd(X,'econ'); %, 'econ'
sinValues=real(sqrt(1-cosValues.^2));
outAngle=max(sinValues,[], 'all' );

end


% test 

%% matrices

% V=[1/sqrt(2) 1/sqrt(3); 0 1/sqrt(3); 1/sqrt(2) -1/sqrt(3)]; 
% 
% 
% W=[1/sqrt(6) 2/sqrt(21); 2/sqrt(6) 1/sqrt(21); -1/sqrt(6) 4/sqrt(21)]

% S = svd(WT*V, 'econ')
   % 
   % 1.000000000000000
   % 0.872871560943970   = 4/sqrt(21)


%  tubal_principal_angle_Fourier_pages(V,W)
%  Uf =
% 
%    0.707106781186547   0.577350269189626
%                    0   0.577350269189626
%    0.707106781186547  -0.577350269189626
% 
% 
% cosValues =
% 
%    1.000000000000000
%    0.872871560943970
% 
% 
% ans =
% 
%    0.487950036474266

%% tensors

 %   A=zeros(3,2,2); B=zeros(3,2,2); A(:,:,1)=V; A(:,:,2)=V; B(:,:,1)=W; B(:,:,2)=W;

% Afft=zeros(3,2,2); Bfft=zeros(3,2,2); Afft(:,:,1)=V; Afft(:,:,2)=V; Bfft(:,:,1)=W; Bfft(:,:,2)=W;
% A=ifft(Afft, [], 3); B=ifft(Bfft, [], 3); 
% tubal_principal_angle_Fourier_pages(A,B)
% Uf(:,:,1) =
% 
%    0.707106781186547   0.577350269189626
%                    0   0.577350269189626
%    0.707106781186547  -0.577350269189626
% 
% 
% Uf(:,:,2) =
% 
%    0.707106781186547   0.577350269189626
%                    0   0.577350269189626
%    0.707106781186547  -0.577350269189626
% 
% 
% cosValues(:,:,1) =
% 
%    1.000000000000000
%    0.872871560943970
% 
% 
% cosValues(:,:,2) =
% 
%    1.000000000000000
%    0.872871560943970
% 
% 
% ans =
% 
%    0.487950036474266