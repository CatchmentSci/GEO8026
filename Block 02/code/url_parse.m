function [dataOut] = url_parse (urlIn)

% example command:
%[dataOut] = url_parse ('http://uhslc.soest.hawaii.edu/data/csv/fast/hourly/h021.csv');

sea_level_data  = urlread(urlIn);
newStr          = split(sea_level_data);
out             = regexp(newStr, ',' , 'split');
cellsz          = cell2mat(cellfun(@length,out,'uni',false));
mode_cell_sz    = mode(cellsz);
use_idx         = find(cellsz == mode_cell_sz);
C2              = vertcat(out{use_idx});
dataOut         = str2double(C2);