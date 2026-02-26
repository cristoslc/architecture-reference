# Use Case: Upload and submit a resume

In this use case, the following requirements are covered:

- **Uploading a Resume**: [R2](/Requirements/requirements-and-assumptions.md)
- **Receiving Resume Tips**: [R3](/Requirements/requirements-and-assumptions.md)
- **Submitting the Resume**: [R4](/Requirements/requirements-and-assumptions.md)

Additionally, the process triggers the creation of:

- **S.M.A.R.T. Stories**: [R12](/Requirements/requirements-and-assumptions.md)

## Involved Containers
- **Job Candidate**: Refer to [C3 Job Candidate](/C4/C3-components-job-candidate.md).
- **Story**: Refer to [C3 Story](/C4/C3-components-story.md).
- **Shared Database**: A common storage location used by multiple services.

## Sequence diagrams

### Upload a resume and generate resume tips
![Upload a resume](/UseCases/images/upload-a-resume.png)


#### Description
1. When a **Job Candidate** uploads a resume through the UI, it gets stored in the **Database**.
2. The resume upload triggers a call to the **AI Resume Tips Adapter** to initiate tips generation.
3. At this point, the upload action is considered complete.

4. In the background, the **AI Resume Tips Adapter** sends the resume to the **AI Resume Tips System**.
5. After processing, the **AI Resume Tips System** returns the generated resume tips to the **Resume Service**.
6. The **Resume Service** then persists these tips in the **Database**.

7. When the Job Candidate revisits the page, they can view the resume tips.

> Possible extension: Implement a mail-based notification to alert the job candidate when resume tips are available.


### Submit a resume
![Submit a resume](/UseCases/images/submit-a-resume.png)

#### Description
When a **Job candidate** is satisfied with their resume, they can choose to **submit** it.

1. The submitted resume is stored in the **Database**.
2. The resume is then retrieved from the database and sent to the **Story Container**.
3. This triggers the **asynchronous creation** of the **S.M.A.R.T. story** ([R12](/Requirements/requirements-and-assumptions.md) & [ADR-009](/ADR/ADR-009-creation-of-story-as-own-microservice.md)).

The **submit resume** action completes **before** the story creation process is finished. Note that the **story creation** is **not included** in this sequence diagram.
