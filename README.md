## Pull

```
docker pull ghcr.io/orvice/apache-base-docker:master
```

## docker-compose

```
  web:
    image: ghcr.io/orvice/apache-base-docker:master
    restart: always
    volumes:
      - /var/data/www:/var/www/html
    container_name: web
```

## Usage

```
FROM ghcr.io/orvice/apache-base-docker:master
```
