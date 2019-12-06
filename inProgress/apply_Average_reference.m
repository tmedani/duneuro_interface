function cfg = apply_Average_reference(cfg)

    % substract the mean or not from the electrode
    if cfg.lfAvrgRef == 1
         if sum(cfg.lf_fem_transfer(1,:)) == 0
             disp('Transforming from elec1 reference to average reference');
            cfg.lf_fem_transfer  = cfg.lf_fem_transfer  - (mean(cfg.lf_fem_transfer ,1));
         else
             disp('The average reference is the output of duneuro, please check the mini file');
         end
        %lf_fem = lf_fem - lf_fem(1,:);
    end
    
end