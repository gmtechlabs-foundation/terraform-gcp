#!/usr/bin/env bash

# ---------------------------------------------------------
#  GKE CONNECT SCRIPT
#  Reusable helper to authenticate and connect to a GKE cluster
# ---------------------------------------------------------

set -euo pipefail

# -----------------------------
#  CONFIGURATION (EDIT AS NEEDED)
# -----------------------------
PROJECT_ID="ap-mldctl-prd-01"
CLUSTER_NAME="autopilot-cluster-1"
LOCATION="europe-west12"   # zone or region
IS_REGIONAL="true"    # true/false

# -----------------------------
#  FUNCTIONS
# -----------------------------

authenticate() {
    echo "🔐 Authenticating with Google Cloud..."
    gcloud auth login
}

set_project() {
    echo "🌍 Setting project: $PROJECT_ID"
    gcloud config set project "$PROJECT_ID"
}

set_location() {
    echo "📍 Setting compute location: $LOCATION"
    if [ "$IS_REGIONAL" = "true" ]; then
        gcloud config set compute/region "$LOCATION"
    else
        gcloud config set compute/zone "$LOCATION"
    fi
}

connect_cluster() {
    echo "🚀 Connecting to GKE cluster: $CLUSTER_NAME"

    if [ "$IS_REGIONAL" = "true" ]; then
        gcloud container clusters get-credentials "$CLUSTER_NAME" \
            --region "$LOCATION" \
            --project "$PROJECT_ID"
    else
        gcloud container clusters get-credentials "$CLUSTER_NAME" \
            --zone "$LOCATION" \
            --project "$PROJECT_ID"
    fi

    echo "✅ Connected. Testing access..."
    kubectl get nodes
}

# -----------------------------
#  MAIN
# -----------------------------
authenticate
set_project
set_location
connect_cluster

echo "🎉 GKE connection complete."
