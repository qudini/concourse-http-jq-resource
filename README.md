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

## Example

```yaml
resource_types:
- name: bamboo-resource
  type: docker-image
  source:
    repository: qudini/concourse-http-resource
    tag: latest

resources:
  - name: bamboo-resource
    type: http-resource
    source:
      base_url: https://www.bamboo.com/rest/api/latest/deploy/environment/{env_id}/results?os_authType=basic
      jq_filter: "{version:.results[].deploymentVersion.id|tostring"
      credentials: ((username)):((password))
```
