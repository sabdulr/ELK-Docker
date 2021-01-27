## On the host
```bash
sysctl -w vm.max_map_count=262144
```

## Delete all data
```bash
curl -XDELETE 192.168.86.36:9200/*
```

## Delete just remeng data - not the index though
```bash
curl -XDELETE http://192.168.86.36:9200/remeng
```

## How to deploy:
```bash
docker-compose up -d --build
```
