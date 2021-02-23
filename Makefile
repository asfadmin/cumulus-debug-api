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
		-v ${PWD}:/cumulus-debug-api \
		-v ~/.aws:/.aws \
		cumulus_debug_api
