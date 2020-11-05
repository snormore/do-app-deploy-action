#!/bin/sh -l

# Grab the app ID from the in-repo app spec.
APP_NAME="$(yq r .do/app.yaml 'name')"
JQ_ARGS=".[] | select(.spec.name == \"${APP_NAME}\") | .id"
APP_ID="$(doctl app list -ojson | jq -r "${JQ_ARGS}")"

doctl app get ${APP_ID} -ojson | yq r -P - '[0].spec' > /tmp/app.actual.yaml
cat /tmp/app.actual.yaml
if ! diff /tmp/app.actual.yaml .do/app.yaml; then
    echo "=> Updating app spec from .do/app.yaml"
    doctl app update ${APP_ID} --spec .do/app.yaml
fi

# Trigger a deployment using the app ID.
echo "=> Deploying app ${APP_NAME} (${APP_ID})..."
doctl app create-deployment $APP_ID

# Wait for latest deployment to be active or failed.
while true; do
    PHASE="$(doctl app list-deployments ${APP_ID} -ojson | jq -r '.[0].phase')"
    echo "-- Phase=${PHASE}"
    if [ "${PHASE}" == "ACTIVE" ]; then
        echo "=> Success! 🎉"
        exit 0
    fi
    if [ "${PHASE}" == "FAILED" ]; then
        echo "=> Failure, check your app deploy logs. 🚨"
        exit 1
    fi
    sleep 3
done
