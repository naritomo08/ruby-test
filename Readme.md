# hiki-site

## 展開方法

```bash
mkdir /docker
cd /docker
unzip ruby-test.zip
mv ruby-test hiki-site
cd hiki-site
/docker-site内に別途hiki-image.tarを置く。
docker load < hiki-image.tar
docker-compose up -d
```

## Dockerコンテナログイン

```bash
docker-compose exec hiki /bin/bash
```
