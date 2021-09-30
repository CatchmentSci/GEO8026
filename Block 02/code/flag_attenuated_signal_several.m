function [flag] = flag_attenuated_signal_several (dataIn, min_std, sample_num, flag)

% Checks to see if the data being assessed varies from one point to the
% next. If the difference between adjacent data points is less than is
% expected a flag is returned according to the rules assigned in the 
% lecture.

% Syntax: [flag] = flag_attenuated_signal_several (dataIn, min_std, sample_num, flag)

% Inputs:
%  dataIn = the array containing the data to be assessed. It should be a
%  nx1 array i.e. one collumn
%  min_std = the minimum allowable standard deviation for the specified
%  window (defined by sample_num)
%  sample_num = the number of samples that are evaulated to determine the
%  standard deviation. This is the size of the moving window. 
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

% We can also extract small periods from the data array and check for the
% variance and change over a group of samples. This may be useful if we
% would expect to see periodicity in the data
a = 1;
b = 1;
while a < length(dataIn) - sample_num - 1 % we can use a while loop for this
    temp_data       = dataIn(a:a + sample_num,1);
    std_test(b,1)   = nanstd(temp_data);
    
    if std_test(b,1) < min_std
        if ~exist('cell_bad','var')
            cell_bad = [];
        end
        cell_bad = [cell_bad; a:a + sample_num];
    end
    
    a               = a + sample_num;
    b               = b + 1;
    clear temp_data
end

% If the cell_bad doesn't exist (i.e. all data is good, create an empty
% array)
if ~exist('cell_bad','var')
    cell_bad = []; % assign the flag as 2 i.e. unchecked
end

% If the data was previously flagged as being good
if flag_new(cell_bad) == 1 | 2
    flag_new(cell_bad) = 3; % overwrite it as being questionable
end

flag = flag_new; % replace the data in the var flag with flag_new 


end
