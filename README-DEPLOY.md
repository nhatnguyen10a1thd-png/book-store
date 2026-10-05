# Deploy BookStore

The JSP application runs in Tomcat on Render. Vercel is configured only as a reverse proxy, so Java and JSP source files are never part of the Vercel output.

## Required services

1. A Render account connected to the GitHub repository.
2. A reachable Microsoft SQL Server database, such as Azure SQL Database.
3. A Vercel account connected to the same repository.
4. A Gmail account with two-step verification and an app password if OTP registration is required.

## Database

Create an empty database named `BookStore`, connect to it, and run `database/cloud-schema.sql`.

Use a JDBC URL in this format:

```text
jdbc:sqlserver://SERVER.database.windows.net:1433;databaseName=BookStore;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30
```

## Render

Create a Blueprint from the repository. Render reads `render.yaml`, builds `Dockerfile`, and prompts for these values:

- `BOOKSTORE_DB_URL`
- `BOOKSTORE_DB_USER`
- `BOOKSTORE_DB_PASSWORD`
- `BOOKSTORE_SMTP_EMAIL`
- `BOOKSTORE_SMTP_APP_PASSWORD`

The configured service name is `bookstore-tri-thuc-java-20261005`. If Render changes the service hostname, update the destination in `vercel-proxy/vercel.json` before deploying Vercel.

## Vercel

Import the repository and set **Root Directory** to `vercel-proxy`. Do not deploy the repository root or `src/main/webapp`.

The proxy disables CDN caching because the application uses HTTP sessions for authentication and the shopping cart.
