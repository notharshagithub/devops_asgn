# 04 — VPC: Virtual Private Cloud (Networking)

## What is a VPC?

Amazon VPC provides a logically isolated network in AWS where you define IP address ranges, subnets, routes, and network controls for resources such as EC2 instances and private endpoints.

## CIDR

CIDR notation describes an IP address range and prefix length. For example, `10.0.0.0/16` contains a larger IPv4 address range than `10.0.1.0/24`. Plan non-overlapping ranges for connected VPCs and on-premises networks to avoid routing conflicts.

## Subnets

A subnet is an IP range within one VPC and one Availability Zone. Subnets can be designed for public, private, or isolated workloads. A subnet is considered public when its associated route table has a route to an internet gateway; assigning a public IP alone does not make a subnet publicly routable.

## Route tables

Route tables direct traffic based on destination CIDRs or prefix lists and targets. Each subnet is associated with one route table at a time, either explicitly or through the VPC's main route table. The most specific matching route takes precedence.

## Internet Gateway (IGW)

An Internet Gateway attaches to a VPC and allows eligible internet communication when public IP addressing, route tables, and security controls are correctly configured. A public subnet commonly has a default route (`0.0.0.0/0`) to an IGW.

## NAT Gateway

A NAT Gateway enables instances in private subnets to initiate supported outbound IPv4 connections without accepting unsolicited inbound connections from the internet. It is placed in a public subnet and requires correct routing. NAT Gateways can incur hourly and data-processing charges, so consider cost and availability when choosing an architecture.

## Security Groups

Security groups are stateful, resource-level virtual firewalls. They contain allow rules; response traffic for permitted connections is automatically allowed by the stateful behavior. They are commonly attached to EC2 network interfaces and other supported resources.

## Network ACLs (NACLs)

Network ACLs apply at the subnet level and are stateless. Inbound and outbound rules must be considered separately, including return traffic. NACLs can allow or deny traffic, while security groups are stateful and allow-only.

## Public vs private subnet

| Public subnet | Private subnet |
|---|---|
| Route table has a route to an IGW | Does not have a direct default route to an IGW for general internet access |
| Can host internet-facing resources when addressing and security are configured | Common for application servers, databases, and internal services |
| May use public IPs where required | May use a NAT Gateway or private endpoints for selected outbound/service access |

## Common architecture

A typical application uses a public load balancer in public subnets, application instances in private subnets, and databases in private subnets with tightly scoped security group rules. Multi-AZ placement improves resilience, while routing and access policies determine actual reachability.

## References

- [Amazon VPC user guide](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
- [VPC route tables](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)
- [Internet access for a subnet](https://docs.aws.amazon.com/vpc/latest/userguide/internet-gateway-subnet.html)
- [Security groups](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html)
- [Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html)
