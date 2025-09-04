# -------------------------
# Stage 1: Build Frontend
# -------------------------
FROM node:18-alpine AS frontend-builder

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm install

COPY frontend ./
RUN npm run build

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
