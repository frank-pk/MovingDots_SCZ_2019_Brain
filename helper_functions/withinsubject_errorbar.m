function [mean_y, err_y] = withinsubject_errorbar(x, y, color, linst)

n_angles = numel(x);
y_adjusted = y-repmat(nanmean(y, 2), [1, n_angles]); % + mean(mean(y, 2)); % adding grand mean does not change the err bars...
Y_err = nanstd(y_adjusted)/sqrt(size(y,1));
Y = nanmean(y);

if nargin ==4
    errorbar(x, Y, Y_err, 'Color', color,'LineStyle', linst, 'LineWidth', 2);
elseif nargin ==3
    errorbar(x, Y, Y_err, 'Color', color, 'LineWidth', 2);
else
    errorbar(x, Y, Y_err, 'LineWidth', 2);
end


mean_y = Y;
err_y = Y_err;
