# Base image
FROM node:14.21.3 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Angular app
RUN npm run build

# Stage 2: Serve the Angular app using nginx
FROM nginx:1.21.1-alpine

# Copy the built Angular app from the previous stage
COPY --from=build /app/dist/employeemanagerapp /usr/share/nginx/html

# Copy nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose the default HTTP port
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]