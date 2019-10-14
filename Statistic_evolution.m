%In this code we simulate the moving change problem for a sensor network of
%L nodes. we simulate the oracle cusum test
clear all
clc
%network size
L=10;
load('sensor_evolution_10.mat','sensor_evolution');
pre_change_mean = 0;
post_change_mean = 1;
sigma = 1;
threshold = 100;
horizon = 100000;
changepoint=100;
    CuSum_statistic(1:horizon)=0;
    mixture(1:horizon)=0;
        noisy(1:horizon)=0;
KL_div = ((post_change_mean - pre_change_mean)^2)/2 ; 

    for i = 1:1:horizon
        if i >= changepoint %Post-change observations generation
            Observations = normrnd(pre_change_mean,sigma,[L,1]);
            Observations(sensor_evolution(i)) = normrnd(post_change_mean,sigma);
        else %Pre-change observations generation
            Observations = normrnd(pre_change_mean,sigma,[L,1]);
        end
        %ORACLE
        LLR = log((normpdf(Observations(sensor_evolution(i)),post_change_mean,sigma))/(normpdf(Observations(sensor_evolution(i)),pre_change_mean,sigma))   );
        if i==1
            CuSum_statistic(i) = max ( 0,  LLR  ) ;
        else
            CuSum_statistic(i) = max(   CuSum_statistic(i-1) + LLR  ,   0   );
        end
          %MIXTURE CUSUM STATISTIC CALCULATION
        logs_to_add(1:L)=0;
        for j = 1:1:L
            logs_to_add(j) = (1/L)*( (normpdf(Observations(j),post_change_mean,sigma))/ (normpdf(Observations(j),pre_change_mean,sigma)) );
        end
        if i==1
            mixture(i) = max(log(sum(logs_to_add)),0);
        else
            mixture(i) = max(mixture(i-1)+log(sum(logs_to_add)),0);
        end
           %NOISY
        logs_to_add(1:L)=0;
        for j = 1:1:L
            logs_to_add(j) = log( (normpdf(Observations(j),post_change_mean,sigma))/ (normpdf(Observations(j),pre_change_mean,sigma)) );
        end
        if i==1
            noisy(i) = max(sum(logs_to_add) + (L-1)*KL_div,0);
        else
            noisy(i) = max(noisy(i-1)+sum(logs_to_add) + (L-1)*KL_div , 0 );
        end
        if (CuSum_statistic(i)>threshold) || (mixture(i) >threshold) || (noisy(i) > threshold)
            break
        end
    end
    CuSum_statistic(i+1:horizon)=[];
    mixture(i+1:horizon)=[];
    noisy(i+1:horizon)=[];

    figure
    plot(CuSum_statistic);
    hold on
    plot(mixture);
    plot(noisy);
    hline = refline([0 threshold]);
hline.Color = 'r';
vline = refline([0 threshold]);
vline.Color = 'r';

        lgnd=legend('CuSum','Mixture','Noisy');
