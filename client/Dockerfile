FROM node:lts-alpine

WORKDIR /srv/client

COPY ./package*.json ./

RUN npm cache clean --force && npm install

COPY . .

RUN npm run build
