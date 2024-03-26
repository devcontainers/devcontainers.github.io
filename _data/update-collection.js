const fs = require('fs');
const yaml = require('js-yaml');
const eventPayload = require(process.env.GITHUB_EVENT_PATH);

const issueBodyLines = eventPayload.issue.body.split(/\r?\n/);

let name, maintainer, contact, repository, ociReference;

issueBodyLines.forEach((line, index) => {
    const trimmedLine = line.trim().toLowerCase();
    switch (trimmedLine) {
        case '### collection name':
            name = issueBodyLines[index + 2];
            break;
        case '### maintainer name':
            maintainer = issueBodyLines[index + 2];
            break;
        case '### maintainer contact link (i.e. repo issues link, email)':
            contact = issueBodyLines[index + 2];
            break;
        case '### repository url':
            repository = issueBodyLines[index + 2];
            break;
        case '### oci reference':
            ociReference = issueBodyLines[index + 2];
            break;
    }
});

const content =
`\n- name: ${name}
  maintainer: ${maintainer}
  contact: ${contact}
  repository: ${repository}
  ociReference: ${ociReference}
`;

fs.appendFileSync(`${process.env.GITHUB_WORKSPACE}/_data/collection-index.yml`, content);