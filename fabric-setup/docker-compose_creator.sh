#!/bin/bash
#


HOME=${PWD}

# Sed crypto-config-temp.yaml
 
echo "**********************************************************************"
echo "DOCKER-COMPOSE-UPDATE"    "----->         docker-compose-temp-default.yml"
echo "**********************************************************************"


cd $HOME
cp docker-compose-temp-default.yml docker-compose-temp.yml


export ORDERER_COUNT=$(grep 'ORDERER_COUNT' .env | cut -d '=' -f2)
export ORG_COUNT=$(grep 'ORG_COUNT' .env | cut -d '=' -f2) 
echo "ORDERER & ORG COUNTS:- "$ORDERER_COUNT   $ORG_COUNT


ORDERER_PORT_DEFAULT=7050
ORDERER_HELPER=1000
ORDERER_PORT=$(($(($(($ORDERER_COUNT-1))*$ORDERER_HELPER))+$ORDERER_PORT_DEFAULT));
echo $ORDERER_PORT

for ((k=$ORDERER_COUNT;k>=1;k--)); do
 echo $k
 PORT=$ORDERER_PORT

# sed -i '/#Insert1/a i Line one to insert \
#second new line to insert \
#third new line to insert' ./docker-compose-temp.yml


 sed -i '/#Insert1/a\ ${ORDERER'${k}'_HOSTNAME}_${ORDERER1_DOMAIN}: \
  container_name: ${ORDERER'${k}'_HOSTNAME}_${ORDERER1_DOMAIN}  \
  image: hyperledger/fabric-orderer:${IMAGE_TAG1}  \
  environment:  \
    - ORDERER_GENERAL_LOGLEVEL=ERROR  \
    - ORDERER_GENERAL_LISTENADDRESS=0.0.0.0  \
    - ORDERER_GENERAL_GENESISMETHOD=file  \
    - ORDERER_GENERAL_GENESISFILE=/etc/hyperledger/configtx/genesis.block  \
    - ORDERER_GENERAL_LOCALMSPDIR=/etc/hyperledger/orderer/msp  \
    # enabled TLS  \
    - ORDERER_GENERAL_TLS_ENABLED=${TLS_ENABLED}  \
    - ORDERER_GENERAL_TLS_PRIVATEKEY=/etc/hyperledger/orderer/tls/server.key  \
    - ORDERER_GENERAL_TLS_CERTIFICATE=/etc/hyperledger/orderer/tls/server.crt  \
    - ORDERER_GENERAL_TLS_ROOTCAS=[/etc/hyperledger/orderer/tls/ca.crt]  \
    - ORDERER_GENERAL_TLS_CLIENTAUTHREQUIRED=false  \
    - ORDERER_GENERAL_TLS_CLIENTROOTCAS=[/etc/hyperledger/orderer/tls/ca.crt]  \
    - ORDERER_GENERAL_LOCALMSPID=${ORDERER1_NAME}MSP  \
    - ORDERER_KAFKA_TOPIC_REPLICATIONFACTOR=1  \
    - ORDERER_KAFKA_VERBOSE=true  \
    - ORDERER_GENERAL_CLUSTER_CLIENTCERTIFICATE=/etc/hyperledger/orderer/tls/server.crt  \
    - ORDERER_GENERAL_CLUSTER_CLIENTPRIVATEKEY=/etc/hyperledger/orderer/tls/server.key  \
    - ORDERER_GENERAL_CLUSTER_ROOTCAS=[/etc/hyperledger/orderer/tls/ca.crt]  \
  volumes:  \
    - ${ORDERER'${k}'_PATH}/config/:/etc/hyperledger/configtx  \
    - ${ORDERER'${k}'_PATH}/crypto-config/ordererOrganizations/${ORDERER1_DOMAIN}/orderers/${ORDERER'${k}'_HOSTNAME}_${ORDERER1_DOMAIN}:/etc/hyperledger/orderer  \
    - ${ORDERER'${k}'_PATH}/hyp-data/orderer:/var/hyperledger/production/orderer  \
  working_dir: /opt/gopath/src/github.com/hyperledger/fabric/orderer  \
  command: orderer  \
  ports:  \
   - '${PORT}':7050  \
  restart: always  \
  logging:  \
    driver: "json-file"  \
    options:  \
      max-file: 5  \
      max-size: 10m  \
  networks:  \
    - dev  ' ./docker-compose-temp.yml
#PORT INCREMENT
ORDERER_PORT=$(( $ORDERER_PORT - $ORDERER_HELPER ))
sed -i '/#Insert1/a    \ ' ./docker-compose-temp.yml
done;
wait



CA_PORT_DEFAULT=7054
CA_HELPER=1000
CA_PORT=$(($(($(($ORG_COUNT-1))*$CA_HELPER))+$CA_PORT_DEFAULT));
echo $CA_PORT


COUCH_PORT_DEFAULT=6984
COUCH_HELPER=1000
COUCH_PORT=$(($(($(($ORG_COUNT-1))*$COUCH_HELPER))+$COUCH_PORT_DEFAULT));
echo $COUCH_PORT


PEER1_PORT_DEFAULT=7051
PEER1_HELPER=1000
PEER1_PORT=$(($(($(($ORG_COUNT-1))*$PEER1_HELPER))+$PEER1_PORT_DEFAULT));
echo $PEER1_PORT


PEER2_PORT_DEFAULT=7053
PEER2_HELPER=1000
PEER2_PORT=$(($(($(($ORG_COUNT-1))*$PEER2_HELPER))+$PEER2_PORT_DEFAULT));
echo $PEER2_PORT

for ((k=$ORG_COUNT;k>=1;k--)); do
 echo $k
 PORT=$CA_PORT



sed -i '/#Insert2/a\ ${PEERORG'${k}'_HOSTNAME1}_${PEERORG'${k}'_DOMAIN}: \
  container_name: ${PEERORG'${k}'_HOSTNAME1}_${PEERORG'${k}'_DOMAIN} \
  image: hyperledger/fabric-peer:${IMAGE_TAG1} \
  environment: \
    - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock \
    - CORE_PEER_ID=${PEERORG'${k}'_HOSTNAME1}_${PEERORG'${k}'_DOMAIN} \
    - CORE_PEER_LOCALMSPID=${PEERORG'${k}'_NAME}MSP \
    - CORE_PEER_ADDRESS=${PEERORG'${k}'_HOSTNAME1}_${PEERORG'${k}'_DOMAIN}:7051 \
    - CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS=couchdb_${PEERORG'${k}'_HOSTNAME1}_${PEERORG'${k}'_DOMAIN}:5984 \
    - CORE_PEER_GOSSIP_BOOTSTRAP=${PEERORG'${k}'_HOSTNAME1}_${PEERORG'${k}'_DOMAIN}:7051 \
    - CORE_PEER_GOSSIP_EXTERNALENDPOINT=${PEERORG'${k}'_HOSTNAME1}_${PEERORG'${k}'_DOMAIN}:7051 \
    - CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7052 \
    - CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=${COMPOSE_PROJECT_NAME}_dev \
    - FABRIC_LOGGING_SPEC=ERROR \
    - CORE_CHAINCODE_LOGGING_LEVEL=ERROR \
    - CORE_PEER_GOSSIP_USELEADERELECTION=true \
    - CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/peer/msp \
    - CORE_PEER_GOSSIP_ORGLEADER=false \
    - CORE_PEER_PROFILE_ENABLED=true \
    #TLS Settings \
    - CORE_PEER_TLS_ENABLED=${TLS_ENABLED} \
    - CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/peer/tls/server.crt \
    - CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/peer/tls/server.key \
    - CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/peer/tls/ca.crt \
    - CORE_PEER_TLS_CLIENTAUTHREQUIRED=false \
    - CORE_PEER_TLS_CLIENTCERT_FILE=/etc/hyperledger/peer/tls/server.crt \
    - CORE_PEER_TLS_CLIENTKEY_FILE=/etc/hyperledger/peer/tls/server.key \
    - CORE_PEER_TLS_CLIENTROOTCAS_FILES=/etc/hyperledger/peer/tls/ca.crt \
    #Couch DB config \
    - CORE_LEDGER_STATE_STATEDATABASE=CouchDB \
    - CORE_LEDGER_STATE_COUCHDBCONFIG_USERNAME=admin \
    - CORE_LEDGER_STATE_COUCHDBCONFIG_PASSWORD=P@ss123 \
  volumes: \
    - /var/run/:/host/var/run/ \
    - ${ORG'${k}'_PATH}/config/:/etc/hyperledger/configtx \
    - ${ORG'${k}'_PATH}/crypto-config/peerOrganizations/${PEERORG'${k}'_DOMAIN}/peers/${PEERORG'${k}'_HOSTNAME1}_${PEERORG'${k}'_DOMAIN}:/etc/hyperledger/peer \
    - ${ORG'${k}'_PATH}/crypto-config/peerOrganizations/${PEERORG'${k}'_DOMAIN}/users:/etc/hyperledger/users \
    - ${ORG'${k}'_PATH}/hyp-data/peer/:/var/hyperledger/production \
  working_dir: /opt/gopath/src/github.com/hyperledger/peer \
  command: peer node start \
  restart: always \
  ports: \
    - '${PEER1_PORT}':7051 \
    - '${PEER2_PORT}':7053 \
  logging: \
    driver: "json-file" \
    options: \
      max-file: 5 \
      max-size: 10m \
  networks: \
    - dev \
  depends_on: \
    - couchdb_${PEERORG'${k}'_HOSTNAME1}_${PEERORG'${k}'_DOMAIN} \
    - ca_${PEERORG'${k}'_NAME} \
    #ORDERER_GROUP ' ./docker-compose-temp.yml

#PORT DECREMENT
PEER1_PORT=$(( $PEER1_PORT - $PEER1_HELPER ))
PEER2_PORT=$(( $PEER2_PORT - $PEER2_HELPER ))

sed -i '/#Insert2/a    \ ' ./docker-compose-temp.yml

sed -i '/#Insert2/a\ couchdb_${PEERORG'${k}'_HOSTNAME1}_${PEERORG'${k}'_DOMAIN}: \
  container_name: couchdb_${PEERORG'${k}'_HOSTNAME1}_${PEERORG'${k}'_DOMAIN} \
  ports: \
   - '${COUCH_PORT}':5984 \
  image: hyperledger/fabric-couchdb:${IMAGE_TAG2} \
  volumes: \
   - ${ORG'${k}'_PATH}/hyp-data/couchdb:/opt/couchdb/data \
  environment: \
   - COUCHDB_USER=admin \
   - COUCHDB_PASSWORD=P@ss123 \
  networks: \
   - dev \
  volumes: \
    - ${ORG'${k}'_PATH}/hyp-data/couchdb/:/opt/couchdb/data \
  logging: \
    driver: "json-file" \
    options: \
      max-file: 5 \
      max-size: 10m \
  restart: always \
  depends_on: \
    #ORDERER_GROUP ' ./docker-compose-temp.yml

#PORT DECREMENT
COUCH_PORT=$(( $COUCH_PORT - $COUCH_HELPER ))

 sed -i '/#Insert2/a    \ ' ./docker-compose-temp.yml

 
 sed -i '/#Insert2/a\ ca_${PEERORG'${k}'_NAME}: \
  image: hyperledger/fabric-ca:${IMAGE_TAG1} \
  environment: \
   - FABRIC_CA_HOME=/etc/hyperledger/fabric-ca-server \
   - FABRIC_CA_SERVER_CA_NAME=ca_${PEERORG'${k}'_NAME} \
   - FABRIC_CA_SERVER_TLS_ENABLED=${TLS_ENABLED} \
   - FABRIC_CA_SERVER_TLS_CERTFILE=/etc/hyperledger/fabric-ca-server-config/ca.${PEERORG'${k}'_DOMAIN}-cert.pem \
   - FABRIC_CA_SERVER_TLS_KEYFILE=/etc/hyperledger/fabric-ca-server-config/PRIVATE_KEY_'${k}' \
  ports: \
   - '${CA_PORT}':7054 \
  command: sh -c "fabric-ca-server start --ca.certfile /etc/hyperledger/fabric-ca-server-config/ca.${PEERORG'${k}'_DOMAIN}-cert.pem --ca.keyfile /etc/hyperledger/fabric-ca-server-config/PRIVATE_KEY_'${k}' -b admina:adminpw -d" \
  volumes: \
   - ${ORG'${k}'_PATH}/crypto-config/peerOrganizations/${PEERORG'${k}'_DOMAIN}/ca/:/etc/hyperledger/fabric-ca-server-config \
  container_name: ca_${PEERORG'${k}'_NAME} \
  networks: \
  - dev \
  restart: always \
  logging: \
    driver: "json-file" \
    options: \
      max-file: 5 \
      max-size: 10m \
  depends_on: \
    #ORDERER_GROUP ' ./docker-compose-temp.yml
#PORT DECREMENT
CA_PORT=$(( $CA_PORT - $CA_HELPER ))

sed -i '/#Insert2/a    \ ' ./docker-compose-temp.yml



done;
wait








sed -i '/#Insert3/a\ cli: \
  container_name: cli \
  image: hyperledger/fabric-tools:${IMAGE_TAG1} \
  tty: true \
  environment: \
   - SYS_CHANNEL=byfn-sys-channel \
   - GOPATH=/opt/gopath \
   - CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock \
   - FABRIC_LOGGING_SPEC=ERROR \
   - CORE_PEER_ID=cli \
   - CORE_PEER_ADDRESS=${PEERORG1_HOSTNAME1}_${PEERORG1_DOMAIN}:7051 \
   - CORE_PEER_LOCALMSPID=${PEERORG1_NAME}MSP \
   - CORE_PEER_TLS_ENABLED=${TLS_ENABLED} #Should be kept to true if not running event listenr \
   - CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEERORG1_DOMAIN}/peers/${PEERORG1_HOSTNAME1}_${PEERORG1_DOMAIN}/tls/server.crt \
   - CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEERORG1_DOMAIN}/peers/${PEERORG1_HOSTNAME1}_${PEERORG1_DOMAIN}/tls/server.key \
   - CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEERORG1_DOMAIN}/peers/${PEERORG1_HOSTNAME1}_${PEERORG1_DOMAIN}/tls/ca.crt \
   - CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEERORG1_DOMAIN}/users/Admin@${PEERORG1_DOMAIN}/msp \
   - CORE_PEER_TLS_CLIENTAUTHREQUIRED=false \
   - CORE_PEER_TLS_CLIENTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEERORG1_DOMAIN}/users/${PEERORG1_DOMAIN}/tls/server.crt \
   - CORE_PEER_TLS_CLIENTKEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEERORG1_DOMAIN}/users/${PEERORG1_DOMAIN}/tls/server.key \
   - CORE_PEER_TLS_CLIENTROOTCAS_FILES=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${PEERORG1_DOMAIN}/users/${PEERORG1_DOMAIN}/tls/ca.crt \
   - CORE_CHAINCODE_KEEPALIVE=10 \
  working_dir: /opt/gopath/src/github.com/hyperledger/fabric/peer \
  command: /bin/bash \
  volumes: \
   - /var/run/:/host/var/run/ \
   - ./../chaincode/:/opt/gopath/src/github.com/chaincode/ \
   - ./crypto-config/:/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ \
   - ./config:/opt/gopath/src/github.com/hyperledger/fabric/peer/configtx \
   - ./scripts:/opt/gopath/src/github.com/hyperledger/fabric/peer/scripts/ \
  networks: \
   - dev \
  logging: \
        driver: "json-file" \
        options: \
            max-file: 5 \
            max-size: 10m \
  depends_on: \
    #ORDERER_GROUP \
    #PEER_GROUP  ' ./docker-compose-temp.yml
  



#Replace orderer
for ((k=$ORDERER_COUNT;k>=1;k--)); do
 echo "orderer group"$k
 #sed -i '/#ORDERER_GROUP/a    - ${ORDERER'${k}'_HOSTNAME}_${ORDERER1_DOMAIN}/g ' ./docker-compose-temp.yml
 sed -i "s/#ORDERER_GROUP/- \${ORDERER${k}_HOSTNAME}_\${ORDERER1_DOMAIN} \n \   #ORDERER_GROUP/g" ./docker-compose-temp.yml
 #sed -i "s/#ORDERER_GROUP/crissi \n \  #ORDERER_GROUP/g" ./docker-compose-temp.yml
done;
 


#Replace peer
for ((k=$ORG_COUNT;k>=1;k--)); do
 echo "org group"$k
 sed -i "s/#PEER_GROUP/- \${PEERORG${k}_HOSTNAME1}_\${PEERORG${k}_DOMAIN} \n \   #PEER_GROUP/g" ./docker-compose-temp.yml
done;
 
 

exit 0