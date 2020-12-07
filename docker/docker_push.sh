#!/bin/bash
# formating
CLEAR='\033[0m'
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'

#and exits immediately on error
set -e

TAG=`if [ "$TRAVIS_TAG" != "" ]; then echo "${TAG_PREFIX}$TRAVIS_TAG"; else echo "${TAG_PREFIX}$TRAVIS_BRANCH" ; fi`
# Tags may not contain slashes. Since git flow uses slashes as part of the branch name,
# we replace all slashes with underscores, i.e. "release/1.0.0-alpha" becomes "release_1.0.0-alpha".
TAG=${TAG//\//_}

# User feedback
echo -e "${CYAN}running docker_push.sh with REPO:TAG => ${CLEAR} ${GREEN}$REPO:$TAG${CLEAR}";
docker login -u $DOCKER_USER -p $DOCKER_PASS
echo -e "${GREEN}Docker login successful!${CLEAR}"

if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
    docker build ${BUILD_ARG} -t $REPO:$TAG -f $DOCKERFILE $WD;
    echo -e "${GREEN}DONE: docker build ${BUILD_ARG} -t $REPO:$TAG -f $DOCKERFILE $WD${CLEAR}";
    docker push $REPO:$TAG;
    echo -e "${GREEN}DONE: docker push $REPO:$TAG ${CLEAR}";
else
    echo -e "${GREEN}NOTE: pull_request so no image was built and pushed.${CLEAR}";
fi

#test comment
