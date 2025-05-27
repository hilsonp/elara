# Stage 1: Build SvelteKit application
FROM node:18 AS sveltekit-builder
WORKDIR /app
COPY sveltekit/package*.json ./
RUN npm install
COPY sveltekit/ ./
RUN npm run build

# Stage 2: Set up Python environment
FROM python:3.12-slim
WORKDIR /app
COPY python/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy built SvelteKit app from Stage 1
COPY --from=sveltekit-builder /app/build ./sveltekit/build

# Copy Python application code
COPY python/ .

# Expose ports
EXPOSE 8000 5173

# Start both services
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port 8000 & npm run --prefix sveltekit dev -- --host 0.0.0.0 --port 5173"]
