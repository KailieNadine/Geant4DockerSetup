To build and run the container:

docker compose up -d

Running the simulation examples:

docker exec -it geant4 bash

cd geant4_data
git clone https://gitlab.cern.ch/geant4/geant4.git
cd geant4/examples/../{example}
mkdir build
cd build
cmake ..
make -j
./{example name}