FROM node:12.12.0-alpine

ENV PORT 3000

COPY package.json package.json
RUN npm install

COPY . .
RUN npm run build

EXPOSE 3000

CMD ["node", "dist/"]

