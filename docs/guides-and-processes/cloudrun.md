[Home](../../README.md) / CloudRun Steps

# CloudRun Steps (Manual)
- Creating the Docker Image
  - Ensure vendor is properly initialized & environment is clean (make vendor, make clean or make all)
  - Build the docker image (make build-docker)
  - Push the docker image onto the Google Container Registry (make push-docker)

- Basic Cluster Creation
  - Switch to [Kubernetes Engine] (https://console.cloud.google.com/kubernetes)
  - Select Create Cluster
  - Fill in the cluster's name
  - Select a zonal location close to your location (Not regional as it would cost more)
  - To the left, select the features tab, select the checkbox _Enable CloudRun for Anthos_
  - Select _Create_ and wait for the cluster to be fully created before proceeding to the next step.

- From Container Registry
  - Switch to [Container Registry](https://console.cloud.google.com/gcr)
  - Select the docker image with the "_latest_" tag
  - On the Deploy dropdown, select Deploy to CloudRun
  
- From Create Service
  - Select CloudRun on Anthos
  - Select appropriate GKE cluster from _Available Anthos GKE clusters_ dropdown
  - Fill in preferred service name
  - Set _Connectivity_ to External
  - Select _Next_
  - Verify the container's image url (Example: _gcr.io/project-id/service-id:latest_)
  - Select Create
  - Allow the service to fully deploy