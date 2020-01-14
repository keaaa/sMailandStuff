#
# -- Base node image with app
#
FROM node:12-alpine AS base
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN mkdir -p ./config ./public ./routes ./src ./views
COPY config config
COPY public public
COPY routes routes
COPY src src
COPY views views

#
# -- Dependencies
#
FROM base as dependencies
WORKDIR /usr/src/app
RUN npm install --only=production
RUN cp -R node_modules node_modules_production
RUN npm install

#
# Running test, linting and npm audit
#
#FROM dependencies as test
#WORKDIR /usr/src/app
#COPY test test
#RUN ["npm","test"]
#COPY .eslintrc.json .eslintignore ./
#RUN npm run lint
#RUN npm audit

#
# Release image
#
FROM base as release
WORKDIR /usr/src/app
COPY --from=dependencies /usr/src/app/node_modules_production ./node_modules
EXPOSE 3000
ENTRYPOINT [ "npm", "start"]