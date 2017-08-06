

VERSION ?= latest

build:
	docker build -t flokkr/krb5:$(VERSION) .

deploy:
	docker push flokkr/krb5:$(VERSION)

.PHONY: deploy build
