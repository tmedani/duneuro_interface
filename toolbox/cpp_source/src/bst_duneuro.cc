/*
This script is used to compute the leadfield matrix for EEG and/or MEG using duneuro toolbox

It use as an argumenet the configuration file *.ini

The generated binary are integrated to Brainstorm Toolbox software, for windows, mac and Linux.

Takfarinas MEDANI, 
Juan GPC,

Dicember 2019

*/
#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <algorithm>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <numeric>

#include <dune/common/exceptions.hh>         // We use exceptions
#include <dune/common/parallel/mpihelper.hh> // An initializer of MPI
#include <dune/common/parametertree.hh>
#include <dune/common/parametertreeparser.hh>
#include <duneuro/common/matrix_utilities.hh>
#include <duneuro/io/dipole_reader.hh>
#include <duneuro/io/field_vector_reader.hh>
#include <duneuro/meeg/meeg_driver_factory.hh>
#include <duneuro/io/projections_reader.hh>

#include <toto/bst_helper_fcns.h>

void runEEG(const Dune::ParameterTree &config)
{
    // set up driver
    auto driver = duneuro::MEEGDriverFactory<3>::make_meeg_driver(config);

    //read electrodes file
    auto electrodes =
        duneuro::FieldVectorReader<double, 3>::read(config.sub("electrodes"));
    driver->setElectrodes(electrodes, config.sub("electrodes"));

    // read dipoles file
    auto dipoles = duneuro::DipoleReader<double, 3>::read(config.sub("dipoles"));

    std::shared_ptr<duneuro::DenseMatrix<double>> transfer{nullptr};

    //check if transfer matrix file exists
    if (fileExists("eeg_transfer.dat"))
    {
        printf("\nThis is a known model. Load the transfer Matrix.\n");

        //read transfer file
        transfer = readTransferMatrix("eeg_transfer.dat");
    }
    else
    {
        printf("\nThis is a new model. Compute the transfer Matrix.\n");
        // compute transfer matrix
        transfer = driver->computeEEGTransferMatrix(config.sub("solution"));

        //save transfer matrix to a file
        saveTransferMatrix("eeg_transfer.dat", transfer);
    }

    // compute numerical solution transferred
    auto solution = driver->makeDomainFunction();
    std::vector<std::vector<double>> num_transfer =
        driver->applyEEGTransfer(*transfer, dipoles, config.sub("solution"));
    //save files
    saveLFfiles("eeg_lf", num_transfer, dipoles.size(), electrodes.size());
}

void runMEG(const Dune::ParameterTree &config)
{
    // set up driver
    auto driver = duneuro::MEEGDriverFactory<3>::make_meeg_driver(config);
    auto coils = duneuro::FieldVectorReader<double, 3>::read(config.sub("coils"));
    auto projections =
        duneuro::ProjectionsReader<double, 3>::read(config.sub("coils")); //tak check this!!!
    driver->setCoilsAndProjections(coils, projections);

    // read dipoles
    auto dipoles = duneuro::DipoleReader<double, 3>::read(config.sub("dipoles"));

    std::shared_ptr<duneuro::DenseMatrix<double>> transfer{nullptr};

    //check if transfer matrix file exists
    if (fileExists("meg_transfer.dat"))
    {
        printf("\nThis is a known model. Load the transfer Matrix.\n");

        //read transfer file
        transfer = readTransferMatrix("meg_transfer.dat");
    }
    else
    {
        printf("\nThis is a new model. Compute the transfer Matrix.\n");
        // compute transfer matrix
        transfer = driver->computeMEGTransferMatrix(config.sub("solution"));

        //save transfer matrix to a file
        saveTransferMatrix("meg_transfer.dat", transfer);
    }

    auto solution = driver->makeDomainFunction();

    // compute numerical solution transferred
    auto num_transfer =
        driver->applyMEGTransfer(*transfer, dipoles, config.sub("solution"));

    //save files
    saveLFfiles("meg_lf", num_transfer, dipoles.size(), coils.size());
}

int main(int argc, char **argv)
{
    bool displayHelp{false};
    bool isMEG{false};
    bool isEEG{false};

    try
    {
        //parse inputs
        for (int i = 1; i < argc; ++i)
        {
            std::string inputParam{argv[i]};
            if (inputParam == std::string("--help") || inputParam == std::string("-h") || inputParam == std::string("--h") || inputParam == std::string("?"))
            {
                displayHelp = true;
                break;
            }
            else if (inputParam == std::string("--meg"))
            {
                isMEG = true;
                isEEG = false;
                break;
            }
            else if (inputParam == std::string("--eeg"))
            {
                isMEG = false;
                isEEG = true;
                break;
            }
        }

        if (displayHelp)
        {
            print_help_msg();
            return -1;
        }

        if (argc != 3)
        {
            std::cerr << "\nPlease provide a config .ini file and the execution mode.\n";
            std::cerr << "The application needs two inputs. You can type --help for help.\n";
            print_help_msg();
            return -1;
        }

        Dune::MPIHelper::instance(argc, argv);
        Dune::ParameterTree config;                              // declare une variable config de type Parameter tree
        Dune::ParameterTreeParser::readINITree(argv[1], config); // lire le fichier de config ini ou mini et store dans la variable config
                                                                 // execute la function run declarer en haut
        if (isEEG)
            runEEG(config);

        if (isMEG)
            runMEG(config);

        return 0;
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
