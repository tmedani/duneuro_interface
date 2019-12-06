function mag = bst_compute_mag(opts)
 % Compute perferamce 
%  cfg.reference_solution;
%  cfg.computed_solution;
%% Evaluate the quality of the result using MAG 
mag = sqrt(sum(opts.computed_solution.^2))./sqrt(sum(opts.reference_solution.^2));
end