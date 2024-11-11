#!/bin/bash
echo "Pulling the latest images..."
docker-compose pull

echo "Updating services with the latest images..."
docker-compose up -d
