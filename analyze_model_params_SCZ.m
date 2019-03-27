function analyze_model_params_SCZ

load behavioral_stim_SCZ_data.mat
load Bayes_SCZ_data.mat
load Bayes_P_SCZ_data.mat
angles = [-64 -48 -32 -16 0 16 32 48 64];
num_ctr = 23;

% Separate values into groups
val_ctr = params(1:num_ctr,:);
val_pat = params(num_ctr+1:end,:);

beh = {MU, SIGMA, 100*B};
mod_bp = {bias_m, std_m, 100*lapses_m};
mod_b = {bias_b, std_b, 100*lapses_b};

ylab = {'Bias (deg)', 'Variability (deg)', 'Lapse estimations (%)'};

%% Bayes_P and Bayes model fits
figure('WindowStyle','docked','Name', 'Model_fits_and_params')
for jj = 1:3
        
    subplot(3,4,jj); hold on; grid on
    withinsubject_errorbar(angles, beh{jj}(1:num_ctr,:), 'k'); 
    withinsubject_errorbar(angles, mod_bp{jj}(1:num_ctr,:),[0 0.5 0]); 
    withinsubject_errorbar(angles, mod_b{jj}(1:num_ctr,:), [0.93 0.69 0.12]);

    set(gca, 'Xlim', [-70 70]); %,'Ylim', [13 30.2], 'xtick', 0:20:60, 'FontSize', 16, 'ytick', 15:5:30);
    set(gca,'Xtick', angles)

    ylabel(ylab{jj}, 'Fontsize',14); vline([32 -32], 'k--');
    xlabel('Motion direction (deg)', 'Fontsize',14);
    title('Controls'); set(gca, 'box', 'on', 'linewidth', 1)

    subplot(3,4,jj+4); hold on; grid on
    withinsubject_errorbar(angles, beh{jj}(num_ctr+1:end,:), 'k'); 
    withinsubject_errorbar(angles, mod_bp{jj}(num_ctr+1:end,:),[0 0.5 0]); 
    withinsubject_errorbar(angles, mod_b{jj}(num_ctr+1:end,:), [0.93 0.69 0.12]);

    set(gca, 'Xlim', [-70 70]);
    set(gca,'Xtick', angles)

    ylabel(ylab{jj}, 'Fontsize',14); vline([32 -32], 'k--');
    xlabel('Motion direction (deg)', 'Fontsize',14);
    title('Patients'); set(gca, 'box', 'on', 'linewidth', 1)
end
subplot(3,4,1)
legend('Data','BAYES\_P','BAYES');

%% Draw the acquired priors estimated by Bayes_P
x_p = linspace(-176, 176, 220); x_p = ang2rad(x_p);
rad_params = ang2rad(params(:,1:2));
for i = 1:size(params,1)
    prior(i, :) =  circ_pdf(x_p, -rad_params(i,1), 1/rad_params(i,2).^2) + circ_pdf(x_p, rad_params(i,1),  1/rad_params(i,2).^2);
end
prior = prior./sum(prior, 2);

%separate priors into patients and controls
ctr_prior = prior(1:num_ctr,:); pat_prior = prior(num_ctr+1:end,:);

% sample to smooth out the group priors
pat_s = x_p(discreteRnd(sum(pat_prior),1000))';
pat_KDEfit = circ_ksdensity(pat_s ,x_p); pat_KDEfit = pat_KDEfit/sum(pat_KDEfit);
ctr_s = x_p(discreteRnd(sum(ctr_prior),1000))';
ctr_KDEfit = circ_ksdensity(ctr_s ,x_p); ctr_KDEfit = ctr_KDEfit/sum(ctr_KDEfit);

subplot(3,4,4); hold on; grid on;
for i = 1:num_ctr
    hh = plot(rad2ang(x_p), prior(i,:),'Color',[0 0.7 0],'LineWidth',1);    
    hh.Color(4) = 0.4;    
end

%prettyplot(rad2ang(x_p), ctr_prior, 'k')
%plot(rad2ang(x_p), prior_ctr, 'k','LineWidth',2) % lines only
h2 = plot(rad2ang(x_p), ctr_KDEfit,'Color',[0 0.4 0],'LineWidth',3); % lines only

set(gca, 'Xlim', [-180 180], 'Ylim', [0 0.15] , 'FontSize', 12);
h = vline([-32 32], 'k--'); set(h, 'LineWidth', 1);

xlabel('Motion direction (deg)', 'Fontsize', 14); title('Controls')
ylabel('Prior expectations', 'Fontsize', 14);
set(gca, 'box', 'on', 'linewidth', 1); 

subplot(3,4,8); hold on; grid on;
for i = num_ctr+1:size(prior,1)
    hh = plot(rad2ang(x_p), prior(i,:),'Color',[0 0.7 0],'LineWidth',1);   
    hh.Color(4) = 0.4;
end    

h1 = plot(rad2ang(x_p), pat_KDEfit,'Color',[0 0.4 0],'LineWidth',3); % lines only

set(gca, 'Xlim', [-180 180], 'Ylim', [0 0.15] , 'FontSize', 12);
h = vline([-32 32], 'k--'); set(h, 'LineWidth', 1); title('Patients')
xlabel('Motion direction (deg)', 'Fontsize', 14);
ylabel('Prior expectations', 'Fontsize', 14); 
set(gca, 'box', 'on', 'linewidth', 1); 
    
ylims = {[-20 160], [-10 80], [-5 30], [-0.1 0.6]};
%% Parameter group differences
for i = 1:size(params,2)
    subplot(3,4,i+8); hold on; grid on;
    plot_violins(val_pat(:,i),val_ctr(:,i),params_names(i))
    ylim(ylims{i});
end


end