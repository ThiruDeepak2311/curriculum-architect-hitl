FROM n8nio/n8n:latest

# Copy workflow into the container
COPY workflow/ /home/node/workflows/

# n8n runs on port 5678
EXPOSE 5678

# Use the full path to n8n binary
CMD ["/usr/local/bin/n8n", "start"]