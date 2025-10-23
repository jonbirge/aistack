# Models you want on the box
MODELS := llama3.1:8b qwen2.5:7b

# Use docker compose to talk to the running container
OLLAMA := docker compose exec -T ollama ollama

.PHONY: models pull-% up list prune clean

# Ensure the ollama service is up
up:
	docker compose up -d ollama

# Pull all models (only if missing)
models: up $(addprefix pull-,$(MODELS))

# Pull a single model, but only if not already present
pull-%: 
	@if $(OLLAMA) show $* >/dev/null 2>&1; then \
		echo "[skip] $* already present"; \
	else \
		echo "[pull] $*"; \
		$(OLLAMA) pull $*; \
	fi

# Convenience helpers
list:
	$(OLLAMA) list

prune:
	$(OLLAMA) prune

# Remove local model store (host path from your compose)
clean:
	rm -rf ./ollama/models ./ollama/manifests || true

