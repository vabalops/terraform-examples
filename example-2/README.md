# Example 2 - SSM

This module creates EC2 instances that can be accessed through SSM instead of SSH

## Connecting through SSM

`aws ssm start-session --target <instance-id>`