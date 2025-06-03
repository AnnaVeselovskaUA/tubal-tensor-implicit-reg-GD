 testName='test_my';            


            testErrorName=strcat('test_error_', testName,'.mat');
            trainErrorName=strcat('train_error_', testName,'.mat');
            principalAnglesName=strcat('principal_angle_error_', testName,'.mat');  
            singularTubesName=strcat('singular_tubes_', testName,'.mat');  
            principalAngleToGroundTruthName=strcat('principal_angle_to_ground_truth_', testName,'.mat'); 
            principalAngleTildeName=strcat('principal_angle_tilde_', testName,'.mat'); 
            
           testError=load(testErrorName);%,"-ascii"
            trainError=load(trainErrorName);
            PrincipalAngle=load(principalAnglesName);  
            RelTubalSingValErr=load(singularTubesName); 
            PrincipalAngleToGroundTruth=load(principalAngleToGroundTruthName);   
            PrincipalAngleTilde=load(principalAngleTildeName); 

%% plots 
f101=figure(1214)

plot(1:numIter, PrincipalAngle.PrincipalAngle,  'LineWidth',3)

 hold on 

plot(1:numIter, testError.testError,  'LineWidth',3)

 hold on 

plot(1:numIter, RelTubalSingValErr.RelTubalSingValErr,  'LineWidth',3)

 hold on 

plot(1:numIter, trainError.trainError,  'LineWidth',3)

hold off

legend('$\|{V}^T_{{L}^\perp}*{V}_{{L}_t}\|$','$\frac{\|{U}_t*{U}_t^T - {{X}}*{{X}}^T\|_F}{\|{{X}}*{{X}}^T\|_F}$',...
    '$\frac{\|\sigma_{r}({U}_t)-\sigma_{r}({X})\|_2}{\|\sigma_{r}({X})\|_2}$',...
    '$\ell(U_t)$', 'interpreter','latex', 'fontsize',25);

xlabel('Number of Iterations (t)','fontsize',20);
ax = gca;
ax.XAxis.FontSize = 15; % Change xticklabel font size
ax.YAxis.FontSize = 15; % Change yticklabel font size


f301=figure(1314) 

plot(1:numIter, PrincipalAngle.PrincipalAngle,  'LineWidth',3)

hold on 

plot(1:numIter,PrincipalAngleToGroundTruth.PrincipalAngleToGroundTruth,'LineWidth',3)

hold on

plot(1:numIter, PrincipalAngleTilde.PrincipalAngleTilde,  'LineWidth',3)
legend('$\|{{V}}^T_{{L}^\perp}*{{V}}_{{L}_t}\|$','$\|{{V}}^T_{X^\perp}*{{V}}_{L_t}\|$',...
                        '$\|{{V}}^T_{{L}^\perp}*{{V}}_{\widetilde{L}_t}\|$','interpreter','latex', 'fontsize',25);
xlabel('Number of Iterations (t)','fontsize',20);
ax = gca;
ax.XAxis.FontSize = 15; % Change xticklabel font size
ax.YAxis.FontSize = 15; % Change yticklabel font size

hold off

testNum='test_my_1';

Name101= strcat('phases_',testNum,'.fig');
Name102= strcat('phases_',testNum,'.png');
Name302= strcat('angles_',testNum,'.png');
Name301= strcat('angles_',testNum,'.fig');
  
    saveas(f101,Name101);

    saveas(f101,Name102);

    saveas(f301,Name302);

    saveas(f301,Name301);