# Stage 1 - the build process
FROM node:9.6.1
RUN apt-get update && apt-get install -y curl nginx

# set working directory
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json /usr/src/app/package.json
COPY yarn.lock /usr/src/app/yarn.lock
RUN yarn

COPY . /usr/src/app

RUN yarn build

RUN rm -rf /var/html/html/*
RUN mv /usr/src/app/build/index.html /var/www/html/
RUN cp -R /usr/src/app/build/* /var/www/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]