function behavioral_stim_SCZ

fold = 'on';
load behavioral_stim_SCZ_data.mat
num_ctr = 23; num_pat = 20;
angles = [-64,-48,-32,-16,0,16,32,48,64]; 

%% if fold, collapse data across central angle
if strcmp(fold, 'on')
    angles = [0 16 32 48 64];
    MU = [MU(:, 5) (MU(:, 6:9)-MU(:, 4:-1:1))/2];
    SIGMA = [SIGMA(:, 5) (SIGMA(:, 6:9)+SIGMA(:, 4:-1:1))/2];
    B = [B(:, 5) (B(:, 6:9)+B(:, 4:-1:1))/2];
    Det = [Det(:, 5) (Det(:, 6:9)+Det(:, 4:-1:1))/2];
    RT = [RT(:, 5) (RT(:, 6:9)+RT(:, 4:-1:1))/2];  
end     

mu = MU; sigma = SIGMA; alpha = 100*B; rt = RT; det = 100*Det;


%% main performance plots (acquired prior)
varname = {'Bias (deg)', 'Variability (deg)', 'Lapse estimations (%)',...
           'Reaction time (s)', 'Stimulus detection (%)'};
       
varz_pat = {mu(num_ctr+1:end,:), sigma(num_ctr+1:end,:), alpha(num_ctr+1:end,:), rt(num_ctr+1:end,:), det(num_ctr+1:end,:)};
varz_ctr = {mu(1:num_ctr,:), sigma(1:num_ctr,:), alpha(1:num_ctr,:), rt(1:num_ctr,:), det(1:num_ctr,:)};

figure('WindowStyle','docked','Name', 'Main_perf_scz'); hold on
for i = 1:numel(varz_pat)
    subplot(2,3,i); hold on; grid on;    
    withinsubject_errorbar(angles, varz_pat{i},'b');
    withinsubject_errorbar(angles, varz_ctr{i},'k');

    if strcmp(fold, 'on')
        set(gca, 'Xlim', [-5 70],'Xtick', angles);
    else 
        set(gca, 'Xlim', [-70 70],'Xtick',angles);
    end
    
    vline(32, 'k--'); vline(-32, 'k--');
    set(gca, 'box', 'on', 'linewidth', 1, 'Fontsize',13); 
    ylabel(varname{i}, 'Fontsize',15);
    xlabel('Motion direction (deg)', 'Fontsize',15);
end
subplot(2,3,1)
legend('Patients','Controls')


end