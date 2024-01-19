# base image
FROM node:18-alpine AS base

RUN corepack enable yarn

# build image
FROM base AS build

#ARG VERSION=6f1b8d756b8df298a6d55ed1f20ba509afde2b92
ARG VERSION=master

ADD https://github.com/atomicals/atomicals-js/archive/${VERSION}.zip /tmp/

RUN set -ex && \
    cd /tmp && unzip ${VERSION} && \
    mv /tmp/atomicals-js-${VERSION} /app


WORKDIR /app

RUN sed -i 's/ep.atomicals.xyz/ep.atomicalneutron.com/' .env
#RUN sed -i 's/https:\/\/ep.atomicals.xyz/http:\/\/192.168.2.88:8080/' .env
ENV YARN_CACHE_FOLDER=/root/.yarn

RUN --mount=type=cache,target=/root/.yarn \
    yarn && yarn build && \
    # remove dev dependencies
    yarn install --production && \
    # check atomicals version
    yarn cli --version

# release image
FROM base AS release

COPY --from=build /app /app
COPY ./entrypoint.sh /entrypoint.sh
WORKDIR /app
RUN sed -i 's/REVEAL_INPUT_BYTES_BASE = 66/REVEAL_INPUT_BYTES_BASE = 96/' /app/dist/utils/atomical-operation-builder.js

ENTRYPOINT ["/entrypoint.sh"]
