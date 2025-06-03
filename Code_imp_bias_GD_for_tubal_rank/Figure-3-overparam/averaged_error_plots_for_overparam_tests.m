
clear all
colorStr= ["b","g","c","m","r","y","k"];

testNumRangeName=["test_1", "test_2","test_3", "test_4", "test_5","test_6", "test_7","test_8", "test_9", "test_10","test_11", "test_12","test_13", "test_14", "test_15"...
    "test_16", "test_17","test_18", "test_19", "test_20"]; 
rRangeName= ["over_10", "over_50","over_100","over_200", "over_400"]; 


rRange= [10 50 100 200 400];       % overparam
testNumberRange=1:20;
numIter= 4000;

numIterSort=1500;

rNumRange=[1 2 3 4 5];

 makerType= ["-o","-v","-s","-d"];


%% test error

 count=0;
for rNum=rNumRange
    rName=rRangeName(rNum);
    r=rRange(rNum);
    count= count+1;

         testErrorAver=zeros(numIter,1);

         for test=testNumberRange

            testName=testNumRangeName(test);
         
            testErrorName=strcat('test_error_',rName,'_', testName,'.mat');
           
            testError=load(testErrorName);
           
            testErrorAver=testErrorAver+ testError.testError;
          

         end 

           testErrorAver=1/length(testNumberRange)*testErrorAver(1,:);
            
            f104=figure(1217)
            
            % plot(1:numIterSort, testErrorAver(1:numIterSort),  'LineWidth',3)
            semilogy(1:numIterSort, testErrorAver(1:numIterSort), colorStr(count), 'LineWidth',3)

           
            hold on
end

hold off
legend(  'R=10', 'R=50', 'R=100', 'R=200',  'R=400',  'interpreter','latex', 'fontsize',20);

ax = gca;
ax.XAxis.FontSize = 15; % Change xticklabel font size
ax.YAxis.FontSize = 15; % Change yticklabel font size
xlabel('Number of Iterations (t)','fontsize',20);
ylabel('$\frac{\|{U}_t*{U}_t^T - {{X}}*{{X}}^T\|_F}{\|{{X}}*{{X}}^T\|_F}$', 'interpreter','latex','fontsize',35);


axes('position',[.20 .20 .30 .35])
box on % put box around new pair of axes
                             count=0;
                            for rNum=rNumRange
                                rName=rRangeName(rNum);
                                r=rRange(rNum);
                                count= count+1;
                            
                                     testErrorAver=zeros(numIter,1);
                            
                                     for test=testNumberRange
                            
                                        testName=testNumRangeName(test);
                                     
                                        testErrorName=strcat('test_error_',rName,'_', testName,'.mat');
                                       
                                        testError=load(testErrorName);
                                       
                                        testErrorAver=testErrorAver+ testError.testError;
                                      
                            
                                     end 
                            
                                       testErrorAver=1/length(testNumberRange)*testErrorAver(1,:);
                                        % % create a new pair of axes inside current figure
                                       
                                        indexOfInterest = 1450:1490; % range of t near perturbation
                                        semilogy(indexOfInterest,testErrorAver(indexOfInterest),colorStr(count), 'LineWidth',3) % plot on new axes
                                        %axis tight
                                                   
                                        hold on
                            end
                            
hold off
ax = gca;
ax.XAxis.FontSize = 15; % Change xticklabel font size
ax.YAxis.FontSize = 15; % Change yticklabel font size

%% train error
count= 0;

for rNum=rNumRange
     rName=rRangeName(rNum);
     r=rRange(rNum);
       count= count+1;

        trainErrorAver = zeros(numIter,1);
  

         for test=testNumberRange

            testName=testNumRangeName(test);
         
           
            trainErrorName=strcat('train_error_',rName,'_', testName,'.mat');          
            trainError = load(trainErrorName);

            trainErrorAver = trainErrorAver+trainError.trainError;
       

         end 

           trainErrorAver = 1/length(testNumberRange)*trainErrorAver(1,:);
         
            f103=figure(1216)
            
            %plot(1:numIterSort, trainErrorAver(1:numIterSort),  'LineWidth',3)
            semilogy(1:numIterSort, trainErrorAver(1:numIterSort), colorStr(count), 'LineWidth',3)
            
            hold on
end

legend(  'R=10', 'R=50', 'R=100', 'R=200',  'R=400',  'interpreter','latex', 'fontsize',20);



ax = gca;
ax.XAxis.FontSize = 15; % Change xticklabel font size
ax.YAxis.FontSize = 15; % Change yticklabel font size
xlabel('Number of Iterations (t)','fontsize',20);
ylabel('$\ell(U_t)$', 'interpreter','latex','fontsize',35);

axes('position',[.20 .20 .30 .35])
box on % put box around new pair of axes
count= 0;

                                for rNum=rNumRange
                                     rName=rRangeName(rNum);
                                     r=rRange(rNum);
                                       count= count+1;
                                
                                        trainErrorAver = zeros(numIter,1);
                                  
                                
                                         for test=testNumberRange
                                
                                            testName=testNumRangeName(test);
                                         
                                           
                                            trainErrorName=strcat('train_error_',rName,'_', testName,'.mat');          
                                            trainError = load(trainErrorName);
                                
                                            trainErrorAver = trainErrorAver+trainError.trainError;
                                       
                                
                                         end 
                                
                                           trainErrorAver = 1/length(testNumberRange)*trainErrorAver(1,:);
                                         
                                            indexOfInterest = 1450:1490; % range of t near perturbation
                                            semilogy(indexOfInterest,trainErrorAver(indexOfInterest),colorStr(count), 'LineWidth',3) % plot on new axes
                                            %axis tight
                                                   
                                            hold on
                                end


ax = gca;
ax.XAxis.FontSize = 15; % Change xticklabel font size
ax.YAxis.FontSize = 15; % Change yticklabel font size
hold off
%% angles  

count= 0;

for rNum=rNumRange

     rName=rRangeName(rNum);
    r=rRange(rNum);
    count=count+1;

        PrincipalAngleAver=zeros(numIter,1);

         for test=testNumberRange

            testName=testNumRangeName(test);
        
            principalAnglesName=strcat('principal_angle_error_', rName,'_', testName,'.mat');  
            
            PrincipalAngle=load(principalAnglesName);
         
            PrincipalAngleAver= PrincipalAngleAver+ PrincipalAngle.PrincipalAngle;
         end 

           PrincipalAngleAver= 1/length(testNumberRange)*PrincipalAngleAver;   

            f102=figure(1215)
            
            plot(1:numIterSort, PrincipalAngleAver(1:numIterSort), colorStr(count), 'LineWidth',3)
        
            
            hold on
end

legend(  'R=10', 'R=50', 'R=100', 'R=200',  'R=400',  'interpreter','latex', 'fontsize',20);


ax = gca;
ax.XAxis.FontSize = 15; % Change xticklabel font size
ax.YAxis.FontSize = 15; % Change yticklabel font size
xlabel('Number of Iterations (t)','fontsize',20);
ylabel('$\|{V}^T_{{L}^\perp}*{V}_{{L}_t}\|$','interpreter','latex','fontsize',35);

hold off
%% tubes

count= 0;
for rNum=rNumRange
   
     rName=rRangeName(rNum);
    r=rRange(rNum);
    count= count+1;

        RelTubalSingValErrAver = zeros(numIter,1);


         for test=testNumberRange

            testName=testNumRangeName(test);
            singularTubesName=strcat('singular_tubes_', 'non',rName,'_', testName,'.mat');  
         
            RelTubalSingValErr= load(singularTubesName);

            RelTubalSingValErrAver = RelTubalSingValErrAver+RelTubalSingValErr.RelTubalSingValErr;

         end 

           RelTubalSingValErrAver = 1/length(testNumberRange)*RelTubalSingValErrAver;
           f101=figure(1214)
            
           % plot(1:numIterSort, RelTubalSingValErrAver(1:numIterSort),  'LineWidth',3)
            
            semilogy(1:numIterSort, RelTubalSingValErrAver(1:numIterSort), colorStr(count),  'LineWidth',3)
            hold on           
end

legend(  'R=10', 'R=50', 'R=100', 'R=200',  'R=400',  'interpreter','latex', 'fontsize',20);

ax = gca;
ax.XAxis.FontSize = 15; % Change xticklabel font size
ax.YAxis.FontSize = 15; % Change yticklabel font size
xlabel('Number of Iterations (t)','fontsize',20);
ylabel('$\frac{\|\sigma_{r}({U}_t)-\sigma_{r}({X})\|_2}{\|\sigma_{r}({X})\|_2}$', 'interpreter','latex','fontsize',35);


axes('position',[.20 .20 .30 .35])
box on % put box around new pair of axes

                                        count= 0;
                                        for rNum=rNumRange
                                           
                                             rName=rRangeName(rNum);
                                            r=rRange(rNum);
                                            count= count+1;
                                        
                                                RelTubalSingValErrAver = zeros(numIter,1);
                                        
                                        
                                                 for test=testNumberRange
                                        
                                                    testName=testNumRangeName(test);
                                                    singularTubesName=strcat('singular_tubes_', 'non',rName,'_', testName,'.mat');  
                                                 
                                                    RelTubalSingValErr= load(singularTubesName);
                                        
                                                    RelTubalSingValErrAver = RelTubalSingValErrAver+RelTubalSingValErr.RelTubalSingValErr;
                                        
                                                 end 
                                        
                                                   RelTubalSingValErrAver = 1/length(testNumberRange)*RelTubalSingValErrAver;
                                                
                                                    indexOfInterest = 1450:1490; % range of t near perturbation
                                                    semilogy(indexOfInterest,RelTubalSingValErrAver(indexOfInterest),colorStr(count), 'LineWidth',3) % plot on new axes
                                                    %axis tight                                                          
                                                    hold on
                                        end


ax = gca;
ax.XAxis.FontSize = 15; % Change xticklabel font size
ax.YAxis.FontSize = 15; % Change yticklabel font size
hold off

hold off

Name104= strcat('test_over_20_mg_new','.fig');
Name103= strcat('train_over_20_mg_new','.fig');
Name102= strcat('angles_over_20_mg_new','.fig');
Name101= strcat('tubes_over_20_mg_new','.fig');

   saveas(f101,Name101);
    saveas(f102,Name102);
    saveas(f103,Name103);
    saveas(f104,Name104);

Name1042= strcat('test_over_20_mg_new','.png');
Name1032= strcat('train_over_20_mg_new','.png');
Name1022= strcat('angles_over_20_mg_new','.png');
Name1012= strcat('tubes_over_20_mg_new','.png');
  
    saveas(f101,Name1012);
    saveas(f102,Name1022);
    saveas(f103,Name1032);
    saveas(f104,Name1042);
         
    