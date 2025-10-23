# Models you want on the box
MODELS := gemma3:12b \
		  llama3.2-vision \
		  phi4 \
		  codellama \
		  granite3.3 \
		  gpt-oss

# Use docker compose to talk to the running container
OLLAMA := docker compose exec -T ollama ollama

.PHONY: models up list prune clean

# Ensure the ollama service is up
up:
	docker compose up -d ollama

# Pull all models (only if missing)
models: up
	@for model in $(MODELS); do \
		if $(OLLAMA) show $$model >/dev/null 2>&1; then \
			echo "[skip] $$model already present"; \
		else \
			echo "[pull] $$model"; \
			$(OLLAMA) pull $$model; \
		fi; \
	done

# Convenience helpers
list:
	$(OLLAMA) list

prune:
	$(OLLAMA) prune

# Remove local model store (host path from your compose)
clean:
	rm -rf ./ollama/models ./ollama/manifests || true
