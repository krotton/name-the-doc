# name-the-doc
A toy summarizer that generates helpful file names given document text, callable as a HTTP service.

### Build

```sh
docker build -t name-the-doc:latest .
```

### Deploy

```sh
docker run name-the-doc:latest
```

### Use

```sh
curl -X POST \
    -d '["some", "text", "array"]' \
    localhost:8080

#> suggested filename
```