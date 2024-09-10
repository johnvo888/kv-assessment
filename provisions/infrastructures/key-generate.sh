#!/bin/bash
echo "Generate random ssh-keygen for env such as development, staging."
rm -rf keypairs
mkdir keypairs
ssh-keygen -t rsa -b 2048 -N "" -f keypairs/kvasmt-development
ssh-keygen -t rsa -b 2048 -N "" -f keypairs/kvasmt-staging
ssh-keygen -t rsa -b 2048 -N "" -f keypairs/kvasmt-tool
