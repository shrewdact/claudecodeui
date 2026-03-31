FROM node:22-bookworm-slim

# Build dependencies for native modules (node-pty, better-sqlite3, bcrypt)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    make \
    g++ \
    git \
    gosu \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
COPY scripts/ ./scripts/

RUN npm ci

COPY . .

RUN npm run build

# Install Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code task-master-ai

# Run as non-root user
RUN useradd -m -s /bin/bash appuser \
    && chown -R appuser:appuser /app \
    && mkdir -p /data /workspace

USER appuser

RUN git config --global user.email "shrewdact@gmail.com" && \
    git config --global user.name "seonghyeok"

# Switch back to root so entrypoint can fix volume permissions
USER root

RUN chmod +x /app/scripts/entrypoint.sh

EXPOSE 3001

ENV NODE_ENV=production \
    SERVER_PORT=3001

ENTRYPOINT ["/app/scripts/entrypoint.sh"]
