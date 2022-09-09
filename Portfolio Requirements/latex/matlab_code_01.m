function [] = downloadingData(workingDir)

% Inputs:
% workingDir is the folder where the zipped folder will be saved to, and
% where the compressed archive will be extracted to. 
% It should have a trailing backslash e.g. 'C:\New folder\'

% define the name of the downloaded compressed archive
fileName    = 'temp'; 

% specify the url
url         = 'https://newcastle-my.sharepoint.com/:u:/g/personal/nmp65_newcastle_ac_uk/Eftugi0tFOZFiAD6dYaolMIBc-ef7nbshavfZq-uK7FEJg?download=1'; 

% save the archive to the folder and name defined above
S           = websave([workingDir fileName], url); 

% Decompress the archive to the workingDir
unzip([workingDir fileName],[workingDir]) 

end