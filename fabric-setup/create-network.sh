cd docker

#docker container stop $(docker container ls -aq) 

#docker system prune --volumes

#para actualizar la imagen de los contenedores eliminar la imagen y volver a crearla

docker-compose -f docker-compose-cli.yaml down --volumes --remove-orphans  

cd ..

sudo rm -rf crypto-config

sudo rm -rf channel-artifacts/*        

./../bin/cryptogen generate --config=./crypto-config.yaml  

./../bin/configtxgen -configPath=. -profile OrdererGenesis -outputBlock ./channel-artifacts/genesis.block -channelID test-channel

./../bin/configtxgen -configPath=. -profile OrgChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID test-channel

export IMAGE_TAG=latest  

export SYS_CHANNEL=test-channel

cd docker

docker-compose -f docker-compose-cli.yaml up -d  