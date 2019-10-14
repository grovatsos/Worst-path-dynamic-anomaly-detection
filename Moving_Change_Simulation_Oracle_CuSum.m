%In this code we simulate the moving change problem for a sensor network of
%L nodes. we simulate the oracle cusum test
clear all
clc
%network size
L=10;
load('sensor_evolution_10.mat','sensor_evolution');
error_count=0;
repetitions =20000; %Number of monte carlo simulations
delay(1:repetitions) = 0;
pre_change_mean = 0;
post_change_mean = 1;
sigma = 1;
threshold = 4.5;
horizon = 100000;
changepoint =horizon;
changepoint=1;
for q=1:1:repetitions
    CuSum_statistic(1:horizon)=0;
    for i = 1:1:horizon
        if i >= changepoint %Post-change observations generation
            Observations = normrnd(pre_change_mean,sigma,[L,1]);
            Observations(sensor_evolution(i)) = normrnd(post_change_mean,sigma);
        else %Pre-change observations generation
            Observations = normrnd(pre_change_mean,sigma,[L,1]);
        end
        LLR = log((normpdf(Observations(sensor_evolution(i)),post_change_mean,sigma))/(normpdf(Observations(sensor_evolution(i)),pre_change_mean,sigma))   );
        if i==1
            CuSum_statistic(i) = max ( 0,  LLR  ) ;
        else
            CuSum_statistic(i) = max(   CuSum_statistic(i-1) + LLR  ,   0   );
        end

        if CuSum_statistic(i)>threshold
            delay(q) = i-changepoint+1; %DELAY
            %delay(q) = i; %FA
            break
        end
    end
    CuSum_statistic(i+1:horizon)=[];
       if mod(q,100)==0
         q
       end
       if i==horizon
          disp('error')
          error_count = error_count+1;
          delay(q)=-333;
       end 

   % plot(statistic);
end
CuSum_statistic(1)
delay( delay == -333)=[];

error_count
%plot(CuSum_statistic)
delay;
average_delay = mean(delay)