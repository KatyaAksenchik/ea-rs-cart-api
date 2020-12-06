FROM node:12-alpine AS BUILD_IMAGE

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force

COPY . .

RUN npm run build

FROM node:12-alpine

WORKDIR /app

COPY --from=BUILD_IMAGE /app/dist ./dist
COPY --from=BUILD_IMAGE /app/node_modules ./node_modules

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]