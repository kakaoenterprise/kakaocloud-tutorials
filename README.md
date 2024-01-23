# KakaoCloud Library
This is a tutorial example project for KakaoCloud.

<img src="images/main.png" width="600px">

## Requirements
The following are prerequisites for running this project:
1. **git**
    ```shell
    git version
    # git version 2.37.1
    ```
2. **docker**
    ```shell
    docker version
    # Version: 24.0.7
    ```
3. **docker-compose**
    ```shell
    docker-compose version
    # Docker Compose version v2.23.3-desktop.2
    ```

## Quick Start (docker-compose)
To quickly start the project, follow these steps:
1. Clone the project
   ```shell
   git clone https://github.com/kakaoenterprise/kakaocloud-tutorials -b kakaocloud-library
   ``` 
2. Move to the working directory
    ```shell
    cd ./kakaocloud-tutorials
    ```
3. Execute docker-compose
    ```shell
    docker-compose up -d
    ```


## Deployment
Steps for deploying the project:
1. Clone the project
   ```shell
    git clone https://github.com/kakaoenterprise/kakaocloud-tutorials -b kakaocloud-library
   ``` 
2. Move to the working directory
      ```shell
    cd ./kakaocloud-tutorials
     ```
### Server
#### Environment Variables

| Variable      | Description                            | Default Value |
|---------------|----------------------------------------|---------------|
| `PROFILE`     | Application profile (e.g. local, dev ) | dev           |
| `MYSQL_HOST`  | MySQL host address and port            | localhost     |
| `DB_NAME`     | Database name                          | library       |
| `DB_USERNAME` | Database username                      | user          |
| `DB_PASSWORD` | Database password                      | password      |

#### Command
```shell
docker run -it \
  -e MYSQL_HOST=${MYSQL_HOST} \
  -e DB_NAME=${DB_NAME} \
  -e DB_USERNAME=${DB_USERNAME} \
  -e DB_PASSWORD=${DB_PASSWORD} \
-p 8080:8080 \
--name kakaocloud-library-server -d \
$(docker build -q -f ./server/deploy/Dockerfile ./server)
```



### Client
#### Environment Variables

| Variable         | Description              | Default Value         |
|------------------|--------------------------|-----------------------|
| `SERVER_ENDPOINT`| Server endpoint address  | http://localhost:8080 |


#### Command
```shell
docker run -it \
  -e SERVER_ENDPOINT=${SERVER_ENDPOINT} \
-p 80:80 -p 443:443 \
--name kakaocloud-library-client -d \
$(docker build -q -f ./client/deploy/Dockerfile ./client)
```
