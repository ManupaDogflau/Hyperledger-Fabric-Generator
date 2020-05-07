#!/bin/bash
#


HOME=${PWD}

# Sed crypto-config-temp.yaml
 
echo "**********************************************************************"
echo "CRYPTO-CONFIG-UPDATE"    "----->         crypto-config-temp.yaml"
echo "**********************************************************************"


cd $HOME
cp crypto-config-temp-default.yaml crypto-config-temp.yaml


export ORDERER_COUNT=$(grep 'ORDERER_COUNT' .env | cut -d '=' -f2)
export ORG_COUNT=$(grep 'ORG_COUNT' .env | cut -d '=' -f2) 
echo "ORDERER & ORG COUNTS:- "$ORDERER_COUNT   $ORG_COUNT

# - Hostname: ${ORDERER1_HOSTNAME}
#   CommonName: '${ORDERER1_HOSTNAME}_${ORDERER1_DOMAIN}'
#   SANS:
#       - "localhost"
#       - "127.0.0.1"
for ((k=$ORDERER_COUNT;k>=1;k--)); do
#echo "$k"
ORDERER_VAR="\'""\${ORDERER${k}_HOSTNAME}_\${ORDERER1_DOMAIN}""\'"
sed -i '/#Insert1/a \\    - Hostname: ${ORDERER'${k}'_HOSTNAME} \n \     CommonName: '${ORDERER_VAR}'\n \     SANS: \n \       - "localhost" \n \       - "127.0.0.1" ' ./crypto-config-temp.yaml
done;
wait

# - Name: ${PEERORG1_NAME}
#   Domain: ${PEERORG1_DOMAIN}
#   EnableNodeOUs: true
#   Specs:
#    - Hostname: ${PEERORG1_HOSTNAME1}
#      CommonName: '${PEERORG1_HOSTNAME1}_${PEERORG1_DOMAIN}'
#   Template:
#    Count: 0
#    SANS:
#         - "localhost"
#         - "127.0.0.1"
#   Users:
#    Count: 1

for ((j=$ORG_COUNT;j>=1;j--)); do
#echo "$j"
ORG_VAR="\'""\${PEERORG${j}_HOSTNAME1}_\${PEERORG${j}_DOMAIN}""\'"
sed -i '/#Insert2/a \\  - Name: ${PEERORG'${j}'_NAME} \n \   Domain: ${PEERORG'${j}'_DOMAIN} \n \   EnableNodeOUs: true  \n \   Specs:  \n \    - Hostname: ${PEERORG'${j}'_HOSTNAME1}    \n \      CommonName: '${ORG_VAR}'  \n  \  Template:  \n \    Count: 0 \n \    SANS: \n \        - "localhost"\n \        - "127.0.0.1" \n \   Users: \n \     Count: 1 ' ./crypto-config-temp.yaml
done;




# Sed configtx-temp.yaml
 
echo "**********************************************************************"
echo "CRYPTO-CONFIG-UPDATE"    "----->         configtx-temp.yaml"
echo "**********************************************************************"

cp configtx-temp-default.yaml configtx-temp.yaml


#- &${PEERORG1_NAME}
#  Name: ${PEERORG1_NAME}
#  ID: ${PEERORG1_NAME}MSP
#  MSPDir: crypto-config/peerOrganizations/${PEERORG1_DOMAIN}/msp
#  Policies:
#            Readers:
#                Type: Signature
#                Rule: "OR('${PEERORG1_NAME}MSP.admin','${PEERORG1_NAME}MSP.peer', '${PEERORG1_NAME}MSP.client')"
#            Writers:
#                Type: Signature
#                Rule: "OR('${PEERORG1_NAME}MSP.admin', '${PEERORG1_NAME}MSP.client')"
#            Admins:
#                Type: Signature
#                Rule: "OR('${PEERORG1_NAME}MSP.admin')"
#  AnchorPeers:
#   - Host: ${PEERORG1_HOSTNAME1}_${PEERORG1_DOMAIN}
#     Port: 7051

echo "ORG DETAILS"
for ((j=$ORG_COUNT;j>=1;j--)); do
RULE1="\'""\${PEERORG${j}_NAME}MSP.admin""\',\'""\${PEERORG${j}_NAME}MSP.peer""\',\'""\${PEERORG${j}_NAME}MSP.client""\'"
RULE2="\'""\${PEERORG${j}_NAME}MSP.admin""\',\'""\${PEERORG${j}_NAME}MSP.client""\'"
RULE3="\'""\${PEERORG${j}_NAME}MSP.admin""\'"
sed -i '/#Insert1/a \\ - &${PEERORG'${j}'_NAME}  \n \ Name: ${PEERORG'${j}'_NAME}  \n \ ID: ${PEERORG'${j}'_NAME}MSP  \n \ MSPDir: crypto-config/peerOrganizations/${PEERORG'${j}'_DOMAIN}/msp \n \ Policies:  \n \           Readers: \n \             Type: Signature \n \             Rule: "OR('${RULE1}')" \n \           Writers:  \n \             Type: Signature \n \             Rule: "OR('${RULE2}')" \n \           Admins:   \n  \            Type: Signature \n \             Rule: "OR('${RULE3}')" \n \ AnchorPeers:   \n \  - Host: ${PEERORG'${j}'_HOSTNAME1}_${PEERORG'${j}'_DOMAIN} \n \    Port: 7051 ' ./configtx-temp.yaml
done

echo "ORDERER DETAILS"
for ((j=$ORDERER_COUNT;j>=1;j--)); do
sed -i '/#Insert2/a \\        - ${ORDERER'${j}'_HOSTNAME}_${ORDERER1_DOMAIN}:7050 ' ./configtx-temp.yaml
done


echo "RAFT CONFIGURATIONS"
#- Host:  ${ORDERER1_HOSTNAME}_${ORDERER1_DOMAIN}
#              Port: 7050
#              ClientTLSCert: crypto-config/ordererOrganizations/${ORDERER1_DOMAIN}/orderers/${ORDERER1_HOSTNAME}_${ORDERER_DOMAIN}/tls/server.crt
#              ServerTLSCert: crypto-config/ordererOrganizations/${ORDERER1_DOMAIN}/orderers/${ORDERER1_HOSTNAME}_${ORDERER_DOMAIN}/tls/server.crt

for ((j=$ORDERER_COUNT;j>=1;j--)); do
sed -i '/#Insert3/a \\            - Host: ${ORDERER'${j}'_HOSTNAME}_${ORDERER1_DOMAIN} \n \             Port: 7050 \n \             ClientTLSCert: crypto-config/ordererOrganizations/${ORDERER1_DOMAIN}/orderers/${ORDERER'${j}'_HOSTNAME}_${ORDERER1_DOMAIN}/tls/server.crt   \n \             ServerTLSCert: crypto-config/ordererOrganizations/${ORDERER1_DOMAIN}/orderers/${ORDERER'${j}'_HOSTNAME}_${ORDERER1_DOMAIN}/tls/server.crt     ' ./configtx-temp.yaml
done

#- *${PEERORG1_NAME}
#- *${PEERORG2_NAME}
#- *${PEERORG3_NAME}

echo "ORG DETAILS LIST FOR PROFILE -GENESIS"
echo "ORG DETAILS LIST"
for ((j=$ORG_COUNT;j>=1;j--)); do
sed -i '/#Insert4/a \\                    - *${PEERORG'${j}'_NAME}     ' ./configtx-temp.yaml
done

#- *${PEERORG1_NAME}
#- *${PEERORG2_NAME}
#- *${PEERORG3_NAME}

echo "ORG DETAILS LIST FOR PROFILE -CHANNEL"
for ((j=$ORG_COUNT;j>=1;j--)); do
sed -i '/#Insert5/a \\              - *${PEERORG'${j}'_NAME}     ' ./configtx-temp.yaml
done


#- *${PEERORG1_NAME}
#- *${PEERORG2_NAME}
#- *${PEERORG3_NAME}

echo "ORG DETAILS LIST FOR PROFILE - KAFKA"
for ((j=$ORG_COUNT;j>=1;j--)); do
sed -i '/#Insert6/a \\                - *${PEERORG'${j}'_NAME}     ' ./configtx-temp.yaml
done


#- Host:  ${ORDERER1_HOSTNAME}_${ORDERER1_DOMAIN}
#              Port: 7050
#              ClientTLSCert: crypto-config/ordererOrganizations/${ORDERER1_DOMAIN}/orderers/${ORDERER1_HOSTNAME}_${ORDERER_DOMAIN}/tls/server.crt
#              ServerTLSCert: crypto-config/ordererOrganizations/${ORDERER1_DOMAIN}/orderers/${ORDERER1_HOSTNAME}_${ORDERER_DOMAIN}/tls/server.crt

echo "RAFT CONFIGURATION FOR PROFILES -RAFT"
for ((j=$ORDERER_COUNT;j>=1;j--)); do
sed -i '/#Insert7/a \\                - Host: ${ORDERER'${j}'_HOSTNAME}_${ORDERER1_DOMAIN} \n \                 Port: 7050 \n \                 ClientTLSCert: crypto-config/ordererOrganizations/${ORDERER1_DOMAIN}/orderers/${ORDERER'${j}'_HOSTNAME}_${ORDERER1_DOMAIN}/tls/server.crt   \n \                 ServerTLSCert: crypto-config/ordererOrganizations/${ORDERER1_DOMAIN}/orderers/${ORDERER'${j}'_HOSTNAME}_${ORDERER1_DOMAIN}/tls/server.crt     ' ./configtx-temp.yaml
done

#- ${ORDERER1_HOSTNAME}_${ORDERER1_DOMAIN}:7050 
#- ${ORDERER2_HOSTNAME}_${ORDERER1_DOMAIN}:7050 
#- ${ORDERER3_HOSTNAME}_${ORDERER1_DOMAIN}:7050 
#- ${ORDERER4_HOSTNAME}_${ORDERER1_DOMAIN}:7050 
#- ${ORDERER5_HOSTNAME}_${ORDERER1_DOMAIN}:7050 

echo "ORDERER DETAILS FOR PROFILES -RAFT"
for ((j=$ORDERER_COUNT;j>=1;j--)); do
sed -i '/#Insert8/a \\                - ${ORDERER'${j}'_HOSTNAME}_${ORDERER1_DOMAIN}:7050 ' ./configtx-temp.yaml
done

exit 0