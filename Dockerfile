FROM gcr.io/yuwenma-gke-playground/k8s-appctl:v7.0.0-betaNoPRReview
WORKDIR /myapp
RUN appctl prepare stg
