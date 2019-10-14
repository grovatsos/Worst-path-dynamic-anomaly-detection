%This code generates the trajectory of the error by using an HMM
clear all
clc

horizon = 100000;

load('Markov_5.mat','Markov_matrix');
L=5;


sensor_evolution(1) = 1; %the error starts from sensor 1
for u = 2:1:horizon 
     sensor_evolution(u)=find(mnrnd(1,Markov_matrix(sensor_evolution(u-1),:)));
end
sensor_evolution
save('sensor_evolution')