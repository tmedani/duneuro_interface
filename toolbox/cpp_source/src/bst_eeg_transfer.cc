// -*- tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 2 -*-
// vi: set et ts=4 sw=2 sts=2:

#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <algorithm>
#include <dune/common/exceptions.hh>		 // We use exceptions
#include <dune/common/parallel/mpihelper.hh> // An initializer of MPI
#include <dune/common/parametertree.hh>
#include <dune/common/parametertreeparser.hh>
#include <duneuro/common/matrix_utilities.hh>
#include <duneuro/io/dipole_reader.hh>
#include <duneuro/io/field_vector_reader.hh>
#include <duneuro/meeg/meeg_driver_factory.hh>
#include <iostream>
#include <fstream>
#include <iterator>
#include <string>
#include <vector>


bool transferFileExists(const std::string& fname)
{
	if(FILE * file = fopen(fname.c_str(),"r"))
	{
		fclose(file);
		return true;
	} else {
		return false;
	}
}

inline int powInt(int x, int y)
{
	for(int i = 0; i < y; i++)
	{
		x *= 10;
	}
	return x;
}

size_t parseInt(std::vector<int> &v)
{
	size_t sum{0};
	int len{v.size()};
	for(int i; i<len;i++)
	{
		int n{v.at(len-(i+1)) - '0'};
		sum += powInt(n,i);
	}
	return sum;
}


int run(const Dune::ParameterTree &config)
{
	// set up driver
	auto driver = duneuro::MEEGDriverFactory<3>::make_meeg_driver(config); // creation du driver
	auto electrodes =
		duneuro::FieldVectorReader<double, 3>::read(config.sub("electrodes")); // lecture des electrode a partir du mini/config file
	driver->setElectrodes(electrodes, config.sub("electrodes"));			   // rajouter les electrode au driver

	// read dipoles
	auto dipoles = duneuro::DipoleReader<double, 3>::read(config.sub("dipoles")); // lire le fichier dipole
	
	//check if transfer matrix file exists
	if(transferFileExists("transferOut.dat"))
	{
		//read transfer file
		std::ifstream fin("transferOut.dat",std::ios::binary);

		//read header
		char separatorChar=':';
		char h1,h2;
		fin.read(&h1,sizeof(h1));
		fin.read(&h2,sizeof(h2));
		if(!(h1 == separatorChar && h2 == separatorChar))
		{
			printf("\nSomething went wrong while reading the binary file.\n");
			return 0;
		}
		std::vector<int> nRowsVec;
		std::vector<int> nColsVec;
		char digit;
		fin.read(&digit,sizeof(digit));
		while(digit != separatorChar)
		{
			nRowsVec.push_back(static_cast<int>(digit));
			fin.read(&digit,sizeof(digit));
		}			
		fin.read(&h2,1);
		if(h2 != separatorChar)
		{
			printf("\nSomething went wrong while reading the binary file.\n");
			return 0;
		}
		fin.read(&digit,sizeof(digit));
		while(digit != separatorChar)
		{
			nColsVec.push_back(static_cast<int>(digit));
			fin.read(&digit,sizeof(digit));
		}			
		fin.read(&h1,1);
		size_t nRows{parseInt(nRowsVec)};
		size_t nCols{parseInt(nColsVec)};
		
		//now read the data
		duneuro::DenseMatrix<double> matrixTransfer(nRows,nCols,0.);
		std::unique_ptr<duneuro::DenseMatrix<double>> transfer(&matrixTransfer);
		fin.read(reinterpret_cast<char *>(transfer->data()),nRows*nCols*sizeof(double));

		// compute numerical solution transferred
		auto solution = driver->makeDomainFunction();
		auto num_transfer =
			driver->applyEEGTransfer(*transfer, dipoles, config.sub("solution")); // calcul de la solution transfer
		
		//save leadfields
		std::ofstream femFileOut("vfem-transfer.dat",std::ios::binary);
		femFileOut << "::" << dipoles.size() << "::" << electrodes.size() << "::";
		femFileOut.write(reinterpret_cast<char *>(&num_transfer),dipoles.size() * electrodes.size() * sizeof(num_transfer[0][0]));
		femFileOut.close();

	} else {
		// compute transfer matrix
		auto transfer = driver->computeEEGTransferMatrix(config.sub("solution")); // calcul de la matrice de transfer
		//save transfer matrix to a file
		std::ofstream fout("transferOut.dat", std::ios::binary);
		fout << "::" << transfer->rows() << "::" << transfer->cols() << "::";
		fout.write(reinterpret_cast<char *>(transfer->data()), transfer->rows() * transfer->cols() * sizeof(transfer->data()[0]));
		fout.close();

		auto solution = driver->makeDomainFunction();
		// compute numerical solution transferred
		auto num_transfer =
			driver->applyEEGTransfer(*transfer, dipoles, config.sub("solution")); // calcul de la solution transfer

		//save leadfields
		std::ofstream femFileOut("vfem-transfer.txt",std::ios::binary);
		femFileOut << "::" << dipoles.size() << "::" << electrodes.size() << "::";
		femFileOut.write(reinterpret_cast<char *>(&num_transfer),dipoles.size() * electrodes.size() * sizeof(num_transfer[0][0]));
		femFileOut.close();
	}

	return 0;
}

int main(int argc, char **argv)
{
	try
	{
		// Maybe initialize MPI
		Dune::MPIHelper::instance(argc, argv);
		if (argc != 2)
		{
			std::cerr << "please provide a config file";
			return -1;
		}
		Dune::ParameterTree config;								 // declare une variable config de type Parameter tree
		Dune::ParameterTreeParser::readINITree(argv[1], config); // lire le fichier de config ini ou mini et store dans la variable config
		return run(config);										 // execute la function run declarer en haut
	}
	catch (Dune::Exception &e)
	{
		std::cerr << "Dune reported error: " << e << std::endl;
		return -1;
	}
	catch (...)
	{
		std::cerr << "Unknown exception thrown!" << std::endl;
		return -1;
	}
}

