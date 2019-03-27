function behavioral_nostim_SCZ

fold = 'on';
load behavioral_nostim_SCZ_data.mat
num_ctr = 23; num_pat = 20;

figure('WindowStyle','docked','Name', 'Nostim_SCZ'); hold on;   
for jj=1:2     
    subplot(2,2,jj); hold on
    
    switch jj
        case 1
             ndi = nd(1:num_ctr); nuni = nun(1:num_ctr); nai = na(1:num_ctr);       
        case 2
             ndi = nd(num_ctr+1:end); nuni = nun(num_ctr+1:end); nai = na(num_ctr+1:end); 
    end
    
    ndc=[];nunc=[];nac=[];
    for ii = 1:numel(ndi)
        ndc = [ndc ndi{ii}];
        nunc = [nunc nuni{ii}];
        nac = [nac nai{ii}];
    end
        
    for i = 1:3
        switch i
            case 1
                y = ndc; color = [0 0.5 0];
            case 2
                y  = nunc; color =  [0.8 0 0];
            case 3
                y  = nac; color = [0.9 0.7 0.1];
        end
        
        xx = -176:4:176;
        KDEfit = circ_ksdensity(y,ang2rad(xx));    
        
        if i ==1
            my_vline(rad2ang(ndc),'-');
        end
        
        if strcmp(fold, 'on')   
            mid_bin = round(size(xx,2)/2);
            xx = [xx(:, mid_bin) xx(round(size(xx,2)/2)+1:end)];
            KDEfit = [KDEfit(mid_bin) (KDEfit(:, mid_bin+1:end)+KDEfit(:, mid_bin-1:-1:1))/2];
            
            plot(xx,KDEfit,'color',color,'LineWidth',3);
            vline(32,'k--');
            set(gca, 'xtick',  0:20:200, 'Fontsize', 14,...
            'Xlim', [0 160], 'Ylim', [0 1],'Linewidth', 1.5);   
        else                          
            
            plot(xx,KDEfit,'color',color,'LineWidth',3);           
            vline(32, 'k--'); vline(-32, 'k--')
            set(gca, 'xtick',  -200:40:200, 'Fontsize', 14,...
            'Xlim', [-160 160], 'Ylim', [0 1], 'Linewidth', 1.5);      
        end            
    end
    
    xlabel('Motion direction (deg)', 'Fontsize', 14);
    ylabel('Response probability', 'Fontsize', 14)
    set(gca, 'box', 'on', 'linewidth', 1)
end

legend('Detection', 'No detection', 'All responses')

for i = 1:numel(nd)
    tot_hal(i) = numel(nd{i});
    hal_angles = abs(rad2ang(nd{i}));    
    hal_16w32(i) =  numel(hal_angles(hal_angles>16 & hal_angles <48));
end

subplot(2,2,3); hold on; grid on;
plot_violins(tot_hal(num_ctr+1:end)', tot_hal(1:num_ctr)','Total Hallucinations');

subplot(2,2,4); hold on; grid on;
plot_violins(hal_16w32(num_ctr+1:end)', hal_16w32(1:num_ctr)','Hallucinations \pm32\pm16^{\circ}');



end
