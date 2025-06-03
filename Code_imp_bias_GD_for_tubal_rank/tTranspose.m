function Tt=tTranspose(T)
%digits(50);
[n1, n2, n3]= size(T);

Ttest= zeros(n2,n1,n3);

    for i=1:n3
    
        Ttest(:,:,i)=T(:,:,i)';
    
    end 

Tt=zeros(n2,n1,n3);

Tt(:,:,1)=Ttest(:,:,1);

    for j=2:n3
    
        Tt(:,:,j)= Ttest(:,:,n3+2-j);
    
    end 

end