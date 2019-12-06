function rdm = bst_compute_rdm(opts)
 % Compute perferamce 
%  opts.reference_solution;
%  opts.computed_solution;

%% Evaluate the quality of the result using RDM 
rdm = zeros(1,size(opts.computed_solution,2));
for ii=1:size(opts.computed_solution,2)
    rdm(ii) = norm(opts.computed_solution(:,ii)/norm(opts.computed_solution(:,ii)) - opts.reference_solution(:,ii)/norm(opts.reference_solution(:,ii)));
end

rdm = rdm*100/2;
end