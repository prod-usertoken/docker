server {
    listen   80;
    server_name personal.usertoken.com;

# Clickjacking protection: allow iframes from same origin
    add_header X-Frame-Options SAMEORIGIN;
    add_header Frame-Options SAMEORIGIN;
# Enforce HTTPS connection for all requests, including subdomains
#    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
# IE+ and variants, XSS Protection
    add_header X-XSS-Protection "1;mode=block";
# Protection from drive-by dynamic/executable IE files
    add_header X-Content-Type-Options nosniff;
# Strict Content Security Policy, deny all external requests
# for custom CSP headers use: http://cspbuilder.info
    add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https://ssl.google-analytics.com https://connect.facebook.net; img-src 'self' https://ssl.google-analytics.com https://s-static.ak.facebook.com; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://themes.googleusercontent.com; frame-src https://www.facebook.com https://s-static.ak.facebook.com; object-src 'none'";


#    root /home/www/personal.usertoken.com/html;
#    index index.php index.html index.htm;

    access_log /var/log/nginx/personal.usertoken.com.access.log;
    error_log /var/log/nginx/personal.usertoken.com.error.log;
    error_page 404 /404.html;


    location / {
        proxy_pass http://localhost:9005;
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
