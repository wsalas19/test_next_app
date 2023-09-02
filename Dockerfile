# Use the official Node.js LTS image as the base image
FROM node:14 as build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the Next.js application
RUN npm run build

# Use a smaller image for the production build
FROM node:14-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the build files from the previous stage
COPY --from=build /app/.next ./.next
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package*.json ./
COPY --from=build /app/public ./public
COPY --from=build /app/pages ./pages

# Expose the port that the Next.js app will run on (usually 3000)
EXPOSE 3000

# Start the Next.js application
CMD ["npm", "start"]
