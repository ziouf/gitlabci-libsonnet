# gitlabci-jsonnet

Jsonnet library to generate GitlabCI pipeline.

## Origin story

I created this library because I needed to generate a dynamic downstream pipeline in the case of a monorepo. We wanted to run only the build/test/package jobs for modules that had changed. In the case of a library, I wanted it to trigger the jobs for the modules affected by the change to this library. 
We had developed a utility to detect which modules were impacted, so all we had to do was generate the pipeline dynamically based on the impacted modules.

## Use case

Generate a pipeline file programmatically

## Usage

- simple case

```sh
jsonnet -m out -c -S examples/simple.jsonnet
```

```yaml
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

- complex case

```sh
jsonnet -m out -c -S examples/complex.jsonnet
```

```yaml
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

- dynamic case

```sh
jsonnet -m out -c -S --tls-str modules=a,b,c examples/dynamic.jsonnet
```

```yaml
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
