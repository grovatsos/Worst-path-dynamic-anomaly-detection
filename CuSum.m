%In this code we simulate the Cusum test for a drift change in the mean of
%a Gaussian random variable
clear all
clc

error_count=0;
repetitions =20000; %Number of monte carlo simulations
delay(1:repetitions) = 0;
pre_change_mean = 0;
post_change_mean = 1;
sigma = 1;
threshold =8.5;
horizon = 1000000;
changepoint =horizon;
%changepoint=1;
for q=1:1:repetitions

    CuSum_statistic(1:horizon)=0;
    for i = 1:1:horizon
        if i >= changepoint %Post-change observations generation
            Observations = normrnd(post_change_mean,sigma,1);
        else %Pre-change observations generation
            Observations = normrnd(pre_change_mean,sigma,1);
        end
        
        %CUSUM STATISTIC CALCULATION
        log_ratio = log((normpdf(Observations,post_change_mean,sigma))/ (normpdf(Observations,pre_change_mean,sigma)));
        if i==1
            CuSum_statistic(i) = max(log_ratio,0);
        else
            CuSum_statistic(i) = max(CuSum_statistic(i-1)+log_ratio,0);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if CuSum_statistic(i)>threshold
            %delay(q) = i-changepoint+1; %DELAY
            delay(q) = i; %FA
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
plot(CuSum_statistic)
delay;
average_delay = mean(delay) 