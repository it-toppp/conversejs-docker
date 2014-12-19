start: build
	docker run --name conversejs -d -p 8080:80 -p 5280:5280 conversejs

build:
	docker build -t conversejs .

stop:
	docker stop $$(docker ps --no-trunc=false | awk '{if ( $$NF == "conversejs" ){ print $$1 }}') || :

remove: stop
	docker rm conversejs

debug:
	docker run -t -i -p 8080:80 -p 5280:5280 --entrypoint=/bin/bash conversejs
