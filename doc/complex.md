# Complex Case

## Jsonnet

```jsonnet
// doc/examples/complex.jsonnet
local gl = import "../../gitlabci.libsonnet";

{
    modules:: ["first", "second"],

    "complex-pipeline.yaml":
         gl.pipeline.new(
            stages=["build", "test"],
        )
        .withJobs({
            ["test:%s" % [module]]: gl.job.new(
                stage="test",
                script=["cd %s" % [module], "make test"],
            ),
            for module in $.modules
        })
        .withJobs({  
            ["build:%s" % [module]]: gl.job.new(
                stage="build",
                script=["cd %s" % [module], "make test"],
            ),
            for module in $.modules
        })
        .toYaml(),
}
```

## Build 

```sh
jsonnet -m out -c -S doc/examples/complex.jsonnet
```

## Output

```yaml
# out/complex-pipeline.yaml
"build:first":
  script:
  - "cd first"
  - "make test"
  stage: "build"
"build:second":
  script:
  - "cd second"
  - "make test"
  stage: "build"
default:
  timeout: "1h"
stages:
- "build"
- "test"
"test:first":
  script:
  - "cd first"
  - "make test"
  stage: "test"
"test:second":
  script:
  - "cd second"
  - "make test"
  stage: "test"
```