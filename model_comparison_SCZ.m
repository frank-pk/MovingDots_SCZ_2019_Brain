function model_comparison_SCZ

% load data
load modelling_SCZ_data.mat
num_ctr = 23; num_pat = 20;

% sum BIC within the groups
BICc = BIC(1:num_ctr,:);
sumBIC_ctr = sum(BICc(:,2:end) - BICc(:,1),1);
BICp = BIC(num_ctr+1:end,:);
sumBIC_pat = sum(BICp(:,2:end) - BICp(:,1),1);

%%  RFX (BMS)

% (a weird trick that makes it work; VBA toolbox hates me) 
VBA_groupBMC(log_evidence(1:num_ctr,:));
clear options; close
%

options.families = {[1, 2, 3, 4], [5, 6, 7, 8]};
options.modelNames = model_type;
[~,out_ctr] = VBA_groupBMC(log_evidence(1:num_ctr,:)',options); close
[~,out_pat] = VBA_groupBMC(log_evidence(num_ctr+1:end,:)',options); close

% protected exceedance probabilities(pep)
out_ctr.pep = (1-out_ctr.bor)*out_ctr.ep + out_ctr.bor/length(out_ctr.ep);
out_pat.pep = (1-out_pat.bor)*out_pat.ep + out_pat.bor/length(out_pat.ep);

fprintf('\nControls:\n')
for i = 1:numel(model_type)    
    fprintf('%d. EP = %.3f (%s)\n',i,out_ctr.pep(i),model_type{i})
end
fprintf('\nPatients:\n')
for i = 1:numel(model_type)    
    fprintf('%d. EP = %.3f (%s)\n',i,out_pat.pep(i),model_type{i})
end

E_ctr = sqrt(out_ctr.Vf/numel(out_ctr.Vf));
E_pat = sqrt(out_pat.Vf/numel(out_pat.Vf));

%% FFX    
figure('WindowStyle','docked','Name', 'Model_comparisons'); hold on
subplot(2,2,1); hold on
barh(flip(sumBIC_ctr),'k');        
set(gca, 'Yticklabel', flip({model_type{2:end}}), 'Ytick', 1:numel(model_type)-1, 'LineWidth', 1, 'Fontsize', 13); 
xlabel('\Sigma BIC - \Sigma BIC_{BayesP}')
title('Controls'); set(gca, 'Fontsize', 10, 'box', 'on','LineWidth',1);

subplot(2,2,2); hold on
barh(flip(sumBIC_pat),'k');        
set(gca, 'Yticklabel', flip({model_type{2:end}}), 'Ytick', 1:numel(model_type)-1, 'LineWidth', 1, 'Fontsize', 13); 
xlabel('\Sigma BIC - \Sigma BIC_{BayesP}')
title('Patients'); set(gca, 'Fontsize', 10, 'box', 'on','LineWidth',1);

%% Re-plotting RFX results in a compatible format (+ BF BayesP vs Bayes inset)

subplot(2,2,3); hold on
barh(flip(out_ctr.pep),'k');        
%errorbar(flip(out_ctr.Ef),1:numel(model_type),E_ctr,'horizontal','.','MarkerSize',10,'LineWidth',2,'CapSize',1)
set(gca, 'Yticklabel', flip(model_type), 'Ytick', 1:numel(model_type),  'LineWidth', 1, 'Fontsize', 13); 
xlabel('Protected exceedance probability'); xlim([0 1])
title('Controls'); set(gca, 'box', 'on', 'linewidth', 1)

axes('Position',[.275 .2 .16 .16]); 
BF = 2*(log_evidence(1:num_ctr,1)' - log_evidence(1:num_ctr,2)');
myboxplot('fill',BF','symbol','k','widths',0.12,'positions',[1-0.24],'colors','w'); hold on
plotSpread(BF', 'spreadWidth',0.5,'distributionColors','k','distributionMarkers','o'); 
xlim([0.8 1.2]); ylim([-60 100]); 
distributionPlot(BF','widthDiv',[3 3],'showMM',0,'histOri','right','color','k');
set(gca, 'XTick','', 'Fontsize', 10, 'box', 'on','LineWidth',1);
xlabel('2*ln(BF) (BAYES\_P vs BAYES)')

subplot(2,2,4); hold on
barh(flip(out_pat.pep),'k');        
%errorbar(flip(out_pat.Ef),1:numel(model_type),E_pat,'horizontal','.','MarkerSize',10,'LineWidth',2,'CapSize',1)
set(gca, 'Yticklabel', flip(model_type), 'Ytick', 1:numel(model_type),  'LineWidth', 1, 'Fontsize', 13); 
xlabel('Protected exceedance probability'); xlim([0 1])
title('Patients'); set(gca, 'box', 'on', 'linewidth', 1)

axes('Position',[.715 .2 .16 .16]); 
BF = 2*(log_evidence(num_ctr+1:end,1)'- log_evidence(num_ctr+1:end,2)');
myboxplot('fill',BF','symbol','k','widths',0.12,'positions',[1-0.24],'colors','w'); hold on
plotSpread(BF', 'spreadWidth',0.5,'distributionColors','k','distributionMarkers','o'); 
xlim([0.8 1.2]); ylim([-40 30]); 
distributionPlot(BF','widthDiv',[3 3],'showMM',0,'histOri','right','color','k');
set(gca, 'XTick','', 'Fontsize', 10, 'box', 'on','LineWidth',1);
xlabel('2*ln(BF) (BAYES\_P vs BAYES)')

    
end
