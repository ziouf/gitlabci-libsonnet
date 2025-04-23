# Muiltiple output files Case

## Jsonnet

```jsonnet
// doc/examples/multiple-output-files.jsonnet
local gl = import "../../gitlabci.libsonnet";

{
    "multi-pipeline-1.yaml": 
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
    
    "multi-pipeline-2.yaml":
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
jsonnet -m out -c -S doc/examples/multiple-output-files.jsonnet
```

## Output

```yaml
# out/multi-pipeline-1.yaml
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

# out/multi-pipeline-2.yaml
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