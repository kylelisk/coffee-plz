FROM node:16.11.1-alpine

ENV PORT 8080

COPY package.json package.json
RUN yarn

COPY . .
RUN yarn build

EXPOSE 8080

CMD ["node", "dist/"]

