function [flag] = flag_big_roc2 (dataIn, max_percent_change,flag)

% Determines the change in values either side of a measurement. Calculates
% the average of the two adjacent values. If the measurement being
% evalkuated differs from the average of the two adjacent values by a
% user-defined percent then the measurement is flagged according to the rules 
% assigned in the lecture.


% Syntax: [flag] = flag_big_roc2 (dataIn, max_percent_change,flag)

% Inputs:
%  dataIn = the array containing the data to be assessed. It should be a
%  nx1 array i.e. one collumn
%  max_percent_change = maximum allowed difference between expected value
%  (based on the average of previous and following measurement) and the
%  reported value. 
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

if ~exist('cell_bad','var')
    cell_bad = [];
end

for a = 2:length(dataIn)-1
    starter = a-1;
    test    = a; 
    ender   = a+1;
    diff1   = mean([dataIn(ender),dataIn(starter)]);
    
    if (abs(dataIn(test) - diff1)./diff1).*100 > max_percent_change
        cell_bad = [cell_bad; test];
    end
end


% If the data was previously flagged as being good
if flag_new(cell_bad) == 1 | 2
    flag_new(cell_bad) = 3; % overwrite it as being questionable
end

flag = flag_new;

end

