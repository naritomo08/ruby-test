# ruby-site

## 展開方法

```bash
git clone git@github.com:naritomo08/ruby-test.git
cd ruby-test
docker-compose up -d
```

## Dockerコンテナログイン

```bash
docker-compose exec ruby /bin/bash
```

## サイト確認

http://localhost:8080/

## K8Sへの導入方法

```bash
docker build -t ruby-test .
docker images | grep ruby-test
docker tag ruby-test raspi4-2:5000/ruby-test
docker push raspi4-2:5000/ruby-test

kubectl apply -f ruby-test.yaml
kubectl get service -n ruby-test
→ExternalIPを確認

http://<ExternalIP>/
```
