% define color
skin_clr   = [255 213 119]/255;
bone_clr  = [140  85  85]/255;
csf_clr     = [202 50 150]/255;
grey_clr   = [150 150 150]/255;
white_clr  = [250 250 250]/255;

tissuColor5Layer = flip([skin_clr;bone_clr;csf_clr;grey_clr;white_clr]);
tissuColor4Layer = flip([skin_clr;bone_clr;csf_clr;grey_clr]);
tissuColor3Layer = flip([skin_clr;bone_clr;grey_clr]);
tissuColor2Layer = flip([skin_clr;grey_clr]);
tissuColor1Layer = flip([skin_clr]);
