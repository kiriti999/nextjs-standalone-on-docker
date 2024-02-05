#!/bin/bash


REGION=ap-south-1
ACCOUNT_ID=$(aws sts get-caller-identity | jq -r ".Account")
IMAGE_VERSION="$1"
PORT="$2"
ENV_NAME=$(echo "$IMAGE_VERSION" | awk -F'-' '{print $1}')

echo "Account ID:" $ACCOUNT_ID
echo "run image: IMAGE_VERSION: $IMAGE_VERSION"
echo "run image: ENV_NAME: $ENV_NAME"
echo "run image: PORT $PORT"

aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.ap-south-1.amazonaws.com

if ! docker network inspect app-network &>/dev/null; then
    docker network create app-network
fi

if docker ps -a | grep -q "skillpact-$ENV_NAME"; then
    docker rm --force skillpact-$ENV_NAME
fi

if ! docker images -a | grep -q "$IMAGE_VERSION" && docker images -a | grep "skillpact"; then
    docker images -a | grep "skillpact" | awk '{print $3}' | xargs docker rmi -f
fi

docker run --env-file .env.$ENV_NAME -p $PORT:$PORT --name skillpact-$ENV_NAME --network=app-network \
    --log-driver=awslogs --log-opt awslogs-region=${REGION} --log-opt awslogs-group=skillpact-$ENV_NAME-logs-group \
    -d --restart on-failure:5 ${ACCOUNT_ID}.dkr.ecr.ap-south-1.amazonaws.com/skillpact:$IMAGE_VERSION

# To check max retry count:
# docker inspect skillpact | grep RestartPolicy -A 3

# For analytics purposes, the user can inspect how many times the container has restarted:
# docker inspect -f "{{ .RestartCount }}" skillpact
# Or the last time the container restarted:
# docker inspect -f "{{ .State.StartedAt }}" skillpact

# To delete images:
# docker stop $(docker ps -aq)
# docker rm $(docker ps -aq)
# docker rmi --force $(docker images -aq)
# docker rmi $(docker images -q '238369675568.dkr.ecr.ap-south-1.amazonaws.com/skillpact' | uniq)
