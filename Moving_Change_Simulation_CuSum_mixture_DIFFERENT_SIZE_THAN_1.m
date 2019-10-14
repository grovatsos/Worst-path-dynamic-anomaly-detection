%In this code we simulate the moving change problem for a sensor network of
%L nodes when the anomaly cannot is of size 5
% IF ANOMALY SIZE CHANGES MINOR CHANGES NEED TO HAPPEN AT THE CODE
clear all
clc
%network size
L=10;
anomaly_size = 5;
error_count=0;
repetitions =5000; %Number of monte carlo simulations
delay(1:repetitions) = 0;
pre_change_mean = 0;
post_change_mean = 1;
sigma = 1;
threshold =7;
horizon = 100000;
%changepoint = 1;
changepoint=horizon;
%Calculate all the sets of combinatios of size equal to the anomaly size
Set_of_combs = combntns(1:L,anomaly_size);


for q=1:1:repetitions
    Cusum_statistic(1:horizon)=0;
    
    for i = 1:1:horizon
        %From the symmetry of the test the faulty sensors don't need to
        %move
        %We will get the same results even if they dont move
        if i >= changepoint
            Observations = normrnd(pre_change_mean,sigma,[L,1]);
            Observations(1:anomaly_size) = normrnd(post_change_mean,sigma,[anomaly_size,1]);
        else %Pre-change observations generation
            Observations = normrnd(pre_change_mean,sigma,[L,1]);
        end
        %MIXTURE CUSUM STATISTIC CALCULATION
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %%%
        logs_to_add(1:( nchoosek(L,anomaly_size)) )=0;
        for j = 1:1:nchoosek(L,anomaly_size)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %IF WE CHANGE THE ANOMALY SIZE THIS IS THE ONLY PART OF CODE WE
        %HAVE TO CHANGE
        %ANOMALY OF SIZE 3
       %         j_1 = Set_of_combs(j,1);
        %        j_2 = Set_of_combs(j,2);
         %       j_3 = Set_of_combs(j,3);
          %      logs_to_add(j) = (1/(nchoosek(L,anomaly_size)))*( (normpdf(Observations(j_1),post_change_mean,sigma)*normpdf(Observations(j_2),post_change_mean,sigma)*normpdf(Observations(j_3),post_change_mean,sigma))/ (normpdf(Observations(j_1),pre_change_mean,sigma)*normpdf(Observations(j_2),pre_change_mean,sigma)*normpdf(Observations(j_3),pre_change_mean,sigma)) );     
        %ANOMALY OF SIZE 5
                j_1 = Set_of_combs(j,1);
                j_2 = Set_of_combs(j,2);
                j_3 = Set_of_combs(j,3);
                j_4 = Set_of_combs(j,4);
                j_5 = Set_of_combs(j,5);
                logs_to_add(j) = (1/(nchoosek(L,anomaly_size)))*( (normpdf(Observations(j_1),post_change_mean,sigma)*normpdf(Observations(j_2),post_change_mean,sigma)*normpdf(Observations(j_3),post_change_mean,sigma)*normpdf(Observations(j_4),post_change_mean,sigma)*normpdf(Observations(j_5),post_change_mean,sigma))/ (normpdf(Observations(j_1),pre_change_mean,sigma)*normpdf(Observations(j_2),pre_change_mean,sigma)*normpdf(Observations(j_3),pre_change_mean,sigma)*normpdf(Observations(j_4),pre_change_mean,sigma)*normpdf(Observations(j_5),pre_change_mean,sigma)) );     
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        Z = log(sum(logs_to_add));

        %%%
        if i==1
            Cusum_statistic(i) = max(log(sum(logs_to_add)),0);
        else
            Cusum_statistic(i) = max(Cusum_statistic(i-1)+log(sum(logs_to_add)),0);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if Cusum_statistic(i)>threshold
            %delay(q) = i-changepoint+1; %DELAY
            delay(q) = i; %FA
            break
        end
    end
    Cusum_statistic(i+1:horizon)=[];
    if mod(q,100)==0
         q
    end
    if i==horizon
          disp('error')
          error_count = error_count+1;
          delay(q)=-333;
    end 
end
delay( delay == -333)=[];
error_count
plot(Cusum_statistic)
average_delay = mean(delay) 