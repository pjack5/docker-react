#tag this stage with the name 'builder'
FROM node:alpine as builder
WORKDIR /app

COPY /package.json ./
RUN npm install
COPY ./ ./
RUN npm run build

#for the 'production deployment' the folder we will care about in the container
#is the /app/build directory

#having a second FROM statement basically terminates the previous block
FROM nginx

#for elastic beanstalk, it uses that as the port that gets mapped
#for incoming traffic. 
EXPOSE 80
#this basically dumps everything from the node alpine image and the npm install, just get the result of
#the /app/build directory
COPY --from=builder /app/build /usr/share/nginx/html

#default command of nginx container starts it so we don't need a CMD
##

###******* The Travis-CI .yml file is using the dockerfile.dev, however Elastic Beanstalk
###******* will continue to use 'Dockerfile' to build the application. Automatically looks for a 
###******* Dockerfile in the root of the project.

