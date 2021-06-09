#!/usr/bin/env bash
ssh -ttf ec2-user@provisioner.test.rentlytics.com sudo chef-client -o provisioner::build-deploy