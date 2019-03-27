function plot_violins(g_pat, g_ctr, ylab)
    
    % transform data for t-test and permutation test
    try
        tr_values = boxcox([g_pat' g_ctr']'); % box-cox transformation
    catch
        tr_values = ([g_pat' g_ctr']').^(1/3); % cube root transformation
    end

    tr_g_pat = tr_values(1:length(g_pat));
    tr_g_ctr = tr_values(length(g_pat)+1:end);

    grp = [zeros(1,length(g_pat)),ones(1,length(g_ctr))];

    % violin plots 
    try
        distributionPlot([g_pat' g_ctr']','groups',grp+1,'showMM',6,'color',[0.7 0.7 0.7])
    end
    plotSpread([g_pat' g_ctr']','distributionIdx',grp+1,'distributionColors','k');
 
    ylabel(ylab, 'Fontsize', 13); 
    set(gca, 'Xticklabel', {'Patients','Controls'}, 'Xtick', 1:2,...
    'LineWidth', 1, 'Fontsize', 14, 'Xlim', [0.5 2.5]); set(gca, 'box', 'on', 'linewidth', 1)
    set(gca, 'box', 'on', 'linewidth', 1)

    % compute median difference between groups 
    %[p,h,stats] = ranksum(g_ctr,g_pat); % rank-sum test (aka U test)
    %[~,pt] = ttest2(tr_g_ctr,tr_g_pat); % t-test (on transformed data)
    %[~, pp] = my_permutest(tr_g_ctr, tr_g_pat, 10000, 'both', 'mean', 0); % permutation mean test (on transformed data)
    %[~, anc_p, ~, ~, ~] = mancovan(anc_g,[ones(1,length(g_ctr)) 2*ones(1,length(g_pat))]', anc_Age);
    %title(sprintf('p = %.3f (U) \np = %.3f (t) \np = %.3f (perm)',p,pt,pp),'Fontsize',13)
    %title(sprintf('p = %.3f',p),'Fontsize',13);
    %title(sprintf('p = %.3f (U) \np = %.3f (ANCOVA)',p,anc_p(1)),'Fontsize',13)

end