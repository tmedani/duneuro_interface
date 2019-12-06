// Version adapted from the test_eeg_forward.cc for bst application
// Takfarinas Medani 
// October 10th, 2019 : clean the main script, 
//                      remove not relevant parts  and add an output file

// -*- tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*-
// vi: set et ts=4 sw=2 sts=2:



#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <algorithm>
#include <dune/common/exceptions.hh>         // We use exceptions
#include <dune/common/parallel/mpihelper.hh> // An initializer of MPI
#include <dune/common/parametertree.hh>
#include <dune/common/parametertreeparser.hh>
#include <duneuro/io/dipole_reader.hh>
#include <duneuro/io/field_vector_reader.hh>
#include <duneuro/meeg/meeg_driver_factory.hh>
#include <iostream>
#include <fstream>
#include <iterator>
#include <string>
#include <vector>


void run(const Dune::ParameterTree& config) {
	// set up driver
	auto driver = duneuro::MEEGDriverFactory<3>::make_meeg_driver(config);
	auto electrodes =
		duneuro::FieldVectorReader<double, 3>::read(config.sub("electrodes"));
	driver->setElectrodes(electrodes, config.sub("electrodes"));

	// read dipoles
	auto dipoles = duneuro::DipoleReader<double, 3>::read(config.sub("dipoles"));

	// create storage for solution
	auto solution = driver->makeDomainFunction();

	// store output in an output tree
	//Dune::OutputTree output(config.get<std::string>("output.filename") + "." +
		//config.get<std::string>("output.extension"));
	//==== open the output file 
	std::ofstream myfile;
	myfile.open("Vfem-direct.txt");
	// TODO : use binary file as input instead of txt

	//==== 
	for (unsigned int i = 0; i < dipoles.size(); ++i) {
		auto dip = dipoles[i];

		// compute numerical solution
		driver->solveEEGForward(dipoles[i], *solution, config.sub("solution"));
		auto num = driver->evaluateAtElectrodes(*solution);		
		auto dipole = dipoles[i];

		for (unsigned int j = 0; j < electrodes.size(); ++j)
		{
			myfile << num[j] << " ";
		}
		myfile << "\n";

		std::vector<std::array<double, 3>> elec;
		std::array<double, 3> tmp;
		for (auto i : electrodes) 
		{
			std::copy_n(i.begin(), 3, tmp.begin());
			elec.push_back(tmp);
		}

	}
	//==== 
	myfile.close();
}

int main(int argc, char** argv) {
	try {
		// Maybe initialize MPI
		Dune::MPIHelper::instance(argc, argv);
		if (argc != 2) {
			std::cerr << "please provide a config file";
			return -1;
		}
		Dune::ParameterTree config;
		Dune::ParameterTreeParser::readINITree(argv[1], config);
		run(config);
	}
	catch (Dune::Exception& e) {
		std::cerr << "Dune reported error: " << e << std::endl;
		return -1;
	}
	catch (...) {
		std::cerr << "Unknown exception thrown!" << std::endl;
		return -1;
	}
}