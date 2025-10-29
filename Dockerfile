FROM almalinux/9-base


ENV GEANT4_VERSION=11.3.2
ENV GEANT4_INSTALL_DIR=/opt/geant4
ENV GEANT4_SOURCE_DIR=/opt/geant4-source

RUN dnf update -y && \
    dnf install -y \
        cmake \
        gcc-c++ \
        git \
        wget \
        vim \
        nano \
        which \
        python3 \
        python3-pip \
        libX11-devel \
        libXmu-devel \
        libXt-devel \
        libXext-devel \
        libXft-devel \
        libXrender-devel \
        mesa-libGL-devel \
        mesa-libGLU-devel \
        qt5-qtbase-devel \
        qt5-qtx11extras-devel \
        motif-devel \
        expat-devel && \
    dnf clean all

# Try to install xerces-c from EPEL if needed
RUN dnf install -y epel-release && \
    dnf install -y xerces-c-devel && \
    dnf clean all

RUN mkdir -p ${GEANT4_INSTALL_DIR}

WORKDIR /tmp
RUN wget https://cern.ch/geant4-data/releases/lib4.11.3.p02/Linux-g++11.5.0-Alma9.tar.gz -O geant4-binary.tar.gz && \
    tar -xzf geant4-binary.tar.gz -C ${GEANT4_INSTALL_DIR} --strip-components=1 && \
    rm geant4-binary.tar.gz

RUN mkdir -p ${GEANT4_INSTALL_DIR}/share/Geant4/data
WORKDIR ${GEANT4_INSTALL_DIR}/share/Geant4/data

RUN wget https://cern.ch/geant4-data/datasets/G4NDL.4.7.1.tar.gz && \
    tar -xzf G4NDL.4.7.1.tar.gz && rm G4NDL.4.7.1.tar.gz && \
    wget https://cern.ch/geant4-data/datasets/G4EMLOW.8.6.1.tar.gz && \
    tar -xzf G4EMLOW.8.6.1.tar.gz && rm G4EMLOW.8.6.1.tar.gz && \
    wget https://cern.ch/geant4-data/datasets/G4PhotonEvaporation.6.1.tar.gz && \
    tar -xzf G4PhotonEvaporation.6.1.tar.gz && rm G4PhotonEvaporation.6.1.tar.gz && \
    wget https://cern.ch/geant4-data/datasets/G4RadioactiveDecay.6.1.2.tar.gz && \
    tar -xzf G4RadioactiveDecay.6.1.2.tar.gz && rm G4RadioactiveDecay.6.1.2.tar.gz && \
    wget https://cern.ch/geant4-data/datasets/G4PARTICLEXS.4.1.tar.gz && \
    tar -xzf G4PARTICLEXS.4.1.tar.gz && rm G4PARTICLEXS.4.1.tar.gz && \
    wget https://cern.ch/geant4-data/datasets/G4PII.1.3.tar.gz && \
    tar -xzf G4PII.1.3.tar.gz && rm G4PII.1.3.tar.gz && \
    wget https://cern.ch/geant4-data/datasets/G4RealSurface.2.2.tar.gz && \
    tar -xzf G4RealSurface.2.2.tar.gz && rm G4RealSurface.2.2.tar.gz && \
    wget https://cern.ch/geant4-data/datasets/G4SAIDDATA.2.0.tar.gz && \
    tar -xzf G4SAIDDATA.2.0.tar.gz && rm G4SAIDDATA.2.0.tar.gz

RUN echo "# Geant4 Environment Setup" >> /etc/bashrc && \
    echo "export GEANT4_INSTALL=${GEANT4_INSTALL_DIR}" >> /etc/bashrc && \
    echo "export PATH=${GEANT4_INSTALL_DIR}/bin:\$PATH" >> /etc/bashrc && \
    echo "export LD_LIBRARY_PATH=${GEANT4_INSTALL_DIR}/lib:\$LD_LIBRARY_PATH" >> /etc/bashrc && \
    echo "source ${GEANT4_INSTALL_DIR}/bin/geant4.sh" >> /etc/bashrc && \
    echo "export G4NEUTRONHPDATA=${GEANT4_INSTALL_DIR}/share/Geant4/data/G4NDL4.7.1" >> /etc/bashrc && \
    echo "export G4LEDATA=${GEANT4_INSTALL_DIR}/share/Geant4/data/G4EMLOW8.6.1" >> /etc/bashrc && \
    echo "export G4LEVELGAMMADATA=${GEANT4_INSTALL_DIR}/share/Geant4/data/PhotonEvaporation6.1" >> /etc/bashrc && \
    echo "export G4RADIOACTIVEDATA=${GEANT4_INSTALL_DIR}/share/Geant4/data/RadioactiveDecay6.1.2" >> /etc/bashrc && \
    echo "export G4PARTICLEXSDATA=${GEANT4_INSTALL_DIR}/share/Geant4/data/G4PARTICLEXS4.1" >> /etc/bashrc && \
    echo "export G4PIIDATA=${GEANT4_INSTALL_DIR}/share/Geant4/data/G4PII1.3" >> /etc/bashrc && \
    echo "export G4REALSURFACEDATA=${GEANT4_INSTALL_DIR}/share/Geant4/data/RealSurface2.2" >> /etc/bashrc && \
    echo "export G4SAIDXSDATA=${GEANT4_INSTALL_DIR}/share/Geant4/data/G4SAIDDATA2.0" >> /etc/bashrc

RUN wget https://cern.ch/geant4-data/datasets/G4ENSDFSTATE.3.0.tar.gz && \
    tar -xzf G4ENSDFSTATE.3.0.tar.gz && rm G4ENSDFSTATE.3.0.tar.gz

RUN echo "export G4ENSDFSTATEDATA=${GEANT4_INSTALL_DIR}/share/Geant4/data/G4ENSDFSTATE3.0" >> /etc/bashrc


WORKDIR /workspace

# Keep container running indefinitely
CMD ["tail", "-f", "/dev/null"]
