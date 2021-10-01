function [dtNum,TAVG] = extracting_noaa(folderIn)

% Download the climate data from NOAA and as it is a .tar.gz file
% (i.e. compressed), we need to unzip it before loading it into the Workspace:
websave([folderIn 'noaa_data'] , 'https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd_gsn.tar.gz'); % Download data
untar([folderIn 'noaa_data.gz'],[folderIn 'extractedData']) % Decompress the archive

% Within the extractedData folder you will find a series of files.
% These are ascii files with a extension of .dly. Because the .dly extension
% is one that MATLAB doesn't automatically recognise we need to tell it that
% it is a text format using the 'FileType' command. Lets read a file into
% MATLAB. You can feel free to modify the filename as you see fit:
C   = readtable([folderIn 'extractedData\ghcnd_gsn\FR000007650.dly'],...
    'Delimiter','*',... % Rather than specifying a delimiter we will bring each row in as one cell. We can do this as the file is an ascii with fixed number of characters per line
    'ReadVariableNames', false,... % state that the first row does not contain the variable name
    'FileType', 'text'); % state that it is a text file
C   = table2cell(C); % the raw data is stored in C

% With using any secondary dataset there is likely to be some manipulation
% that we need to do before we have it in a useable format, and have the
% data that we want. Reading the metadata provided with the dataset is
% essential and will tell you what you need to know. This can usually be
% found close to where the data is downloaded from and in this instance is
% here: https://www.ncei.noaa.gov/pub/data/ghcn/v4/readme.txt. From the
% metadata, we can see that the 1st to 11th characters in each row contain
% the station names. So lets extract those:
a_func          = @(x) x(1:11); % Get characters 1 - 11 from each cell
allStations     = cellfun(a_func, C, 'UniformOutput', false); % run the command
uniqueStations  = unique(allStations); % find unique cell names

% As expected, the data file contains data from only one station. But within
% this file there are a range of different measurements. Let's find out
% what these are by checking for unique element values which are stored
% in characters 18-21:
a_func          = @(x) x(18:21); % Get characters 18 - 21 from each cell
elements        = cellfun(a_func, C, 'UniformOutput', false); % run the command
uniqueElements  = unique(elements); % find unique cell names

% We can see that there are four variables that are stored: PRCP, TAVG,
% TMAX, TMIN. For the purposes of this we will use TAVG.
% The yyyy and mm of measurements is displayed in the 12th - 17th characters.
% Let's extract that for each measurement:
a_func          = @(x) x(12:17); % Get characters 12:17 from each cell
temp1           = cellfun(a_func, C, 'UniformOutput', false); % run the command
yyyymm          = str2double(temp1);
clear a_func temp1 % clean up temporary variables

% Finally, from reading the metadata we can see that the measurements that
% are made on each day are stored in the 22-26, 30-34,...262-266 characters.
% We can use a loop to % extract these:
a = 22;
b = 26;
c = 1;
while a < 266
    a_func                      = @(x) x(a:b); % Get characters a:b from each cell
    temp1                       = cellfun(a_func, C, 'UniformOutput', false); % run the command
    temp1                       = strrep(temp1,' ','');
    dataOut(1:length(temp1),c)  = str2double(temp1);
    
    % These increase on each loop
    a = b + 4;  % e.g. to move from 26 to 30
    b = a + 4;  % e.g. to move from 30 to 34
    c = c + 1;
    
    clear a_func temp1
end

% looking at the metadata we can see that a value of -9999 is missing data.
% for convenience we will change these to NaN.
remove          = find(round(dataOut) == -9999);
dataOut(remove) = NaN;

% The above code block extracts all of the measurement data and stores them
% in a matrix where each column represents one day i.e. 1 - 31, and each
% row represents a combination of the elements and the month. If we want to
% extract only the TAVG (average temperature) data we would run the following:
temp0        = strfind(uniqueElements,'TAVG'); % search elements for those that are the TAVG
temp00       = ~cellfun(@isempty,temp0); % find cells that are not empty
temp1        = strfind(elements,uniqueElements(temp00)); % search elements for those that are the TAVG
temp2        = ~cellfun(@isempty,temp1); % find cells that are not empty
tavg_idx     = find(temp2 == 1); % the index of all TAVG measurements
datetime     = yyyymm(tavg_idx); % extract the yyyy mm data time for each row

% Lets extract the data from the necessary arrays
for aa = 1:length(dataOut)
    temp3        = ~isnan(dataOut(aa,:)); % for each row check which cells have data
    dataIdx      = find(temp3 == 1);
    for a = 1:length(dataIdx)
        % We need to add zeros to days below 10 to ensure consistency of
        % format
        n_strPadded{aa,a}  = sprintf( '%02d', dataIdx(a));
        temp4       = [{char(string(num2cell(yyyymm(aa,1))))} n_strPadded{aa,a}];
        temp5       = {[temp4{:}]};
        dtNum(aa,a) = datenum(temp5,'yyyymmdd');
    end
end

TAVG = dataOut(tavg_idx,:);
TAVG = TAVG(:);
dtNum = dtNum(tavg_idx,:);
dtNum = dtNum(:);
[dtNum,idx] = sort(dtNum);
TAVG = TAVG(idx);
idx_keep = find(dtNum>0);
dtNum = dtNum(idx_keep);
TAVG = TAVG(idx_keep);
idx_rem = find(TAVG == 0);
TAVG(idx_rem) = NaN;
TAVG = TAVG./10;

end