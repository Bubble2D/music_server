.PHONY: up down restart network\
        navidrome-up navidrome-down navidrome-logs \
        lidarr-up lidarr-down lidarr-logs \
        slskd-up slskd-down slskd-logs \
        soularr-up soularr-down soularr-logs soularr-config \

ENV_FILE = .env
DC = docker compose --env-file $(ENV_FILE)

# Netzwerk anlegen (einmalig vor dem ersten Start)
network:
	docker network create music_server || true

# Alle Services
up: navidrome-up lidarr-up slskd-up soularr-up
down: navidrome-down lidarr-down slskd-down soularr-down

restart: down up

# --- Navidrome ---
navidrome-up:
	$(DC) -f navidrome/docker-compose.yml up -d

navidrome-down:
	$(DC) -f navidrome/docker-compose.yml down

navidrome-logs:
	$(DC) -f navidrome/docker-compose.yml logs -f

# --- Lidarr ---
lidarr-up:
	$(DC) -f lidarr/docker-compose.yml up -d

lidarr-down:
	$(DC) -f lidarr/docker-compose.yml down

lidarr-logs:
	$(DC) -f lidarr/docker-compose.yml logs -f

# --- slskd ---
slskd-up:
	$(DC) -f slskd/docker-compose.yml up -d

slskd-down:
	$(DC) -f slskd/docker-compose.yml down

slskd-logs:
	$(DC) -f slskd/docker-compose.yml logs -f

# --- soularr ---
soularr-up:
	$(DC) -f soularr/docker-compose.yml up -d

soularr-down:
	$(DC) -f soularr/docker-compose.yml down

soularr-logs:
	$(DC) -f soularr/docker-compose.yml logs -f

soularr-config:
	@bash soularr/generate_config.sh
