# 02 — EC2: Elastic Compute Cloud (Compute)

## What is EC2?

Amazon EC2 provides resizable virtual compute capacity in AWS. A user selects an image, instance family and size, network placement, storage, and security settings, then launches an instance.

## Key concepts

### AMI (Amazon Machine Image)
An AMI is a template used to launch instances. It includes information needed to boot a machine, such as an operating system and associated block-device mappings. AMIs may be AWS-provided, marketplace images, or custom images created for an organization.

### Instance types
Instance types provide different combinations of CPU, memory, storage, and network performance. Broad families include general purpose, compute optimized, memory optimized, storage optimized, and accelerated computing. Choose based on workload requirements, architecture, availability, and price; the exact types available vary by region and platform.

### Key pairs
EC2 key pairs provide a way to authenticate to supported operating systems. For Linux, a private key is commonly used with SSH. Protect private keys and never commit them to source control. Access methods also include AWS Systems Manager Session Manager where configured.

### Security Groups
A security group is a stateful virtual firewall associated with network interfaces or instances. It contains allow rules for inbound and outbound traffic. Start with minimal access; for example, allow SSH only from a trusted address range if SSH is necessary rather than from the entire internet.

### EBS (Elastic Block Store)
EBS provides persistent block storage volumes for EC2. Volumes are attached to instances and persist independently of the instance's running process. Snapshots can be used for backup and recovery. Availability-zone and attachment constraints depend on volume type and configuration.

### Public vs private IP
A public IPv4 address can be used for internet communication only when routing and security controls permit it. Private IPv4 addresses are used for internal network communication. A private-subnet instance may access the internet outbound through a NAT gateway or other configured egress path without accepting direct inbound internet connections.

### Instance lifecycle
Common states include `pending`, `running`, `stopping`, `stopped`, `shutting-down`, and `terminated`. Stopping and starting an instance differs from rebooting it; billing, IP addresses, and attached storage behavior depend on the instance and resource configuration. Termination is generally intended to remove the instance, though EBS deletion behavior depends on settings.

## Common use cases

- Hosting web applications and APIs.
- Running batch jobs, build agents, and compute-intensive tasks.
- Development and test environments.
- Self-managed databases or application components when managed services are unsuitable.
- Legacy workloads that require operating-system-level control.

## Design tips

- Pick an instance family based on measured workload needs.
- Use IAM roles instead of embedding AWS credentials on an instance.
- Use security groups with minimum required ports and sources.
- Apply operating-system updates and monitor logs, metrics, and capacity.
- Back up important EBS data and test restore procedures.

## References

- [EC2 user guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)
- [EC2 instance types](https://docs.aws.amazon.com/ec2/latest/instancetypes/instance-types.html)
- [Amazon EBS](https://docs.aws.amazon.com/ebs/latest/userguide/what-is-ebs.html)
- [Security groups](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html)
