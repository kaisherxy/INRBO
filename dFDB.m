% Cite from
% Kahraman, H. T., Bakir, H., Duman, S., Kati, M., Aras, S., Guvenc, U. 
% Dynamic FDB selection method and its application: modeling and optimizing of directional overcurrent relays coordination. 
% Appl Intell (2021). 
% https://doi.org/10.1007/s10489-021-02629-3

% Copyright (c) 2021, Hamdi Tolga KAHRAMAN
% All rights reserved.

function index = dFDB( population, fitness, frequency, iter, Gen )
 fx = round(Gen / frequency);
 y = mod(iter, fx);
 w = (y/fx * -0.6) + 0.6;
% w = (y/fx * -0.2) + 0.2;
[~, bestIndex] = min(fitness); 
best = population(bestIndex, :);
[populationSize, dimension] = size(population);

distances = zeros(1, populationSize); 
normFitness = zeros(1, populationSize); 
normDistances = zeros(1, populationSize); 
divDistances = zeros(1, populationSize); 

if min(fitness) == max(fitness)
    
    index = randi(populationSize);
    
else
    
    for i = 1 : populationSize
        value = 0;
        for j = 1 : dimension
            value = value + abs(best(j) - population(i, j));
        end
        distances(i) = value;
    end

    minFitness = min(fitness); maxMinFitness = max(fitness) - minFitness;
    minDistance = min(distances); maxMinDistance = max(distances) - minDistance;

    for i = 1 : populationSize
        normFitness(i) = 1 - ((fitness(i) - minFitness) / maxMinFitness);
        normDistances(i) = (distances(i) - minDistance) / maxMinDistance;
        divDistances(i) = (1-w)*normFitness(i) + w*normDistances(i);
    end

    [~, index] = max(divDistances);

end

end

