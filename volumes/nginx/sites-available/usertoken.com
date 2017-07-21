server {
    listen   80;
    server_name usertoken.com;

    access_log /var/log/nginx/usertoken.com.access.log;
    error_log /var/log/nginx/usertoken.com.error.log;
    error_page 404 /404.html;

    location / {
        proxy_pass http://localhost:9000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    location ~ /\. {
        allow all;
    }

}
