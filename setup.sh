#!/bin/bash
docker-compose up -d
docker-compose run --rm front yarn
