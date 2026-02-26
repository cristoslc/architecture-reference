# Architecture Decision Record (ADR)

## ADR 13: Data Provisioning for Analytics and AI Model Development

### Status
- ACCEPTED

### Context
To facilitate analytical and reporting needs, as well as future AI model development, 
we need to establish a mechanism that enables access to both structured and unstructured data within the system.
The solution should accommodate growing volumes of data and varied query types, whilst remaining cost-effective. 
The solution should also ensure that sensitive candidate data is protected and adheres to country specific regulations such as GDPR.

### Decision
We have selected Option 1: Implement a lake-house architecture, as this provides the most efficient mechanism to create structured data to support our reporting and analytical needs, 
whilst maintaining the flexibility of data in its raw form to enable AI model training. We will need to ensure the relevant Guardrails are in place; such as:

- Ensuring that the lake-house architecture implements strong data governance practices to protect sensitive candidate information and comply with regulations such as GDPR. This includes data anonymization where necessary and maintaining audit logs for data access and changes.

- Implementing role-based access controls to restrict access to sensitive data based on user roles. This guardrail prevents unauthorized access and helps maintain data confidentiality and integrity.
Performance Monitoring:

- Establishing monitoring tools to continuously assess the performance of the lake-house architecture. Metrics should be defined for query performance, data loading times, and overall system responsiveness to ensure the solution meets performance expectations.

- Setting up processes for regularly evaluating the quality of data being ingested into the lake-house. Data quality checks must be in place to identify and rectify any anomalies or inaccuracies before the data is used for analysis or AI model training.

- Providing ongoing training and clear documentation for team members on how to effectively use the new lake-house architecture and tools. This will minimize operational risk associated with new technology adoption.

We will also look at implementing the following Fitness Functions:

- Measuring the time taken to execute queries on both structured and unstructured data within the lake-house. Regular evaluations should be conducted to ensure that data retrieval times remain within acceptable thresholds.

- Continuously evaluating the costs associated with maintaining the lake-house architecture against the benefits gained from improved analytics and AI model development. This includes analyzing storage costs, query processing costs, and personnel training costs.

- Conducting regular audits to assess compliance with GDPR and other data protection regulations. The results of these audits will inform any necessary adjustments to data management practices.

- Gathering feedback from users who interact with the data provisioning system regarding their experiences, challenges, and perceived improvements in data accessibility and analysis capabilities.

Data Quality Metrics:

Implementing metrics to monitor the quality of data ingested into the lake-house, such as accuracy rates, completeness, and timeliness. This evaluation will help ensure that high-quality data is consistently available for AI model training and analysis.

### Alternatives Considered
- **Option 1:** Data Lake-house  
  **Description**: Implement a lake-house architecture that combines the semantic flexibility of a data lake with the production optimization of a data warehouse,
  allowing for both structured and unstructured data to be managed in a single system.  
  **Pros**:     
  Lake houses can handle both schema-on-read (common in data lakes) and schema-on-write (common in data warehouses).
  This flexibility allows us to create structured data to support our reporting and analytical needs, whilst maintaining the flexibility of data in its raw form to enable AI model training. 
  A single lake-house architecture ensures that we do not sacrifice data governance and quality which can be a risk when managing multiple data platforms. Offloading analytical and reporting workloads
  to a lake-house will also remove unnecessary load from the operational systems and data stores, thus further enabling ease of scale.  
  **Cons**:     
  May require new tools and platforms that are still maturing compared to traditional solutions.
  The need for skills and expertise in lake-house technologies may necessitate additional training for the team. Additional cost of supporting this new platform, data storage and data transfer costs vs providing access
  to operational data stores directly. 


- **Option 2:** RESTful API that allows external access to data     
  **Description**: Develop a RESTful API that allows external access to data, with a service layer capable of handling requests for structured and unstructured data    
  **Pros**:     
  An API layer will attract significantly less cost than a dedicated data platform, as the compute costs will be relatively low. An API layer is also more efficient than direct access to SQL DBs
  as we can utilise caching or GraphQL for more common queries. APIs can be developed to meet bespoke customer needs and access can be easily maintained through industry standard secure protocols.   
  **Cons**:     
  Performance may vary based on API design and backend processing capabilities, and online processing e.g. test submissions could suffer performance degradation. Could introduce latency, especially if complex text analysis is required at the time of access. 
  May require significant development effort to create and maintain the API and processing logic.


- **Option 3:** Direct SQL Access   
  **Description**: Grant individual or system access to operational databases direct via database user accounts and SQL commands.    
  **Pros**:     
  Likely no additional expense as we will not have to factor in any additional compute. SQL flexibility enables a wide range of queries and enables bespoke access needs without IT intervention.
  **Cons**:     
  Application performance likely to be affected if complex queries are run during peak times. Difficult to control access to sensitive information. Operational database schema may not
  be designed to store historical transactions, thus the potential for data loss after a certain period which would adversely affect the availability of training data. 


- **Option 4:** Data Lake with Built-in Query Capabilities  
  **Description**: Utilize a data lake that supports querying capabilities to store both structured and unstructured data.  
  **Pros**:     
  Enables analytics and querying directly on the raw data without predefined schemas, allowing for flexibility. Offloading analytical and reporting workloads
  to a lake-house will also remove unnecessary load from the operational systems and data stores, thus further enabling ease of scale.       
  **Cons**:     
  The need for skills and expertise in data lake technologies may necessitate additional training for the team. Performance may suffer for structured data queries, 
  as data lakes are not optimized for such workloads compared to data warehouses. Data governance and compliance can be challenging as data flows between systems.

### References
[What is a Data Lakehouse?](https://docs.databricks.com/en/lakehouse/index.html)

### Date
02/11/2025
