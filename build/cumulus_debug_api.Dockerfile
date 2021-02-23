FROM amazonlinux:2

# CLI utilities
RUN yum install -y gcc git make awscli zip

RUN yum install -y python3-devel

WORKDIR /cumulus-debug-api