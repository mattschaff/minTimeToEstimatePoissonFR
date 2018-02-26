function output = minTimeToEstimatePoissonFR(firingRates)
% minTimeToEstimatePoissonFR Returns minimum time to estimate firing rates 
% of Poisson neurons, within 1% or 5% of real FR 
    % INPUT
        % firingRates - 1XN vector of firing rates, in Hz
    % OUTPUT
        % output - Nx3 matrix (N= number of firing rates given)
            % column 1: firing rates, in Hz
            % column 2: seconds required to be within 5% of real FR
            % column 3: seconds required to be within 1% of real FR
    % Note: This calculates firing rates with the classical equation:
        % FR = spikes/time (no kernels or bayes)
    %%
    % set firing rates
    if exist('firingRates', 'var') == 0
        firingRates = 5:5:100;
    end
    output = zeros([numel(firingRates) 3]);
    dt = 1/1000; % bin size (.001 s)
    % loop through firing rates
    for i=1:numel(firingRates)
        output(i,1) = firingRates(i);
        fr = firingRates(i);
        disp(['Calculating minimum FR estimation time for ' num2str(fr) ' Hz']);
        reachedFivePercent = false;
        reachedOnePercent = false;
        numSeconds = .5;
        % only iterate for loop after 5% and 1% thresholds are reached
        while reachedFivePercent == false %|| reachedOnePercent == false
            nBins = 1000*numSeconds;
            estFiringRates = zeros([1000 1]);
            
            % generate 1000 Poisson neurons for this trial time
            for j=1:1000
              estFiringRates(j) = sum(rand(1, nBins) < fr*dt)/numSeconds;
            end
            %disp(mean(abs((fr - estFiringRates)/fr)));
            % 5% threshold
            if mean(abs((fr - estFiringRates)/fr)) < .05 && reachedFivePercent == false
                reachedFivePercent = true;
                output(i,2) = numSeconds;
            end
            % 1% threshold
%             if mean(abs((fr - estFiringRates)/fr)) < .01
%                 reachedOnePercent = true;
%                 output(i,3) = numSeconds;
%             end
            disp(numSeconds);
            numSeconds = numSeconds + .5; % increase time of trial by .5 seconds
        end
    end
    save('output.mat', 'output');
end