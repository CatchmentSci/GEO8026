% create some data where yObs increase slowly to changes in xObs when xObs 
% is small, and then the rate of change increases as the value of xObs increases. 
clear XData_mod YData_mod
yData = randperm(1000,200);
xData = sqrt(yData); % generate random x-axis data
xData = awgn( xData , 25, 'measured' );

% Run a linear regression
[xData,yData]       = prepareCurveData(xData,yData); % checks for and removes NaN
t_out               = length(xData);
xData(1:t_out,2)    = 1; % Prep the data for regression with a column of ones
[b,~,r,~,stats]     = regress(yData,xData); % Run the regression and pull out the coefficients, residuals, stats
Original_r2         = stats(1,1); % Pull out the R2 value
Original_p          = stats(1,3); % Pull out the p value

%Let's plot the results:
f3 = figure(); hold on;
ax1_3     = subplot(2,2,1); hold on;
set(f3,'units','normalized','outerposition',[0 0 0.5 1]); 
h(1)      = scatter(xData(:,1),yData,... % we need to specify only the column due to the column of ones
    'MarkerEdgeColor', [0.5,0.5,0.5],...
    'MarkerFaceColor', [0.5,0.5,0.5],...
    'SizeData', 10);

intervals   = min(xData):0.01:max(xData);  % we need to specify the range of values to calculate the fit for.
h(2)        = plot(intervals,b(2) + b(1).*intervals,'k-'); % Plot the best-fit: b1 = slope, b2 = intecept

ylabel('y Obs','FontSize', 14);
xlabel('x Obs','FontSize',14);
h_leg(1) = legend(h(2), ['y = ' num2str(b(2)) '+' num2str(b(1)) 'x']);
legend boxoff ;
set(h_leg(1),'Location','best');

% Let's examine the residuals
% The residual vs. fit plot can be used to detect non-linearity and/or unequal variance.
fitted  = b(2) + b(1).*xData(:,1); % caluclate the fitted estimate for each xObs
ax2_3   = subplot(2,2,2); hold on
h(3)    = scatter(fitted,r,... % plot the fit vs residuals
    'MarkerEdgeColor', [0.5,0.5,0.5],...
    'MarkerFaceColor', [0.5,0.5,0.5],...
    'SizeData', 10);
xlabel('y predicted','FontSize', 14);
ylabel('residuals','FontSize', 14);

XData_mod               = log10(xData(:,1));
yData_mod               = log10(yData(:,1));
t_out                   = length(XData_mod);
XData_mod(1:t_out,2)    = 1; % Prep the data for regression with a column of ones
[b,~,r,~,stats]         = regress(yData_mod,XData_mod); % Run the regression and pull out the coefficients, residuals, stats
Original_r2             = stats(1,1); % Pull out the R2 value
Original_p              = stats(1,3); % Pull out the p value

%Let's plot the results:
ax3_3   = subplot(2,2,3); hold on
h(4)    = scatter(XData_mod(:,1),yData_mod,... % we need to specify only the column due to the column of ones
    'MarkerEdgeColor', [0.5,0.5,0.5],...
    'MarkerFaceColor', [0.5,0.5,0.5],...
    'SizeData', 10);
ylabel('y Obs','FontSize', 14);
xlabel('x Obs','FontSize',14);

intervals   = min(XData_mod):0.01:max(XData_mod);  % we need to specify the range of values to calculate the fit for.
h(5)        = plot(intervals,b(2) + b(1).*intervals,'k-'); % Plot the best-fit: b1 = slope, b2 = intecept
ylabel('log10(y Obs)','FontSize', 14);
xlabel('log10(x Obs)','FontSize', 14);

h_leg(2) = legend(h(5), ['log10(y) = ' num2str(b(2)) '+' num2str(b(1)) ' log10(xObs)' newline ...
    'y = 10^{' num2str(b(2)) ' + ' num2str(b(1)) ' log10(x)}']);
legend boxoff ;
set(h_leg(2),'Location','best');

% Let's examine the residuals
% The residual vs. fit plot can be used to detect non-linearity and/or unequal variance.
fitted  = b(2) + b(1).*XData_mod(:,1); % caluclate the fitted estimate for each xObs
ax4_3   = subplot(2,2,4); hold on
h(6)    = scatter(fitted,r,... % plot the fit vs residuals
    'MarkerEdgeColor', [0.5,0.5,0.5],...
    'MarkerFaceColor', [0.5,0.5,0.5],...
    'SizeData', 10);
xlabel('y predicted','FontSize', 14);
ylabel('residuals','FontSize', 14);