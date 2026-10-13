# 03 — S3: Simple Storage Service (Storage)

## What is S3?

Amazon S3 is an object storage service for storing and retrieving data through buckets and object keys. It is commonly used for files, backups, logs, static assets, data lakes, and application data.

## Buckets and objects

- **Bucket:** A container in an AWS Region for objects. General-purpose bucket names must be unique within an AWS partition.
- **Object:** The data plus metadata, identified by a key inside a bucket. S3 is object storage, not a traditional mounted file system, though integrations can expose file-like access.

## Storage classes

Different classes balance availability, access patterns, retrieval latency, and cost. Examples include:

- **S3 Standard:** Frequently accessed data with high availability.
- **S3 Intelligent-Tiering:** Can move objects between access tiers based on observed usage, subject to class rules and monitoring charges.
- **S3 Standard-IA / One Zone-IA:** Infrequently accessed data with retrieval charges; One Zone-IA stores data in one Availability Zone.
- **S3 Glacier Instant Retrieval, Flexible Retrieval, and Deep Archive:** Archive options with different retrieval times and costs.

Choose a class based on access frequency, durability/availability needs, minimum storage duration, and restore requirements. Features and class availability should be checked in the current AWS documentation.

## Versioning

S3 Versioning preserves multiple versions of an object as it is overwritten or deleted. It helps recover from accidental changes, but versions and delete markers can continue to use storage. Lifecycle rules can expire noncurrent versions.

## Lifecycle policies

Lifecycle rules automatically transition objects to supported storage classes or expire objects and noncurrent versions according to configured filters and timing. Test rules carefully because transitions, retrieval, and early deletion can incur charges.

## Encryption and security

S3 supports server-side encryption, including SSE-S3 and SSE-KMS, and client-side encryption patterns. Use TLS for data in transit, enable Block Public Access unless public access is explicitly required, and apply least-privilege bucket or identity policies. Use access logging, CloudTrail data events, or other audit mechanisms as appropriate for the workload.

## Bucket policies

A bucket policy is a resource-based JSON policy attached to the bucket. It can grant or deny access to principals, actions, and object resources under conditions. A policy should not be used to casually open data to the public. AWS Block Public Access helps prevent unintended public policies and ACL-based access.

## Common use cases

- Backups and archive data.
- Static website assets or media storage (with suitable access design).
- Data lakes and analytics inputs.
- Application uploads and document storage.
- Logs, exports, and disaster-recovery copies.

## References

- [S3 user guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)
- [S3 storage classes](https://docs.aws.amazon.com/AmazonS3/latest/userguide/storage-class-intro.html)
- [S3 Versioning](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Versioning.html)
- [S3 access management](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-management.html)
- [S3 encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingEncryption.html)
