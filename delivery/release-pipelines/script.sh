#!/bin/bash
VERSION="$1"
ENV=stg
PIPELINE_NAME=myapp-pipeline-$RANDOM
PIPELINERUN_NAME=myapp-pipelinerun-$RANDOM
rm -f *.original
rm -f .\!*.yaml

gcloud container clusters get-credentials beta-e2e
echo -e "------ Release Pipeline for $ENV --------"
echo -e "Update pipeline config for \033[32m$ENV\033[m."
sed -i '.original' -e "s/#IMG_VERSION#/$VERSION/g" pipeline.yaml
sed -i '.original' -e "s/#PIPELINE_NAME#/$PIPELINE_NAME/g" pipeline.yaml
sed -i '.original' -e "s/#PIPELINE_NAME#/$PIPELINE_NAME/g" pipelinerun.yaml
sed -i '.original' -e "s/#PIPELINERUN_NAME#/$PIPELINERUN_NAME/g" pipelinerun.yaml
sed -i '.original' -e "s/#ENV#/$ENV/g" pipeline*
kubectl apply -f $ENV/
kubectl apply -f pipeline.yaml
kubectl apply -f pipelinerun.yaml
echo -e "Prepare and apply \033[32m$VERSION\033[m on \033[32m$ENV\033[m environment."
tkn pipelineruns -n experimental-pipeline logs -a -f $PIPELINERUN_NAME
sed -i '.original' -e "s/$VERSION/#IMG_VERSION#/g" pipeline.yaml
sed -i '.original' -e "s/$PIPELINE_NAME/#PIPELINE_NAME#/g" pipeline.yaml
sed -i '.original' -e "s/$PIPELINE_NAME/#PIPELINE_NAME#/g" pipelinerun.yaml
sed -i '.original' -e "s/$PIPELINERUN_NAME/#PIPELINERUN_NAME#/g" pipelinerun.yaml
sed -i '.original' -e "s/$ENV/#ENV#/g" pipeline*


ENV=prod
gcloud container clusters get-credentials beta-e2e-prod
echo -e "------ Release Pipeline for $ENV --------"
PIPELINE_NAME=myapp-pipeline-$RANDOM
PIPELINERUN_NAME=myapp-pipelinerun-$RANDOM
echo -e "Update pipeline config for \033[32m$ENV\033[m."
sed -i '.original' -e "s/#IMG_VERSION#/$VERSION/g" pipeline.yaml
sed -i '.original' -e "s/#PIPELINE_NAME#/$PIPELINE_NAME/g" pipeline.yaml
sed -i '.original' -e "s/#PIPELINE_NAME#/$PIPELINE_NAME/g" pipelinerun.yaml
sed -i '.original' -e "s/#PIPELINERUN_NAME#/$PIPELINERUN_NAME/g" pipelinerun.yaml
sed -i '.original' -e "s/#ENV#/$ENV/g" pipeline*
kubectl apply -f $ENV/
kubectl apply -f pipeline.yaml
kubectl apply -f pipelinerun.yaml
echo -e "Prepare and apply \033[32m$VERSION\033[m on \033[32m$ENV\033[m environment."
tkn pipelineruns -n experimental-pipeline logs -a -f $PIPELINERUN_NAME

echo -e "resetting"
sed -i '.original' -e "s/$VERSION/#IMG_VERSION#/g" pipeline.yaml
sed -i '.original' -e "s/$PIPELINE_NAME/#PIPELINE_NAME#/g" pipeline.yaml
sed -i '.original' -e "s/$PIPELINE_NAME/#PIPELINE_NAME#/g" pipelinerun.yaml
sed -i '.original' -e "s/$PIPELINERUN_NAME/#PIPELINERUN_NAME#/g" pipelinerun.yaml
sed -i '.original' -e "s/$ENV/#ENV#/g" pipeline*
rm -f *.original
rm -f .\!*.yaml

echo -e "Done."
