# NEEDS INTEGRATION INTO SERVERLESS AWS

# This Makefile automatically builds the docker container.
# To run from the package top-level:
#
# $ sudo make -C docker build
#
# The above one-liner can be included in a CI/CD pipeline project.

NAME                := worldpipe
ARCH                := $$(uname -m)
HASHLONG            := $$(git log -1 --pretty=%H --no-merges)
HASHSHORT           := $$(git log -1 --pretty=%h --no-merges)
TAG                 := $$(git describe --tags --abbrev=0)
IMGLONG             := ${NAME}:${TAG}-${HASHSHORT}-${ARCH}
IMGSHORT            := ${NAME}:${TAG}-${ARCH}
DEFAULT             := ${NAME}:default-${ARCH}

.PHONY: all
all: reup

build:
	@IMG=${IMGLONG} docker-compose build --no-cache
	@docker tag ${IMGLONG} ${IMGSHORT}

reup:
	@COMPOSE_PROJECT_NAME=${NAME} IMG=${IMGLONG} docker-compose up --build --detach
	@docker tag ${IMGLONG} ${IMGSHORT}

up:
	@COMPOSE_PROJECT_NAME=${NAME} IMG=${IMGLONG} docker-compose up --detach

down:
	@COMPOSE_PROJECT_NAME=${NAME} docker-compose down
