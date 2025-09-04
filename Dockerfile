# -------------------------
# Stage 1: Build Frontend
# -------------------------
FROM node:18-alpine AS frontend-builder

WORKDIR /app/frontend

COPY frontend/package*.json ./

# Install dependencies and fix permissions properly
RUN npm install && \
    npm rebuild && \
    chmod -R 755 node_modules && \
    find node_modules/.bin -type f -exec chmod +x {} \; && \
    npm cache clean --force

COPY frontend ./

# Use direct node execution instead of npx
RUN node node_modules/vite/bin/vite.js build

# -------------------------
# Stage 2: Setup Backend
# -------------------------
FROM node:18-alpine AS backend

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY backend ./backend

COPY --from=frontend-builder /app/frontend/dist ./backend/public

WORKDIR /app/backend
EXPOSE 5000
CMD ["npm", "start"]
