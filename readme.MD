# Fake Store Server Docker Workspace

This repository is a Docker-enabled wrapper around the `fake-store-server` Node.js API used for mobile app development exercises.

## What This Repo Contains

- `fake-store-server/`: main Express API project (tracked as a git submodule)
- `compose.yaml`: Docker Compose service definition
- `Dockerfile`: container build instructions for the Node server
- `up.sh`: helper script to init submodule and run compose
- `README.Docker.md`: generic Docker template notes

## Architecture Summary

The API is an Express server with:

- Swagger docs at `/api-docs`
- JWT auth for protected routes (`Authorization: Bearer <token>`)
- SQLite persistence in `fake-store.sqlite3` (inside the app working directory)
- Static product catalog loaded from `fakeStoreData.json`

Main route groups:

- `/users`: signup, signin, update profile, debug list users
- `/products`: list/filter/get fake products
- `/cart`: get/update authenticated user cart
- `/orders`: create/list/update authenticated user orders, debug list orders

## Quick Start

### Option A: Run with Node (local dev)

1. Initialize submodule:

```bash
git submodule update --init --recursive
```

2. Install dependencies:

```bash
cd fake-store-server
npm install
```

3. Start the server:

```bash
npm start
```

4. Open API docs:

- http://localhost:3000/api-docs

### Option B: Run with Docker Compose

From repo root:

```bash
git submodule update --init --recursive
docker compose up --build
```

Or use the helper script:

```bash
bash ./up.sh
```

Then open:

- http://localhost:3000/api-docs

## Run Tests

From `fake-store-server/`:

```bash
npm test
```

Test stack:

- Jest
- Supertest

Current automated coverage includes:

- `__test__/user.test.js`
- `__test__/cart.test.js`
- `__test__/order.test.js`

## API Usage Notes

- Most endpoints return HTTP 200 and communicate failure through `{ status: "error", message: "..." }`.
- Protected endpoints require a bearer token from `POST /users/signup` or `POST /users/signin`.
- Product routes simulate latency (2-second delay).
- Debug endpoints exposed for learning: `GET /users`, `GET /orders`.

## Useful Endpoints

- `GET /` -> redirects to Swagger UI
- `POST /users/signup`
- `POST /users/signin`
- `POST /users/update` (auth)
- `GET /products/*`
- `GET /cart` (auth)
- `PUT /cart` (auth)
- `GET /orders/all` (auth)
- `POST /orders/neworder` (auth)
- `POST /orders/updateorder` (auth)

## Repository Structure

```text
.
|-- compose.yaml
|-- Dockerfile
|-- README.Docker.md
|-- up.sh
`-- fake-store-server/
    |-- app.js
    |-- package.json
    |-- fakeStoreData.json
    |-- bin/www
    |-- src/
    |   |-- db/
    |   |-- middle_ware/
    |   |-- routes/
    |   |-- service/
    |   `-- swagger/
    `-- __test__/
```

## Known Caveat

`compose.yaml` currently points build context to `./fake-store-server` and expects `Dockerfile` inside that folder. If `docker compose up --build` fails with a missing Dockerfile error, adjust the compose build configuration or place/copy a Dockerfile into `fake-store-server/`.

## Submodule Note

The app source is configured as a git submodule (`.gitmodules`):

- path: `fake-store-server`
- url: `https://github.com/LarryAtGU/fake-store-server`

If the folder appears empty on a fresh clone, run:

```bash
git submodule update --init --recursive
```
