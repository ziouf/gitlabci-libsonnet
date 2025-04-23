# Dynamic Case

## Jsonnet

```jsonnet
// doc/examples/dynamic.jsonnet
local gl = import "../../gitlabci.libsonnet";

function(modules="", sep=',')
{
    modules:: std.split(modules, sep),

    "dynamic-pipeline.yaml":
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
jsonnet -m out -c -S --tla-str modules=a,b,c doc/examples/dynamic.jsonnet
```

## Output

```yaml
# out/dynamic-pipeline.yaml
"build:a":
  script:
  - "cd a"
  - "make test"
  stage: "build"
"build:b":
  script:
  - "cd b"
  - "make test"
  stage: "build"
"build:c":
  script:
  - "cd c"
  - "make test"
  stage: "build"
default:
  timeout: "1h"
stages:
- "build"
- "test"
"test:a":
  script:
  - "cd a"
  - "make test"
  stage: "test"
"test:b":
  script:
  - "cd b"
  - "make test"
  stage: "test"
"test:c":
  script:
  - "cd c"
  - "make test"
  stage: "test"
```