#!/bin/bash

#generate crypto material
function generateCrypto() {
if [ ! -d "config" ]
then
    mkdir config
else
   rm -r config
fi
if [ ! -d "crypto-config" ]
then
    mkdir crypto-config
else
   rm -r crypto-config
fi
	cryptogen generate --config=./crypto-config.yaml
	if [ "$?" -ne 0 ]; then
		echo $ERROR "Failed to generate crypto material..."
		exit 1
	fi
}

#replace Keys
replaceKeys() {
	PEERORG_DOMAIN=$1
	PRIV_KEY_NO=$2
	NEW_FILE_NAME=$3
	CURRENT_DIR=$PWD
	cd crypto-config/peerOrganizations/${PEERORG_DOMAIN}/ca
	PRIV_KEY=$(ls |grep *_sk| head -n 1 )
	cd $CURRENT_DIR
	sed -i "s/PRIVATE_KEY_$PRIV_KEY_NO/${PRIV_KEY}/g" $NEW_FILE_NAME
	CURRENT_DIR=$PWD
}

function updateEnvValues() {
	ENV_FILE=$1
	FILE_NAME=$2
	vars_vals=$(cat $ENV_FILE | grep "^[A-Z]" | xargs)
	for varTmp in $vars_vals; do
		varName=$(echo $varTmp | awk -F "=" '{print $1}')
		varValue=$(echo $varTmp | awk -F "=" '{print $2}')
		sed -i "s|\${$varName}|$varValue|g" $FILE_NAME
	done
}

function update() {

	cp configtx-temp.yaml configtx.yaml
	cp crypto-config-temp.yaml crypto-config.yaml

	updateEnvValues ./.env "configtx.yaml"
	updateEnvValues ./.env "crypto-config.yaml"

	generateCrypto
	cp docker-compose-temp.yml docker-compose.yml
	for ((i=1;i<=$ORG_COUNT;i++)); do
	    ORG=$i
		cmd=PEERORG_DOMAIN='${PEERORG'$ORG'_DOMAIN}'
		eval $cmd
		replaceKeys $PEERORG_DOMAIN $ORG "docker-compose.yml"
	done

	updateEnvValues ./.env "docker-compose.yml"
	
}

export PATH=${PWD}/../bin:${PWD}:$PATH
export $(cat .env | grep "^[A-Z]" | xargs)



update
echo "Completed"
