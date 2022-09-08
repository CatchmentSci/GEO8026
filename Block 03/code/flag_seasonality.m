function [flag] = flag_seasonality (dataIn, minIn, maxIn, rangeIn, flag)

% Now that you have run the gross test, you can run this on a subset of
% the data and vary the min and max acceptable values accordingly.
% Checks to see if the data being assessed falls within the user expected 
% range for a particular part of the dataset. If it does not fall within 
% the expected range then the flag array is modified according to the rules 
% assigned in the lecture.

% Syntax: [flag] = flag_seasonality (dataIn, minIn, maxIn, rangeIn flag)

% Inputs:
%  dataIn = the array containing the data to be assessed. It should be a
%  nx1 array i.e. one collumn
%  minIn = minimum value possible for the sensor e.g. 0
%  maxIn = maximum value possible for the sensor e.g. 100
%  rangeIn = subset of the data to be examined e.g. [1,200] would assess
%  the first 200 values in dataIn.
%  flag (optional) = If a flag array has previously been created this can
%  be used as an input

% Outputs:
% flag = The data will be assigned a flag which describes the status of the data. 
% If the flag array was used as an input variable it will be overwritten

%% Start of function
% This produces a logic array output with ones representing cells where the
% statement has been evaluated as true and zero where it is false
logic_below     = dataIn < minIn;
logic_above     = dataIn > maxIn;
logic_bad       = or(logic_below,logic_above); % check to see if either of the statements are true

% As an alternative to using logic controls, we can extracts the cell
% numbers where the statements below are true
cell_below  = find(dataIn < minIn); % find below the min level
cell_above  = find(dataIn > maxIn); % find above the maximum level
cell_bad    = sort([cell_below; cell_above]); % sort and concatenate data

% this is the only change from the gross test which limits the evaluation
% to the data range that is defined
within_range    = ismember(cell_bad,rangeIn(1):rangeIn(2)); % check to see if values are in both arrays
cell_bad        = cell_bad(within_range); % only extract those that are

% If the flag array doesn't exist, create one
if ~exist('flag','var') % check to see if flag array exists
    flag_new(1:length(dataIn),1) = 2; % assign the flag as 2 i.e. unchecked
else
    flag_new = flag; % create a copy of the existing variable
end

% If the data was previously flagged as being good
if flag_new(cell_bad) == 1 | 2
    flag_new(cell_bad) = 4; % overwrite the flagged cells as being bad
end

flag = flag_new; % replace the data in the var flag with flag_new 

end
