# -------------------------
# Stage 1: Build Frontend
# -------------------------
FROM node:18-alpine AS frontend-builder

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm install

# Fix permission issues for node_modules binaries
RUN chmod -R 755 node_modules && \
    chmod +x node_modules/.bin/* 2>/dev/null || true

COPY frontend ./

# Use npx to avoid permission issues with vite binary
RUN npx vite build

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
