# Sip Snitch - Dart Backend Tutorial

This tutorial shows how to create a simple backend using Dart for an existing Flutter app.
The backend will be deployed on Google Cloud.
The data is stored in a Postgres DB and the access is secured by Firebase Auth.

## The app

Keep track of your daily hydration intake is important.
The introduction of large bottles such as the Stanley Cup makes it hard to keep track of your water intake throughout the day.

The Sip Snitch app brings back fine grained measurement of your water intake.
It tracks every sip of water you take, tracking your real-time hydration level.

## Before getting your hands dirty

- [ ] Fork this repository

Everyone has to deploy their very own backend.
You can still work together but in different repositories.

## Step 1: Build the backend

Checkout the app and define the API of the backend.
It should be super simple.

- [ ] Add one endpoint to add a sip of a certain liquid
- [ ] Add another endpoint to get the statistics of all sips for today

The naming is completely up to you.

- [ ] Save the data in memory for now

- [ ] Communicate with the backend from the app

### Technologies to use

We'll stick to [`shelf`](https://pub.dev/packages/shelf) and its many extensions such as [`shelf_router`](https://pub.dev/packages/shelf_router).

There are other notable packages such as [`dart_frog`](https://pub.dev/packages/dart_frog), [`serverpod`](https://pub.dev/packages/serverpod) or [`relic`](https://pub.dev/packages/relic) which add their own clever and opionated way of building a backend in Dart.
Neither of them has proven the test of time yet and might follow the same silent death as their predecessors [`angel`](https://github.com/angel-dart/angel) or [`aqueduct`](https://aqueduct.io/).
Therefore, we'll stick to the biggest ecosystem and relevance for the future: `shelf`.

## Step 2: Advanced Development

Dart is great for backend development.
Here are some ideas to try out to make building the backend more fun:

- [ ] Add [hot-reload](https://pub.dev/packages?q=hotreload) to the backend
- [ ] Debug incoming requests with the debugger
- [ ] Add a logging middleware
- [ ] Validate the input parameters of the requests
- [ ] Write unit tests for your endpoints

## Step 3: Dockerize your backend

Now that your backend is up and running locally, it’s time to package it into a Docker container.
Dart makes this easy, because it only requires a container with a single file, the backend executable.

Obviously, you need to have Docker installed on your machine.

Follow the [globle.dev Docker tutorial](https://globe.dev/blog/4-ways-deploy-dart-backend/#containerize-your-dart-backend) to create a Dockerfile for your backend.
You can ignore the dart_frog specific parts, it's even simpler for your app.

Alternatively, check out the official [Dart sample](https://github.com/dart-lang/samples/tree/main/server/simple)

- [ ] Start the backend as Docker container locally and test it with the app

```bash
docker run -it sip_snitch_backend                       
```

## Step 4: Deploy to Google Cloud Run
- [x] Create Google Cloud Service Account
- https://console.cloud.google.com/iam-admin/iam?authuser=1&inv=1&invt=Abm_JA&project=drink-track

Now that the container is working locally, push it to Google Cloud and deploy it on Cloud Run.

Continue the [globle.dev Docker tutorial](https://globe.dev/blog/4-ways-deploy-dart-backend/#google-cloud-run--serverless)

- [x] Deploy your backend to Google Cloud Run in the `drink-track` project
- [x] Automate deployment with Cloud Build

## Step 5: Add Firebase Auth

The backend is now deployed and accessible by everyone!
Let's secure it with Firebase Auth.

Require a `JWT` token in the `Authorization` header of the incoming requests.
Add Firebase Auth to the frontend and backend to secure the communication.

- [ ] Add Firebase Auth to the Flutter app (use annonymous accounts)
- [ ] Secure incoming requests with Firebase Auth (validate the token)

## Step 6: Add a Postgres DB

The data is currently only stored in memory.

- [ ] Create a Postgres DB on Google Cloud
- [ ] Create your tables
- [ ] Implement the endpoints to store the data in the DB
- [ ] Inject the DB credentials as environment variables into the docker container
- [ ] Make your development environment work with a local Postgres DB / postgres docker container

## Step 7: Deploy the app to Kubernetes

```dart
// TODO
```

## Step 8: Deploy using terraform

```dart
// TODO
```
