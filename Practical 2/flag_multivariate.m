function [flag] = flag_multivariate (fileIn, sheetName, max_percent_diff,flag)

% Assesses the nature of the linear relationship between two variables
% through linear regression. Using the regression function the difference
% between the predicted value and the actual value is obtained. If the
% difference between the two values is greater than an threshold then the
% measurement is flagged according to the rules assigned in the lecture.

% Syntax: [flag] = flag_multivariate (dataIn, max_percent_diff,flag)

% Inputs:
%  fileIn = excel spreadsheet containing the data to be assessed
%  max_percent_diff (optional) = maximum allowed difference between expected value
%  and the reported value. If this is not specified, the 95% ci will be
%  calculated (mean ± 1.96 std)
%  flag (optional) = If a flag array has previously been created this can
%  be used as an input

%  Example:
%  [flag] = flag_multivariate ('C:\MSCL_MATLAB2.xls', '146',10,flag)

% Outputs:
% flag = The data will be assigned a flag which describes the status of the data. 
% If the flag array was used as an input variable it will be overwritten

%% Start of function

if ~exist('cell_bad','var')
    cell_bad = [];
end

C = readtable(fileIn,'sheet',sheetName);

% If the flag array doesn't exist, create one
if ~exist('flag','var')
    flag_new(1:numel(C(:,1)),1) = 2; % assign the flag as 2 i.e. unchecked
else
    flag_new = flag; % create a copy of the existing variable
end

xData = C{:,2};
yData = C{:,4};

dlm              = fitlm(xData(:,1),yData(:,1),'Intercept',true);
interceptCoef    = table2array(dlm.Coefficients(1,1)); % intercept
slopeCoef        = table2array(dlm.Coefficients(2,1)); % slope
Pvalue           = table2array(dlm.Coefficients(2,4)); % p-value
R2               = round(dlm.Rsquared.Ordinary,2);
predicted        = interceptCoef + slopeCoef .* xData;
percent_diff     = ((yData - predicted)./yData).*100;

if ~exist('max_percent_diff','var')
    max_percent_diff = std(percent_diff)*1.96; % 95% ci
end

cell_bad_logic   = percent_diff > mean(percent_diff) + max_percent_diff | ...
        percent_diff < mean(percent_diff) - max_percent_diff;
cell_bad         = find(cell_bad_logic);
   
% If the data was previously flagged as being good
if flag_new(cell_bad) == 1 | 2
    flag_new(cell_bad) = 3; % overwrite it as being questionable
end

flag = flag_new;

end
