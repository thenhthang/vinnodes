## Gia hạn toàn bộ chứng chỉ
```
sudo certbot renew
```
## Đăng ký chứng chỉ mới
```
sudo certbot certonly --standalone -d notify.vinnodes.com
```
## Cấu hình nginx
```
cd /etc/nginx/sites-enabled/
```
> Mỗi website là một file, có thể gộp chung 1 file
<img width="599" height="59" alt="image" src="https://github.com/user-attachments/assets/d229a33a-e8ee-4623-b1cd-3e89f0e321be" />

> Tạo file config cho website
```
server {
    listen 80;
    server_name notify.vinnodes.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name notify.vinnodes.com;

    ssl_certificate /etc/letsencrypt/live/notify.vinnodes.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/notify.vinnodes.com/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://localhost:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```
## Kiểm tra lỗi cấu hình
```
sudo nginx -t
```
## Restart nginx
```
sudo systemctl reload nginx
```
## Stop, Start
```
sudo systemctl stop nginx
sudo systemctl start nginx
```
