.SILENT:
.ONESHELL:
.PHONY:


# *************** DOCKER Commands ***************
image: build/cumulus_debug_api.Dockerfile
	cd build && \
	docker build -f cumulus_debug_api.Dockerfile -t cumulus_debug_api .

container-shell:
	docker run -it --rm \
		--user `id -u` \
		-v ${PWD}:/cumulus_debug_api.Dockerfile \
		-v ~/.aws:/.aws \
		buen_aire_backend
