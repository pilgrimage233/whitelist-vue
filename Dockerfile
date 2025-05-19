# 使用 Node 镜像构建静态文件
FROM node:18 AS build

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN npm install

# 复制所有源码
COPY . .

# 编译 Vue 项目
RUN npm run build

# 使用 Nginx 运行静态文件
FROM nginx:alpine

# 删除默认的 nginx 主页
RUN rm -rf /usr/share/nginx/html/*

# 复制编译后的文件到 nginx 的 html 目录
COPY --from=build /app/dist /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]