% lag = the lag of the moving window
% threshold = the z-score at which the algorithm signals 
% influence = the influence (between 0 and 1) of new signals on the mean and standard deviation. 

% For example, a lag of 5 will use the last 5 observations to smooth the data. 
% A threshold of 3.5 will signal if a datapoint is 3.5 standard deviations away 
% from the moving mean. And an influence of 0.5 gives signals half of the influence
% that normal datapoints have.

% Brakel, J.P.G. van (2014). "Robust peak detection algorithm using z-scores". 

function [signals,avgFilter,stdFilter] = ThresholdingAlgo(y,lag,threshold,influence)
% Initialise signal results
signals = zeros(length(y),1);
% Initialise filtered series
filteredY = y(1:lag+1);
% Initialise filters
avgFilter(lag+1,1) = mean(y(1:lag+1));
stdFilter(lag+1,1) = std(y(1:lag+1));
% Loop over all datapoints y(lag+2),...,y(t)
for i=lag+2:length(y)
    % If new value is a specified number of deviations away
    if abs(y(i)-avgFilter(i-1)) > threshold*stdFilter(i-1)
        if y(i) > avgFilter(i-1)
            % Positive signal
            signals(i) = 1;
        else
            % Negative signal
            signals(i) = -1;
        end
        % Make influence lower
        filteredY(i) = influence*y(i)+(1-influence)*filteredY(i-1);
    else
        % No signal
        signals(i) = 0;
        filteredY(i) = y(i);
    end
    % Adjust the filters
    avgFilter(i) = mean(filteredY(i-lag:i));
    stdFilter(i) = std(filteredY(i-lag:i));
end
% Done, now return results
end
