FROM node:12.12.0-alpine

ENV PORT 8080

COPY package.json package.json
RUN npm install

COPY . .
RUN npm run build

EXPOSE 8080

CMD ["node", "dist/"]

