docker container stop $(docker container ls -aq) 

docker system prune --volumes

docker-compose -f docker-compose.yml down --volumes --remove-orphans  

sudo rm -rf crypto-config

sudo rm -rf channel-artifacts/*        

./../bin/cryptogen generate --config=./crypto-config.yaml  

./../bin/configtxgen -configPath=. -profile OrdererGenesis -outputBlock ./channel-artifacts/genesis.block 

./../bin/configtxgen -configPath=. -profile OrgChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID test-channel

export IMAGE_TAG=latest     

docker-compose -f docker-compose.yml up -d  