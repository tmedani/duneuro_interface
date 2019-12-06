function cfg = bst_generate_sphere_fem_model(cfg)

% TODO : help
% create meshsphere
[~, ~, cfg] = bst_mesh_sphere_surface(cfg);
[~, ~, cfg]  = bst_mesh_sphere_volume(cfg);
% [~, cfg]  = bst_generate_electrode_on_sphere(cfg);
% cfg = bst_generate_dipole_in_sphere(cfg);

end