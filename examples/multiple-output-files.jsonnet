local gl = import "../gitlabci.libsonnet";

{
    "multi-pipeline-1.yaml": std.manifestYamlDoc(
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
        }), 
        indent_array_in_object=false, 
        quote_keys=false,
    ),
    
    "multi-pipeline-2.yaml": std.manifestYamlDoc(
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
        }), 
        indent_array_in_object=false, 
        quote_keys=false,
    ),
}