.PHONY: serve build clean

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
