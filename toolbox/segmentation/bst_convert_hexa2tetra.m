function cfg = bst_convert_hexa2tetra(cfg)

method = 3; % refere to gibbon function HELP_hex2tet
[elem,node,ID]=hex2tet(cfg.elem_hex(:,1:8),cfg.node_hex,cfg.elem_hex(:,9),method);

cfg.elem = [elem ID];
cfg.node =  node;

end
