function bst_display_leadField_graph(opts)
% Input
% opts.reference_solution = opts.lf_ana_bst;
% opts.reference_solution_name = 'Analytic';
%
% opts.computed_solution1 = opts.lf_fem_simbio;
% opts.computed_solution1_name = 'SimBio';
%
%  opts.computed_solution2 = opts.lf_bem;
%  opts.computed_solution2_name = 'OpenMeeg';

%  opts.computed_solution3 = opts.lf_bem;
%  opts.computed_solution3_name = 'OpenMeeg';

%  opts.method = 'sum';

if ~isfield(opts,'method'); opts.method = 'sum'; end % default value

figure;
if isfield(opts,'reference_solution')
    switch opts.method
        case 'sum'
            v1 = sum((opts.reference_solution),2);
        case 'mean'
            v1 = mean((opts.reference_solution),2);
        otherwise
            v1 = sum((opts.reference_solution),2);
    end
    h(1) = plot(v1,'rs','markersize',10); hold on;
    if isfield(opts,'reference_solution')
        LFnames{1} = opts.reference_solution_name;
    else
        LFnames{1} = 'reference';
    end
end

if isfield(opts,'computed_solution1')
    switch opts.method
        case 'sum'
            v1 = sum((opts.computed_solution1),2);
        case 'mean'
            v1 = sum((opts.computed_solution1),2);
        otherwise
            v1 = sum((opts.computed_solution1),2);
    end
    h(2) = plot(v1,'ko','markersize',10); hold on;
    if isfield(opts,'computed_solution1_name')
        LFnames{2} = opts.computed_solution1_name;
    else
        LFnames{2} = 'solution1';
    end
end

if isfield(opts,'computed_solution2')
    switch opts.method
        case 'sum'
            v1 = sum((opts.computed_solution2),2);
        case 'mean'
            v1 = sum((opts.computed_solution2),2);
        otherwise
            v1 = sum((opts.computed_solution2),2);
    end
    h(3) = plot(v1,'b.','markersize',10); hold on;
    if isfield(opts,'computed_solution2_name')
        LFnames{3} = opts.computed_solution2_name;
    else
        LFnames{3} = 'solution2';
    end
end

if isfield(opts,'computed_solution3')
    switch opts.method
        case 'sum'
            v1 = sum((opts.computed_solution3),2);
        case 'mean'
            v1 = sum((opts.computed_solution3),2);
        otherwise
            v1 = sum((opts.computed_solution3),2);
    end
    h(4) = plot(v1,'g*','markersize',10); hold on;
    if isfield(opts,'computed_solution3_name')
        LFnames{4} = opts.computed_solution3_name;
    else
        LFnames{4} = 'solution2';
    end
end

hl =legend(h,LFnames);
grid on; grid minor;
set(hl,'fontsize',24)
xlabel('Electrode Index','fontsize',24);
ylabel('V (volts)','fontsize',24);
title(['Contribution of the "' opts.method '" of all the dipoles on the electrodes' ],'fontsize',20);
end
