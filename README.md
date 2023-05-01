# Hasura-dev

Sure, here are the steps to install and set up Hasura using Docker with PostgreSQL:

1. Install Docker and Docker Compose on your machine if you haven't already done so.
   
2. Create a new directory for your Hasura app and navigate to it using the terminal.
   
3. Create a new file named `docker-compose.yml` in the directory and add the following code to it:

    ```
    version: '3.6'
    services:
      postgres:
        container_name: postgres
        image: postgres:12
        restart: always
        environment:
          POSTGRES_PASSWORD: your-password
          POSTGRES_USER: your-username
          POSTGRES_DB: your-database
        ports:
          - "5432:5432"
    
      graphql-engine:
        container_name: graphql-engine
        image: hasura/graphql-engine:v2.0.7
        ports:
          - "8080:8080"
        depends_on:
          - postgres
        restart: always
        environment:
          HASURA_GRAPHQL_DATABASE_URL: postgres://your-username:your-password@postgres:5432/your-database
          HASURA_GRAPHQL_ENABLE_CONSOLE: "true"
          HASURA_GRAPHQL_ADMIN_SECRET: your-admin-secret
    ```
      - Change the values of `"your-password"`, `"your-username"`, `"your-database"`, and `"your-admin-secret"` according to your requirement.
   
4. Once you have saved the `docker-compose.yml` file, run the following command in the terminal to start the containers:
   
    ```
    docker-compose up -d
    ```
   
   This will start the PostgreSQL and Hasura GraphQL Engine containers in the background. 
   
   The `-d` flag stands for detached mode, which means the containers will continue to run in the background even after you close the terminal.
   
5. Once the containers have started, you can access the Hasura GraphQL Engine console by opening a web browser and navigating to `http://localhost:8080/console`.
   
6. In the console, you can create tables, relationships, permissions, and more for your GraphQL API. 

That's it, you now have a fully functional Hasura GraphQL Engine backed by PostgreSQL running on Docker.

Sure, here's the updated and formatted version:




## Deploying Hasura GraphQL Engine and Postgres Containers in a Lightsail Ubuntu Instance

1. Make sure that you have Docker and Docker Compose installed on the Lightsail instance. If not, install them using the following commands:
   
   ```
   sudo apt update
   sudo apt install docker.io docker-compose
   ```

2. Copy the `docker-compose.yml` file from your local machine to the Lightsail instance using a secure method like `scp`.
   
   For example:
   
   ```
   scp -i /path/to/your/key.pem /path/to/local/docker-compose.yml ubuntu@<your-instance-public-IP>:~/docker-compose.yml 
   ```
   
   Replace `/path/to/your/key.pem` with the path to your private key file and `<your-instance-public-IP>` with the actual public IP address of your Lightsail instance.

3. SSH into your Lightsail instance using your terminal:
   
   ```
   ssh -i /path/to/your/key.pem ubuntu@<your-instance-public-IP>
   ```

4. Create a new Docker network on the Lightsail instance using the following command:
   
   ```
   sudo docker network create hasura
   ```

5. Start the containers using Docker Compose:
   
   ```
   docker-compose up -d
   ```

6. Make changes to the JWT secret key in the `docker-compose.yml` file according to your requirement:
   
   For example:
   
   ```
   HASURA_GRAPHQL_JWT_SECRET: '{"type":"RS256","jwk_url": "https://www.googleapis.com/service_accounts/v1/jwk/securetoken@system.gserviceaccount.com","audience": "hasura-8c44d", "claims_map": {"x-hasura-allowed-roles": ["user" ],"x-hasura-default-role": "user", "x-hasura-user-id": {"path": "$$.sub" }},"issuer":"https://securetoken.google.com/hasura-8c44d"}'
   ```

7. If you encounter an error like "Error while fetching server API version: ('Connection aborted.', ConnectionRefusedError(61, 'Connection refused'))", add your user to the Docker group and try again:
   
   ```
   sudo gpasswd -a $USER docker
   newgrp docker
   ```

8. Install Nginx using the following command:
   
   ```
   sudo apt update
   sudo apt install nginx
   ```

9. Configure Nginx to work with Hasura GraphQL Engine on a custom port by editing the default configuration file:
   
   ```
   sudo nano /etc/nginx/sites-available/default
   ```
   
   Add the following configuration to the file:
   
   ```
   server {
       listen 80;
       server_name <your-instance-public-IP>;

       location / {
           proxy_pass http://localhost:8080;
           proxy_set_header Host $http_host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
       }
   }
   ```
   
   Replace `<your-instance-public-IP>` with the actual public IP address of your Lightsail instance.

10. Restart the Nginx server using the following command:
   
    ```
    sudo service nginx restart
    ```
    
    You should now be able to access your Hasura GraphQL Engine API through the public IP address of your Lightsail instance.
