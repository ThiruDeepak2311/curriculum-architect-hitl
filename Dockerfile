FROM n8nio/n8n:latest


COPY workflow/ /home/node/workflows/


EXPOSE 5678


CMD ["n8n", "start"]