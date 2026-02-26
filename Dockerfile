FROM docker.n8n.io/n8nio/n8n:latest

USER root

# Copy workflow into the container
COPY workflow/ /home/node/workflows/

USER node

EXPOSE 5678