# syntax=docker/dockerfile:1
# The base has uv, alixea-pm and the entrypoint that runs the project's initScript (alixea-erp/component-bases). The code is
# not in the image: staging and production install the deployment's commit on its own machine, development runs the
# working copy. The chart sets the start commands
FROM public.ecr.aws/p8t2q7f4/alixea/component-bases/python:v1

EXPOSE 8000
