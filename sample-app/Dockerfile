FROM node:latest

# Create a non-root user to run the application
RUN groupadd -r nodejs && useradd -r -g nodejs nodejs

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY index.js .

EXPOSE  3000

# Change the ownership of the working directory to the non-root user
RUN chown -R nodejs:nodejs /usr/src/app

# Change to the non-root user
USER nodejs

CMD ["node", "index.js"]

