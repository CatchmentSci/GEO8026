function [flag] = flag_attenuated_signal (dataIn, min_abs_change,flag)

% Checks to see if the data being assessed varies from one point to the
% next. If the difference between adjacent data points is less than is
% expected a flag is returned according to the rules assigned in the 
% lecture.

% Syntax: [flag] = flag_attenuated_signal (dataIn, min_abs_change,flag)

% Inputs:
%  dataIn = the array containing the data to be assessed. It should be a
%  nx1 array i.e. one collumn
%  min_abs_change = minimum expected change from between adjacent
%  measurements
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

% We can extract the cell numbers where difference between cells is less
% than the minimum expected change
abs_diff    = abs(diff(dataIn)); % absolute difference between values in adjacent cells
cell_bad    = find(abs_diff < min_abs_change); % find points where difference is less than min threshold
cell_bad    = cell_bad + 1;

% If the data was previously flagged as being good
if flag_new(cell_bad) == 1 | 2
    flag_new(cell_bad) = 4; % overwrite it as being bad
end

flag = flag_new; % replace the data in the var flag with flag_new 

end

% This is a simplification of the kind of signal that we would expect. You
% could enhance this by calculating the change as a percentage of the
% previous value, or look to see whether data is attenuated over a number
% of the previous data points (see flag_attenuated_signal_several)

