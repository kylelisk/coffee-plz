# coffee-plz
A simple app that gives you a coffee ☕

The infrastructure is under the terraform folder. It is broken into two modules:
- `foundation`: which contains all of the supporting resources such as network, vpc, iam etc.
- `services`: which contains the actual running docker services and dashboards/autoscaling logic

The application runs in a docker container on port 8080.

## To build and use the Node App
To build the app:

```docker build .```

Then to run it:

```docker run -itd -p 8080:8080 <imageID>```

## To run the linting:
```npm run lint```

## To test the node app:
```npm run test```

## To build the app:
```npm run build```

This will output to the `dist/` folder
