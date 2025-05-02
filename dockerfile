# Stage 1: Build the Angular application
FROM node:18 AS builder
# Set working directory
WORKDIR /app
# Copy package.json and package-lock.json
COPY package*.json ./
# Install dependencies
RUN npm install
# Copy the rest of the Angular app
COPY . .
# Build the Angular app in production mode
RUN npm run build --prod
# Stage 2: Serve the app with Nginx
FROM nginx:alpine
# Remove default Nginx static assets
RUN rm -rf /usr/share/nginx/html/*
# Copy compiled Angular app from Stage 1
COPY --from=builder /app/dist/* /usr/share/nginx/html/
# Copy custom Nginx configuration (optional)
# COPY nginx.conf /etc/nginx/conf.d/default.conf
# Expose port 80
EXPOSE 80
# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
