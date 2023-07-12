include .env
export

GOOSE=goose -dir=./migrations

build:
	go build -o bin/main

compile:
	GOOS=darwin GOARCH=arm64 go build -o ./bin/main-darwin-arm64
	GOOS=linux GOARCH=amd64 go build -o ./bin/main-linux-amd64
	GOOS=windows GOARCH=amd64 go build -o ./bin/main-windows-amd64

run:
	go build -o ./bin/main && ./bin/main

db-up:
	$(GOOSE) up

db-up-by-one:
	$(GOOSE) up-by-one

db-up-to:
	@read -p "Up to version: " VALUE; \
	$(GOOSE) up-to $$VALUE

db-down:
	$(GOOSE) down

db-down-to:
	@read -p "Down to version: " VALUE; \
	$(GOOSE) down-to $$VALUE

db-reset:
	$(GOOSE) reset

db-status:
	$(GOOSE) status 

db-create:
	@read -p "Migration name: " VALUE; \
	$(GOOSE) create "$$VALUE" sql

.PHONY: build compile run
.PHONY: db-up db-up-by-one db-up-to db-down db-down-to
.PHONY: db-reset db-status db-create
 
