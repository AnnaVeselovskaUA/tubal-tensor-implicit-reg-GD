clear all 
%close all
clc

tic

addpath('../')

%% all test params
% testNum='test_my';
testNum='test_new';
n= 10;
k= 4;
rStar=2;

numData=ceil(1.2*(n+1)*rStar*k*log(n+1));

r= 100;        % overparam
numIter= 10000;
%numIter= 500;

PowerMType='sym';
%PowerMType='non-sym';

% setting for normalized
TesorType='norm'; 
nu= 1e-5;       % learning rate 
alpha= 1e-7;   % initialization

% % % setting NON for normalized
% TesorType='non-norm'; 
% nu= 1e-6;       % learning rate 
% alpha= 1e-5;   % initialization


%% data
UStar=randn(n,rStar,k);

%% tensor type
switch TesorType

    case  'norm' 

    % normalized tensor
    [UUStar,SUStar,VUStar] = tSVD(UStar,'econ');
    XStar=tProduct(UUStar, tTranspose(UUStar));     % normalized tensor
    [~,SStar,~] = tSVD(UUStar, 'econ');
    SStar(:,:,1);

    case  'non-norm'

    [UUStar,~,VUStar] = tSVD(UStar,'econ');
    XStar=tProduct(UStar, tTranspose(UStar));      % non- normalized tensor
    [~,SStar,~] = tSVD(UStar, 'econ');
    [~,SStarX,~] = tSVD(XStar, 'econ');

    norm(XStar, 'fro')^2
   
    norm(SStarX, 'fro')^2

end 
%%
fprintf('total number of elements in XStar           ----  %d\n',   n^2*k);
fprintf('number of data           ----  %d\n',   numData);

G=randn(n, n, k, numData); 

% data
y= zeros(numData,1); 

    for j = 1:numData
        y(j)=tensorprod(XStar, G(:,:,:,j),'all');
    end

    %% operators

IdTensor=zeros(n,n,k);
IdTensor(:,:,1)=eye(n);

% A^*A(UStar*UStar^T)
operatorStarToData= zeros(n,n,k); 

    for j = 1:numData
    
          operatorStarToData =  operatorStarToData + y(j)*G(:,:,:,j);
    end

%% PowerMType
switch PowerMType

    case 'non-sym'
    %  % NO symmetrization of the measurement operator 
    [L,SL,~] = tSVD(operatorStarToData,'econ'); % , 'econ'

    case 'sym'
    %   %  % symmetrization of the measurement operator 
    operatorStarToDataSym= 1/2*(operatorStarToData+ tTranspose(operatorStarToData));
    [L,SL,~] = tSVD(operatorStarToDataSym,'econ'); % , 'econ'

end 

LStar=L(:,1:rStar,:);
SL(:,:,1)

%LOrthogonal= IdTensor

%% set up for gradient 

U= alpha*randn(n,r,k)*(1/sqrt(r));
U0=U;
X=tProduct(U, tTranspose(U));

normOfXStar=sqrt(tensorprod(XStar,XStar, 'all'));
normOfData=norm(y);
normSStar=norm(squeeze(SStar(rStar,rStar,:)));

count=0;

testError=zeros(numIter,0);
trainError = zeros(numIter,0);
RelTubalSingValErr = zeros(numIter,1);


%% set up power method iterates 

% LTilde=IdTensor; % small test
LTilde=IdTensor+nu*operatorStarToDataSym;

UTilde=U;
%XTilde_t=tProduct(U, tTranspose(U));


PrincipalAngle=zeros(numIter,1);
PrincipalAngleToGroundTruth=zeros(numIter,1);
PrincipalAngleTilde=zeros(numIter,1);


%% gradient iterations 
    
for i= 1:numIter

 count= count + 1;

 %%%%%%%   gradient   %%%%%%% 

   clear X newData gradUVal S

    newData=zeros(numData,1); 

    X=tProduct(U, tTranspose(U));

    testError(i) = sqrt(tensorprod(XStar-X, XStar-X,'all'))/normOfXStar;

        if testError(i)>20 %isnan(testError(i))
                   disp('Error is NaN (Not a Number)          ----  !!!!');
            break
        end

        for j = 1:numData
             newData(j)=tensorprod(X, G(:,:,:,j),'all');
        end 

    dataDiff=y-newData;
    trainError(i)= norm(dataDiff)/normOfData;
     
        if mod(i,200)==0
            fprintf( '\n');
            fprintf( '\n');
            fprintf( '\n');
            fprintf('grad step           ----  %d\n',   count);
            fprintf('test error           ----  %d\n',  testError(i));  
            fprintf('train error           ----  %d\n', trainError(i));
            fprintf( '\n');  
        end 

    gradUVal=gradUNew(U,G,y); 
    U_t= U-nu*gradUVal;              
    U=U_t;    
    [~,S,~] = tSVD(U, 'econ'); %,'econ'
   
    RelTubalSingValErr(i) = norm(squeeze(S(rStar,rStar,:)-SStar(rStar,rStar,:)))/normSStar;
 

     %%%%%%%   "power method"  %%%%%%% 

     % for AStarA(XStar)
     
     [V,~,~] = tSVD(X,'econ');
     V_t=V(:,1:rStar,:);

     [PrincipalAngle(i), PrincipalAngleAll]=tubal_principal_angle_Fourier_pages(V_t,LStar);
      PrincipalAngleAll;
     [PrincipalAngleToGroundTruth(i), ~]=tubal_principal_angle_Fourier_pages(V_t,UUStar);

    % % for (Id + nu*AStarA(XStar))^(*)t *U0
    % 
     LTilde_t=tProduct(LTilde, U0);
     XTilde_t=tProduct(LTilde_t,tTranspose(LTilde_t));
     [VTilde,~,~] = tSVD(XTilde_t,'econ');


     VTilde_t=VTilde(:,1:rStar,:);

     [PrincipalAngleTilde(i), ~]=tubal_principal_angle_Fourier_pages(VTilde_t,LStar);

     LTilde=tProduct(LTilde, LTilde);
    
    
    XTilde_t=tProduct(UTilde,tTranspose(UTilde));
    [VTilde,~,~] = tSVD(XTilde_t,'econ');
    VTilde_t=VTilde(:,1:rStar,:);
    [PrincipalAngleTilde(i), ~]=tubal_principal_angle_Fourier_pages(VTilde_t,LStar);
    switch PowerMType

        case 'non-sym'
        %  % NO symmetrization of the measurement operator 
        UTilde_t= UTilde+nu*tProduct(operatorStarToData,UTilde);  
    
        case 'sym'
        %   %  % symmetrization of the measurement operator 
        UTilde_t= UTilde+nu*tProduct(operatorStarToDataSym,UTilde);   
    end 
      
    UTilde=UTilde_t;

    UTilde(2,2,1);
    VTilde_t(1,1,1);
end 

toc

            testErrorName=strcat('test_error_', testName,'.mat');
            trainErrorName=strcat('train_error_', testName,'.mat');
            principalAnglesName=strcat('principal_angle_error_', testName,'.mat');  
            singularTubesName=strcat('singular_tubes_', testName,'.mat');  
            principalAngleToGroundTruthName=strcat('principal_angle_to_ground_truth_', testName,'.mat'); 
            principalAngleTildeName=strcat('principal_angle_tilde_', testName,'.mat'); 
            
            save(testErrorName,'testError');%,"-ascii"
            save(trainErrorName,'trainError');
            save(principalAnglesName, 'PrincipalAngle');   
            save(singularTubesName, 'RelTubalSingValErr'); 
            save(principalAngleToGroundTruthName, 'PrincipalAngleToGroundTruth');   
            save(principalAngleTildeName, 'PrincipalAngleTilde'); 

%% plots 
f101=figure(1214)

plot(1:numIter, PrincipalAngle,  'LineWidth',3)

 hold on 

plot(1:numIter, testError,  'LineWidth',3)

 hold on 

plot(1:numIter, RelTubalSingValErr,  'LineWidth',3)

 hold on 

plot(1:numIter, trainError,  'LineWidth',3)

hold off

legend('$\|{V}^T_{{L}^\perp}*{V}_{{L}_t}\|$','$\frac{\|{U}_t*{U}_t^T - {{X}}*{{X}}^T\|_F}{\|{{X}}*{{X}}^T\|_F}$',...
    '$\frac{\|\sigma_{r}({U}_t)-\sigma_{r}({X})\|_2}{\|\sigma_{r}({X})\|_2}$',...
    '$\ell(U_t)$', 'interpreter','latex', 'fontsize',25);

xlabel('Number of Iterations (t)','fontsize',15);



f301=figure(1314) 

plot(1:numIter, PrincipalAngle,  'LineWidth',3)

hold on 

plot(1:numIter,PrincipalAngleToGroundTruth,'LineWidth',3)

hold on

plot(1:numIter, PrincipalAngleTilde,  'LineWidth',3)
legend('$\|{{V}}^T_{{L}^\perp}*{{V}}_{{L}_t}\|$','$\|{{V}}^T_{X^\perp}*{{V}}_{L_t}\|$',...
                        '$\|{{V}}^T_{{L}^\perp}*{{V}}_{\widetilde{L}_t}\|$','interpreter','latex', 'fontsize',25);

hold off


Name101= strcat('phases_',testNum,'.fig');
Name102= strcat('phases_',testNum,'.png');
Name302= strcat('angles_',testNum,'.png');
Name301= strcat('angles_',testNum,'.fig');
  
    saveas(f101,Name101);

    saveas(f101,Name102);

    saveas(f301,Name302);

    saveas(f301,Name301);

%% new grad

function gradU =gradUNew(U, G, yTrue)

  %  clear operatorConj gradUVfnew gradU
    
    X= tProduct(U, tTranspose(U));
    [n1, n2, n3, numData]=size(G);

    operatorConj = zeros(n1,n2,n3); 

    for j = 1:numData

         operatorConj = operatorConj + (tensorprod(X, G(:,:,:,j),'all')-yTrue(j))*(G(:,:,:,j)+tTranspose(G(:,:,:,j)));
    end

    gradU=tProduct(operatorConj,U);

end 
