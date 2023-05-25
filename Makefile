.PHONY: serve build clean download-theme

DESTINATION?=site
BASE_URL?=https://nabarun.dev

serve:
	hugo server

build:
	hugo --baseURL $(BASE_URL) --destination $(DESTINATION) --cleanDestinationDir --minify

legacy-deploy:
	./deploy.sh

clean:
	rm -rf $(DESTINATION)

download-theme:
	git submodule update --init --recursive
