#!/bin/bash
echo "Generate random ssh-keygen for env such as development, staging."
rm -rf secret
mkdir secret
ssh-keygen -t rsa -b 2048 -N "" -f secret/kvasmt-development
ssh-keygen -t rsa -b 2048 -N "" -f secret/kvasmt-staging
