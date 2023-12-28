FROM nginx:1.23.1-alpine
COPY . /usr/share/nginx/html
WORKDIR /usr/src/test
CMD ["nginx", "-g", "daemon off;"]