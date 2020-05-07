# Instructions

1. Copy all the binaries (configtxgen & cryptogen) from Hyperledger Fabric, 
  and paste it on  bin directory.

2. Go to the fabric-setup directory and update .env file with respect to your network structure.

 ```cd fabric-setup```

Update the environment file before proceeding further.

```
#Fabricnetwork
##############################################################
COMPOSE_PROJECT_NAME=swarm
TLS_ENABLED=true
IMAGE_TAG1=1.4.4
IMAGE_TAG2=0.4.18
#############################################################
ORG_COUNT=3
ORDERER_COUNT=3
############################################################
PEERORG1_NAME=Org
PEERORG1_DOMAIN=peer_com
PEERORG1_HOSTNAME1=HOSTA
PEERORG2_NAME=OrgA
PEERORG2_DOMAIN=peerA_com
PEERORG2_HOSTNAME1=HOSTA
PEERORG3_NAME=OrgB
PEERORG3_DOMAIN=peerB_com
PEERORG3_HOSTNAME1=HOSTA
##################################################################
ORG1_PATH=/opt/Org
ORG2_PATH=/opt/OrgA
ORG3_PATH=/opt/OrgB
###############################################################
ORDERER1_NAME=Orderer
ORDERER1_DOMAIN=Ordr_com
ORDERER1_HOSTNAME=HostOrderer1
ORDERER2_HOSTNAME=HostOrderer2
ORDERER3_HOSTNAME=HostOrderer3
##################################################################
ORDERER1_PATH=/opt/Orderer1
ORDERER2_PATH=/opt/Orderer2
ORDERER3_PATH=/opt/Orderer3
##########################################################
#Channel name
CHANNEL_NAME=masterchannel
############################################################
```

The organizations & orderers containers are generated based on the corresponding values in the .env file.

The following are the steps for generating the  configtx.yaml, crypto-config.yaml,docker-compose.yml files.

```
./crypto-configtx_creator.sh
```

It will generate the crypto materials for the organizations & orderers along with the  crypto-config-temp.yaml configtx-temp.yaml files.

```
./docker-compose_creator.sh
```

It will generate the docker-compose-temp.yml file.

Execute the update.sh script for the generation of configuration files from these temp files.

```
./update.sh
```