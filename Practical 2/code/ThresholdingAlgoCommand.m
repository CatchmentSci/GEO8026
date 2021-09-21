%clear all;

% Data input
y = ans;

% Settings
lag = 672; % the number of datapoints that are used within the moving window
threshold = 3.5; % magnitude of z-score 
influence = 0.2; % influence of 'bad' data on the mean of the window

% Get results
[signals,avg,dev] = ThresholdingAlgo(y,lag,threshold,influence);

figure; 
ax1 = subplot(2,1,1); hold on;
x = 1:length(y); ix = lag+1:length(y);
area(x(ix),avg(ix)+threshold*dev(ix),'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
area(x(ix),avg(ix)-threshold*dev(ix),'FaceColor',[1 1 1],'EdgeColor','none');
plot(x(ix),avg(ix),'LineWidth',1,'Color','cyan','LineWidth',1.5);
plot(x(ix),avg(ix)+threshold*dev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(x(ix),avg(ix)-threshold*dev(ix),'LineWidth',1,'Color','green','LineWidth',1.5);
plot(1:length(y),y,'b');
% Blue is the raw data
% Light blue is the mean of the moving window
% Green is the upper and lower limits - data beyond this is 'bad'

ax2 = subplot(2,1,2);
stairs(signals,'r','LineWidth',1.5); ylim([-1.5 1.5]);
% A value of 1 indicates that the data is higher than the maximum allowed
% A value of zero indicates that the data is good
% A value of -1 indicates that the data is below the minium allowed

linkaxes([ax1,ax2],'x');