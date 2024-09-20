GOOSE=./build/tools/goose -dir=./migrations sqlite ./build/data.db

go-tools:
	GOBIN=$(shell pwd)/build/tools go install github.com/pressly/goose/v3/cmd/goose@v3.22.0

build:
	go build -o ./build/app ./main.go

run:
	go build -o ./build/app ./main.go && ./build/app

test:
	go test -v ./...

db-up:
	$(GOOSE) up

db-up-to:
	@read -p "Up to version: " VALUE; \
	$(GOOSE) up-to $$VALUE

db-up-by-one:
	$(GOOSE) up-by-one

db-down:
	$(GOOSE) down

db-down-to:
	@read -p "Down to version: " VALUE; \
	$(GOOSE) down-to $$VALUE

db-status:
	$(GOOSE) status 

db-reset:
	$(GOOSE) reset

db-create:
	@read -p "Migration name: " VALUE; \
	$(GOOSE) create "$$VALUE" sql

