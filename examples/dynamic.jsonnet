local gl = import "../gitlabci.libsonnet";

function(modules="", sep=',')
{
    modules:: std.split(modules, sep),

    "dynamic-pipeline.yaml": std.manifestYamlDoc(
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
        }), 
        indent_array_in_object=false, 
        quote_keys=false,
    ),
}