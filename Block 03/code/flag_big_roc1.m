function [flag] = flag_big_roc1 (dataIn, max_abs_change,flag)

% Checks to see if the rate of change between two adjacent data points is
% greater than would be expected given the monitoring environment. This
% threshold is defined by the operator. If the rate of change is greater
% than anticipated then the flag array is modified according to the rules 
% assigned in the lecture.

% Syntax: [flag] = flag_big_roc1 (dataIn, max_abs_change,flag)

% Inputs:
%  dataIn = the array containing the data to be assessed. It should be a
%  nx1 array i.e. one collumn
%  max_abs_change = maximum expected change  between adjacent measurements
%  flag (optional) = If a flag array has previously been created this can
%  be used as an input

% Outputs:
% flag = The data will be assigned a flag which describes the status of the data. 
% If the flag array was used as an input variable it will be overwritten

%% Start of function

% If the flag array doesn't exist, create one
if ~exist('flag','var')
    flag_new(1:length(dataIn),1) = 2; % assign the flag as 2 i.e. unchecked
else
    flag_new = flag; % create a copy of the existing variable
end

% We can extract the cell numbers where difference between cells is greater
% than the maximum expected change
abs_diff    = abs(diff(dataIn)); % absolute difference between values in adjacent cells
cell_bad    = find(abs_diff > max_abs_change);
cell_bad    = cell_bad + 1;

% If the data was previously flagged as being good
if flag_new(cell_bad) == 1 | 2
    flag_new(cell_bad) = 4; % overwrite it as being bad
end

% replace not checked with checked
temp            = find(flag_new==2);
flag_new(temp)  = 1;

flag = flag_new;

end

