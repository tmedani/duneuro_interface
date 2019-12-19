%% ------------- DO NOT MOVE OR REMOVE THIS FILE ----------------------%%
 
outdated....

Content :
bin : folder that contains the binary of duneuro
data_conversion : folder that contains the matlab function to convert the data (mainly the mesh format)
duneuro_interface : folder that contains the matlab codes, that write the differents files used by the duneruo software
example : Folder that contains the a results of computation of the transfer and direct eeg forward problem and some test scripts
mesh_generation : folder contains the code used to generate the volume mesh and the associetes functions
run_duneuro.m : matlab script that run this toolbox and call all the diffrent functions stored in this toolbox.
duneuro_tutorial.m : matlab script that run this toolbox and call all the diffrent functions stored in this toolbox.


Dependencies : 
- Iso2mesh  : 
- Fieldtrip :
---> Fieldtrip/SimBio 
---> Fieldtrip/OpenMeeg

External functions, but distributed within
- Matlab function : 
  mesh_load_gmsh4.m  from SimNibs toolbox :  
  bst_eeg_sph.m      from Brainstorm software :  