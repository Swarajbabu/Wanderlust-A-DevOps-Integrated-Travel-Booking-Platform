# 1. Base Image: Upgrade to Node 20 Alpine to match package engine requirements (Node >=20)
FROM node:20-alpine

# 2. Set working directory inside container
WORKDIR /app

# 3. Copy package files first for layer caching
COPY package*.json ./

# 4. Install production dependencies with legacy peer deps flag
RUN npm ci --omit=dev --legacy-peer-deps

# 5. Copy application source code
COPY . .

# 6. Expose application port
EXPOSE 8080

# 7. Set default environment variables
ENV PORT=8080
ENV NODE_ENV=production

# 8. Start application
CMD ["npm", "start"]