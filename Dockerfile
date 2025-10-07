# Minimal Dockerfile for testing the Jenkins pipeline
FROM alpine:3.18
LABEL maintainer="instantprachi"
CMD ["/bin/sh", "-c", "echo Hello from instantprachi image"]
