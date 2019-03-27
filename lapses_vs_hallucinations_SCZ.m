function lapses_vs_hallucinations_SCZ

% load data
load lapses_75_split_SCZ_data.mat
load Bayes_P_SCZ_data.mat
load behavioral_nostim_SCZ_data.mat
angles = [0,16,32,48,64]; 

for i = 1:numel(nd)
    tot_hal(i) = numel(nd{i});
end

%% Relationship between lapses and hallucinations
figure('WindowStyle','docked','Name', 'Main_lapses_hallucinations'); hold on

subplot(1,2,1); hold on; grid on;    
withinsubject_errorbar(angles, alpha_below75, [0 0.5 0]);
withinsubject_errorbar(angles, alpha_above75, [0.85 0.33 0.098]);
set(gca, 'Xlim', [-5 70],'Ylim', [0 10],'Xtick', angles);
ylabel('Lapse estimations (%)', 'Fontsize',15);
xlabel('Motion direction (deg)', 'Fontsize',15);
set(gca, 'box', 'on', 'linewidth', 1); vline(32, 'k--'); 
legend({'Contrasts below 75% threshold', 'Contrasts above 75% threshold'},'FontSize',12);

subplot(1,2,2); hold on; grid on;    
scatter(tot_hal,100*params(:,end)','MarkerEdgeColor','w', 'MarkerFaceColor', 'k'); hold on;
xlabel('Hallucinations','Fontsize', 16); ylabel('Prior-based lapses (%)', 'Fontsize', 16);
lsline; set(gca, 'box', 'on', 'linewidth', 1); 

    
end