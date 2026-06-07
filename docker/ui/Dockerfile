FROM node:22
WORKDIR /datatools-build

ARG AUTH0_CLIENT_ID
ARG AUTH0_CONNECTION_NAME
ARG AUTH0_DOMAIN
ARG BUGSNAG_KEY
ARG DISABLE_AUTH
ARG GOOGLE_ANALYTICS_TRACKING_ID
ARG GRAPH_HOPPER_KEY
ARG GRAPH_HOPPER_POINT_LIMIT
ARG GRAPH_HOPPER_URL
ARG MAP_BASE_URL
ARG MAPBOX_ACCESS_TOKEN
ARG MAPBOX_ATTRIBUTION
ARG MAPBOX_MAP_ID
ARG SERVER_URL
ARG SLACK_CHANNEL
ARG SLACK_WEBHOOK

RUN cd /datatools-build
COPY package.json yarn.lock patches /datatools-build/
RUN yarn
COPY . /datatools-build/
COPY configurations/default /datatools-config/

RUN chmod +x scripts/render-write-env.sh
RUN scripts/render-write-env.sh /datatools-config/env.yml

RUN env YAML_CONFIG=/datatools-config/env.yml yarn build
CMD yarn e2e-preview --port 9966 --host
