#!/bin/sh

# Decrypt the OpenAI key and store it in a variable
openai=$(gpg -d ~/openai.txt.gpg)

# Create or overwrite the .env file with the relevant environment variables
echo "OPENAI_API_KEYS=${openai}" > .env

# Run Docker Compose
docker compose -f docker-compose.yaml up -d

# Remove evidence
shred --remove .env

