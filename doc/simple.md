# Simple Case

## Jsonnet 

```jsonnet
// doc/examples/simple.jsonnet
local gl = import "../../gitlabci.libsonnet";

{
    "simple-pipeline.yaml":
         gl.pipeline.new(
            stages=["build", "test"],
        )
        .withJobs({
            "test": gl.job.new(
                stage="test",
                script="make test",
            ),
            "build": gl.job.new(
                stage="build",
                script="make test",
            ),
        })
        .toYaml(),
}
```

## Build

```sh
jsonnet -m out -c -S doc/examples/simple.jsonnet
```

## Output

```yaml
# out/simple-pipeline.yaml
build:
  script:
  - "make test"
  stage: "build"
default:
  timeout: "1h"
stages:
- "build"
- "test"
test:
  script:
  - "make test"
  stage: "test"
```