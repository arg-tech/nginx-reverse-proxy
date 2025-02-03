## Installation
1. Clone the repository
2. Create three SSL secrets in the `ssl/secrets` folder (paths relative to root of this repo)
   1. `sudo openssl req -x509 -nodes -days 36500 -newkey rsa:2048 -keyout ssl/secrets/self-signed.key -out ssl/secrets/self-signed.crt`
   2. `sudo openssl dhparam -out /etc/nginx/dhparam.pem 4096`
3. Copy configuration files for sites into `sites-enabled/`
4. Run `docker compose up -d --build`

\
The `sites-enabled` folder is mirrored inside the container; if new files are added, run `docker exec nginx-reverse-proxy nginx -s reload` (or restart the container).

## Example site config
Note the `host.docker.internal` line instead of `localhost`.
```
# Below comment is used by the CI/CD pipeline, do not edit or remove
# Subdomain for repo: hello-arg-tech
server {
  listen 443 ssl;
  include /etc/nginx/ssl/ssl.conf;

  server_name helloworld.staging.arg.tech;

  location / {
      proxy_set_header   X-Forwarded-For $remote_addr;
      proxy_set_header   Host $http_host;
      proxy_pass         "http://host.docker.internal:4444";
  }
}
```

## Details
The nginx service inside the container runs on port 443, and uses a self-signed SSL certificate. When testing with curl, use the `-k` flag to trust the SSL certificate: `curl https://localhost -H "Host:example.com" -k`.

It's intended to be used in conjuction with an upstream proxy.
