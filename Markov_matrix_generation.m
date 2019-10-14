clear all
clc

L = 5;
Markov_matrix = rand(L,L);
for i = 1:1:L
    Markov_matrix(i,:) = Markov_matrix(i,:) / (sum(Markov_matrix(i,:)));
end
Markov_matrix
save('Markov_m.mat','Markov_matrix');