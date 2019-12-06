function err = bst_compute_err(opts)
 % Compute perferamce 
%  opts.reference_solution;
%  opts.computed_solution;
%% Evaluate the quality of the result using mean relative errors 
err = mean(abs (((opts.computed_solution - opts.reference_solution))./((opts.reference_solution))));
err = 100*err;
end