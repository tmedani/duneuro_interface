#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <algorithm>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>

#include <dune/common/exceptions.hh>         // We use exceptions
#include <dune/common/parallel/mpihelper.hh> // An initializer of MPI
#include <dune/common/parametertree.hh>
#include <dune/common/parametertreeparser.hh>
#include <duneuro/common/matrix_utilities.hh>
#include <duneuro/io/dipole_reader.hh>
#include <duneuro/io/field_vector_reader.hh>
#include <duneuro/meeg/meeg_driver_factory.hh>

class duneuroController
{
public:
    void duneuroController();

private:
    int mDims;
    
    std::unique_ptr<MEEGDriverInterface<mDims>> mpDriver;
    std::vector<Dune::FieldVector<ctype,mDims> mElectrodes;
    
    std::vector<duneuro::Dipole<double,mDims> dipoles;





};

void duneuroController::duneuroController()
    mDims{3}
{  

}


