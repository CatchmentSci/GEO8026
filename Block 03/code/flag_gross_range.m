function [flag] = flag_gross_range (dataIn, minIn, maxIn, flag)

% Checks to see if the data being assessed falls within the expected span
% of the sensor. If it does not fall within the expected range then the
% flag array is modified according to the rules assigned in the lecture.

% Syntax: [flag] = flag_gross_range (dataIn, minIn, maxIn, flag)

% Inputs:
%  dataIn = the array containing the data to be assessed. It should be a
%  nx1 array i.e. one collumn
%  minIn = minimum value possible for the sensor
%  maxIn = maximum value possible for the sensor
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

% replace not checked with checked
temp            = find(flag_new==2);
flag_new(temp)  = 1;

flag = flag_new; % replace the data in the var flag with flag_new 

end

% Now that you have managed to run this script and evaluate for values
% which fall outside of the sensor range, modify the script so that you can
% evaluate whether the data falls within the user-defined range and if it
% does not assign the relevant flag. To do this you will need to define
% some additional inputs. These will be the user defined range of
% acceptable values. Ensure that you don't overwrite flags that have failed
% the previous test (value 4) with a suspect value (3).



