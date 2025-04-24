local gl = import '../../gitlabci.libsonnet';

{
  'multi-pipeline-1.yaml':
    gl.pipeline.new(
      stages=['build', 'test'],
    )
    .withJobs({
      test: gl.job.new(
        stage='test',
        script='make test',
      ),
      build: gl.job.new(
        stage='build',
        script='make test',
      ),
    })
    .toYaml(),

  'multi-pipeline-2.yaml':
    gl.pipeline.new(
      stages=['build', 'test'],
    )
    .withJobs({
      test: gl.job.new(
        stage='test',
        script='make test',
      ),
      build: gl.job.new(
        stage='build',
        script='make test',
      ),
    })
    .toYaml(),
}
