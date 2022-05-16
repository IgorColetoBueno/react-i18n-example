# stage1 as builder
FROM node:16-alpine as builder

RUN mkdir /i18-example

# copy the package.json to install dependencies
COPY package.json package-lock.json ./i18-example/

WORKDIR /i18-example

# Install the dependencies and make the folder
RUN npm install

COPY . .

# Build the project and copy the files
RUN npm run build

FROM nginx:alpine

#!/bin/sh

COPY ./.nginx/nginx.conf /etc/nginx/nginx.conf

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy from the stahg 1
COPY --from=builder /i18-example/build /usr/share/nginx/html

EXPOSE 3000 1080

ENTRYPOINT ["nginx", "-g", "daemon off;"]