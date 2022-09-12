% Generate some data which increases very rapidly at the start and then
% slows considerably
clear XData_mod YData_mod
xData = randperm(1000,200);
yData = log10(xData); % generate random x-axis data
yData = awgn( yData , 25, 'measured' );

% Run a linear regression
[xData,yData]       = prepareCurveData(xData,yData); % checks for and removes NaN
t_out               = length(xData);
xData(1:t_out,2)    = 1; % Prep the data for regression with a column of ones
[b,~,r,~,stats]     = regress(yData,xData); % Run the regression and pull out the coefficients, residuals, stats
Original_r2         = stats(1,1); % Pull out the R2 value
Original_p          = stats(1,3); % Pull out the p value

%Let's plot the results:
f1 = figure(); hold on;
ax1       = subplot(2,2,1); hold on;
set(f1,'units','normalized','outerposition',[0 0 0.5 1]); 
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
% The residual vs. fit plot can be used to detect non-linearity and/or unequal variance.#
fitted  = b(2) + b(1).*xData(:,1); % caluclate the fitted estimate for each xObs
ax2     = subplot(2,2,2); hold on
h(3)    = scatter(fitted,r,... % plot the fit vs residuals
    'MarkerEdgeColor', [0.5,0.5,0.5],...
    'MarkerFaceColor', [0.5,0.5,0.5],...
    'SizeData', 10);
xlabel('y Predicted','FontSize', 14);
ylabel('residuals','FontSize', 14);

XData_mod               = log10(xData(:,1)); % here we transform the xObs by taking the log of x
t_out                   = length(XData_mod);
XData_mod(1:t_out,2)    = 1; % Prep the data for regression with a column of ones
[b,~,r,~,stats]         = regress(yData,XData_mod); % Run the regression and pull out the coefficients, residuals, stats
Original_r2             = stats(1,1); % Pull out the R2 value
Original_p              = stats(1,3); % Pull out the p value

%Let's plot the results:
fitted  = b(2) + b(1).*XData_mod(:,1); % caluclate the fitted estimate for each xObs
ax3     = subplot(2,2,3); hold on
h(4)    = scatter(XData_mod(:,1),yData,... % we need to specify only the column due to the column of ones
    'MarkerEdgeColor', [0.5,0.5,0.5],...
    'MarkerFaceColor', [0.5,0.5,0.5],...
    'SizeData', 10);
ylabel('y Obs','FontSize', 14);
xlabel('x Obs','FontSize',14);

intervals   = min(XData_mod):0.01:max(XData_mod);  % we need to specify the range of values to calculate the fit for.
h(5)        = plot(intervals,b(2) + b(1).*intervals,'k-'); % Plot the best-fit: b1 = slope, b2 = intecept
ylabel('y Obs','FontSize', 14);
xlabel('log10(xObs)','FontSize', 14);

h_leg(2) = legend(h(5), ['y = ' num2str(b(2)) '+' num2str(b(1)) 'log10(xObs)']);
legend boxoff ;
set(h_leg(2),'Location','best');

% Let's examine the residuals
% The residual vs. fit plot can be used to detect non-linearity and/or unequal variance.
ax4     = subplot(2,2,4); hold on
h(6)    = scatter(fitted,r,... % plot the fit vs residuals
    'MarkerEdgeColor', [0.5,0.5,0.5],...
    'MarkerFaceColor', [0.5,0.5,0.5],...
    'SizeData', 10);
xlabel('y Predicted','FontSize', 14);
ylabel('residuals','FontSize', 14);