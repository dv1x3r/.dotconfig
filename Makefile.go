GOOSE=goose -dir=./migrations sqlite ./tmp/data.db

build:
	go build -o tmp/server

run:
	go build -o ./tmp/server && ./tmp/server

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

go-tools:
	go install golang.org/x/tools/gopls@latest
	go install github.com/go-delve/delve/cmd/dlv@latest
	go install github.com/pressly/goose/v3/cmd/goose@latest

