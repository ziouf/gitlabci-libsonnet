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