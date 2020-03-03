# Concourse HTTP jq resource

A Concourse resource to make HTTP calls to JSON endpoints, and parse them using custom JQ filter. 

## Source Configuration

| Parameter                   | Required | Example                                     | Description                                                                                                                                                                                                                                                                                |
|-----------------------------|----------|---------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `base_url`                  | Yes      | `https://api.github.com/users/octocat/orgs` | Url for the json payload to get.                                                                                                                                                                                                                                                           |
| `jq_filter`                 | Yes      | `{user, title: .titles[]}`                  | Valid JQ filter                                                                                                                                                                                                                                                                            |
| `credentials`               | No       | `root:hunter2`                              | Basic auth. Will be base64 encoded.                                                                                                                                                                                                                                                           |

Notes:
 - Look at the [Concourse Resources documentation](https://concourse-ci.org/resources.html#resource-webhook-token)
 for webhook token configuration.

## Behaviour

#### `check`

Produces new versions from a JSON payload defined in `base_url`. `jq_filter` then parses the payload accordingly to your needs.

#### `get`

Does nothing.

#### `put`

Does nothing.

## Examples
### Check deployment version on Bamboo
```yaml
resource_types:
- name: http-jq-resource
  type: docker-image
  source:
    repository: qudini/concourse-http-jq-resource
    tag: latest

resources:
  - name: bamboo-staging-release
    type: http-jq-resource
    source:
      base_url: https://<Bamboo instance>/rest/api/latest/deploy/environment/{env_id}/results?os_authType=basic
      jq_filter: "{.results[] | {"deploymentVersionName":.deploymentVersionName,"id":.id|tostring,"key":.deploymentVersion.items[0].planResultKey.key,"startedDate":.startedDate|tostring,finishedDate:.finishedDate|tostring}"
      # bamboo_readonly_credentials = username:password
      credentials: ((bamboo_readonly_credentials))
```
Results in
```json
[
    {
      "deploymentVersionName": "master-718",
      "id": "107282481",
      "key": "KEY-QD678-718",
      "startedDate": "1579089918295",
      "finishedDate": "1579090971755"
    },
    {
      "deploymentVersionName": "master-717",
      "id": "107282475",
      "key": "KEY-QD678-717",
      "startedDate": "1579027585024",
      "finishedDate": "1579028083334"
    }
]
```
### Check Docker Hub for new docker image tag to trigger a job

```yaml
resource_types:
- name: http-jq-resource
  type: docker-image
  source:
    repository: qudini/concourse-http-jq-resource
    tag: latest

resources:
  - name: dockerhub-http-jq-release
    type: http-jq-resource
    source:
      base_url: https://registry.hub.docker.com/v1/repositories/qudini/concourse-http-jq-resource/tags
      jq_filter: ".[] | {releaseTag:.name}"
```
Results in 
```json
[
    {
      "releaseTag": "latest"
    },
    {
      "releaseTag": "0.1.0"
    },
    {
      "releaseTag": "v0.1.1"
    },
    {
      "releaseTag": "v0.1.2"
    }
]
```
