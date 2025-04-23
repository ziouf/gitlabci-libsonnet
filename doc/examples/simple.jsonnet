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