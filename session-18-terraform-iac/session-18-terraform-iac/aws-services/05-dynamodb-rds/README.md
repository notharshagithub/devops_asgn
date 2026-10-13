# 05 — DynamoDB & RDS (Database Services)

AWS offers both managed NoSQL and managed relational database services. DynamoDB and Amazon RDS solve different data-model and operational needs.

## Part A — Amazon DynamoDB

### What is DynamoDB?

Amazon DynamoDB is a fully managed NoSQL database service that supports key-value and document data models. It is designed for predictable, low-latency access at scale without managing database servers.

### Tables, items, and attributes

- **Table:** A collection of data records.
- **Item:** One record in a table, broadly similar to a row.
- **Attribute:** A named value on an item, broadly similar to a field. Items in the same table do not need to have exactly the same non-key attributes.

### Partition key

The partition key is the primary key attribute used to determine the logical partition placement for an item. Its value should distribute workload well to avoid skewed traffic and hot partitions.

### Sort key

A sort key is an optional second component of a composite primary key. Multiple items can share a partition-key value but have different sort-key values, which supports ordered queries and related-record patterns.

### Use cases

- Shopping carts and user sessions.
- Gaming profiles, leaderboards, and player state.
- IoT telemetry and device state.
- High-scale key-value lookups and event metadata.
- Applications needing managed scaling and serverless-style operations.

### Design considerations

Model tables around access patterns; design partition and sort keys deliberately; use conditional writes and secondary indexes only as needed; monitor capacity, throttling, and costs. Choose on-demand or provisioned capacity based on the workload and its predictability.

## Part B — Amazon RDS

### What is RDS?

Amazon Relational Database Service (RDS) is a managed service that simplifies provisioning, patching, backups, monitoring, and operations for supported relational database engines.

### Supported engines

RDS supports engines including Amazon Aurora, PostgreSQL, MySQL, MariaDB, Oracle Database, and Microsoft SQL Server. Exact engine versions and features vary by Region and deployment option. Verify current availability before selecting an engine.

### DB instances and storage

A DB instance supplies compute and memory for a database engine and uses configured storage. Choose instance size, storage type, capacity, backup retention, networking, and maintenance settings based on workload requirements.

### Security

Place database instances in private subnets when possible, limit inbound access with security groups, use database authentication carefully, encrypt storage and backups, enable TLS where supported, and keep credentials in a managed secret store rather than source code.

### Backups

Automated backups support point-in-time recovery within the configured retention period, and manual snapshots can be retained longer. Confirm backup retention and recovery objectives match the importance of the data; test recovery procedures.

### Multi-AZ

Multi-AZ deployments provide availability through a standby or replicated configuration across Availability Zones, with failover behavior managed by the service. The exact architecture depends on the selected RDS option. Multi-AZ is primarily an availability feature, not a substitute for read scaling.

### Read replicas

Read replicas provide additional copies that can serve read traffic for supported engines and configurations. They can help scale reads and may be promoted for recovery scenarios depending on the engine and design. Replication lag and consistency behavior should be considered.

### Use cases

- Transactional applications using SQL and relational constraints.
- E-commerce orders and payments metadata.
- Content management systems and business applications.
- Applications that require SQL queries, joins, or existing relational schemas.

## DynamoDB vs RDS

| Dimension | DynamoDB | RDS |
|---|---|---|
| Data model | Key-value/document NoSQL | Relational SQL database |
| Schema | Flexible item attributes; key design is central | Tables, columns, types, and relational constraints |
| Query patterns | Key-based access and indexes designed for known patterns | SQL queries, joins, transactions, and relational workloads |
| Operations | Managed serverless-style service | Managed database instances or supported Aurora options |
| Typical fit | Very large scale, low-latency key-value access | Relational data, SQL, joins, and transactional consistency needs |

Neither service is universally better; select based on data model, access patterns, consistency, operational needs, resilience, and total cost.

## References

- [DynamoDB core components](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.CoreComponents.html)
- [DynamoDB partition and sort keys](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.CoreComponents.html)
- [Amazon RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Welcome.html)
- [RDS Multi-AZ deployments](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html)
- [RDS read replicas](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html)
