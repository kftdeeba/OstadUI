# ---- build stage ----
FROM node:18-alpine AS builder
WORKDIR /app
# copy package files and install dependencies
COPY package*.json ./
RUN npm ci
# copy rest of the source
COPY . .
# build production assets
RUN npm run build


# ---- runtime stage ----
FROM nginx:stable-alpine
# remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*
# copy built assets from builder
COPY --from=builder /app/dist /usr/share/nginx/html
# expose port 80
EXPOSE 80
# run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
