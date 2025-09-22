FROM node:22-alpine

#Creating group and adding system user app to group app
RUN addgroup app && adduser -S -G app app

#Working directory
WORKDIR /app

#Changing owner ship of current "." i.e /app workdir <user>:<group> <directory>
RUN chown -R app:app .

#Switch to non-root user app
USER app

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

EXPOSE 8080

CMD ["npm","start"]