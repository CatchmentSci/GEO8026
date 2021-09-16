clear all;

% Define the working folder that you are using
folderIn = 'C:\Users\Matt\OneDrive - Newcastle University\Teaching\2021 - 22\GEO8026\_git\GEO8026_21_22\Practical 3\';

% Download example data from gitHub
websave([folderIn 'h915a'] , 'https://raw.githubusercontent.com/CatchmentSci/GEO8026_21_22/main/Practical%203/h915a.csv'); % Download data

% read the data into MATLAB 
C       = readtable([folderIn 'h915a.csv']); 

% As the data is from a secondary source we are having to deal with the
% date time format provided. In this case it is in the format [y, m, d,
% HH]. This is closest to the datevector format in MATLAB [y, m, d, HH, MM,
% SS] so we will modify the data so that it matches this format. You will
% note that the data is missing the minute (MM) and seconds (SS). For the
% purposes of this we will assume that they were collected at 0 min and 0
% second i.e. on the hour (as we are using an hourly dataset).

% Let's get the data so that it matches the date vector format [y, m, d, HH, MM, SS]
% Extract the first four columns from table to double - note the curly braces do this
datetime_vector         = C{:,1:4}; 
% add two columns (representing the minutes and seconds which were missing)
datetime_vector(:,5:6)  = 0; 

% Now we have the data in a format that MATLAB recognises we can convert it
% to a range of differnt formats. Here we will conver it to 'datetime',
% 'string', 'cell', and 'numeric'. These are useful for different purposes
% in MATLAB (see lecture).
datetime            = datetime(datetime_vector); % convert the vector to datetime type
datetime_string     = datestr(datetime_vector); % convert the vector to a string type
datetime_cellstr    = cellstr(datetime_string); % convert the string type to cell type
datetime_numeric    = datenum(datetime_string); % convert the string type to cell type


% However, let's now look into an example where the dates is not in the
% vector format, but is instead a  cellstr (view 'datetime_cellstr' to see). 
% This is probably the most common form of datetime. So let's try and load 
% an example of this data into MATLAB and convert it to a numeric format.
websave([folderIn 'h915a_datestr'] , 'https://raw.githubusercontent.com/CatchmentSci/GEO8026_21_22/main/Practical%203/h915a_datestr.csv'); % Download data
D                   = readtable([folderIn 'h915a_datestr.csv']); 
datetime2           = D{:,1}; % extract the data as datetime type
datetime_cell2      = cellstr(datetime2); % convert the vector to a cell type
datetime_numeric2   = datenum(datetime2); % option 1 - converting from datetime to numeric
datetime_numeric2   = datenum(datetime_cell2, 'dd/mm/yyyy HH:MM'); % option 2 - converting from cell to numeric


% Now we have both the 
