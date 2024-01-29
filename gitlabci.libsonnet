// 
// Gitlab pipeline library
// 
{
    pipeline:: {
        new(timeout="1h", interruptible=false, retry=false, tags=null, stages=null):: {
            default: {
                timeout: timeout,
                [if interruptible then "interruptible"]: interruptible,
                [if retry then "retry"]: 2,
                [if std.isString(tags) || std.isArray(tags) then "tags"]: 
                    if std.isArray(tags) then tags else std.split(tags, ',')
            },
            [if std.isArray(stages) || std.isString(stages) then "stages"]: 
                if std.isArray(stages) then stages else [stages],
            // 
            // Defaults
            // 
            withDefault(default):: self + {
                default+: default
            },
            // 
            // Includes
            // 
            withInclude(include):: self + {
                include+: if std.isArray(include) then include else [include],
            },
            // 
            // Stages
            // 
            withStages(stages):: self + {
                stages+: if std.isArray(stages) then stages else [stages]
            },
            // 
            // Workflows
            // 
            withWorkflow(workflow):: self + {
                workflow: workflow,
            },
            // 
            // Jobs
            // 
            withJobs(jobs):: self + jobs,
            disableJob(jobs):: self + (
                if std.isArray(jobs) then 
                {
                    [j]+: { rules: [{when: "never"}]}
                    for j in jobs
                }
                else
                {
                    [jobs]+: { rules: [{when: 'never'}]}
                }
            ),
        },
        default:: {
            new(interruptible=true, retry=2):: {
                interruptible: interruptible,
                retry: retry,

                withAfterScript(script):: self + {
                    after_script+: if std.isArray(script) then script else [script],
                },
                withArtifacts(artifacts):: self + { artifacts: artifacts },
                withBeforeScript(script):: self + {
                    before_script+: if std.isArray(script) then script else [script],
                },
                withCache(cache):: self + { cache: cache },
                withHooks(hooks):: self + { hooks: hooks },
                withInterruptible(interruptible):: self + { interruptible: interruptible },
                withRetry(retry=2):: self + { retry: retry },
                withServices(services):: self + { 
                    services+: if std.isArray(services) then services else [services],
                },
                withTimeout(timeout):: self + { timeout: timeout },
                withTags(tags):: self + {
                    tags+: if std.isArray(tags) then tags else [tags],
                },
            },
        },
        includes:: {
            new(inputs):: {
                [if std.isObject(inputs) then "inputs"]: inputs,
            },
            newComponent(path, inputs=null):: self.new(inputs) + { component: path },
            newLocal(path, inputs=null):: self.new(inputs) + { "local": path },
            newProject(project, file, ref=null, inputs=null):: self.new(inputs) + {
                project: project,
                file: if std.isArray(file) then file else [file],
                [if std.isString(ref) then "ref"]: ref,
            },
            newRemote(url, inputs=null):: self.new(inputs) + { remote: url },
            newTemplate(template, inputs=null):: self.new(inputs) + { template: template },
        },
        workflow:: {
            new(name=null):: {
                [if std.isString(name) then "name"]: name,

                withAutoCancel(policy="interruptible"):: self + {
                    auto_cancel: { on_new_commit: policy }
                },
                withRules(rules):: self + {
                    rules+: if std.isArray(rules) then rules else [rules],
                },
            },
        },
    },
    // 
    // Jobs
    // 
    job:: {
        new(stage, script=null, retry=false):: {
            stage: stage,
            [if std.isArray(script) || std.isString(script) then "script"]: 
                if std.isArray(script) then script else [script],
            [if retry then "retry"]: 2,

            withExtends(name):: self + {
                extends+: [name],
            },
            withDependencies(dependencies):: self + {
                dependencies+: if std.isArray(dependencies) then dependencies else [dependencies],
            },
            withEnvironment(name, auto_stop_in="1h"):: self + {
                environment: {
                    name: name,
                    auto_stop_in: auto_stop_in,
                    // deployment_tier: deployment_tier,
                },
            },
            withImage(image, entrypoint=[""]):: self + {
                image: {
                    name: image,
                    entrypoint: if std.isArray(entrypoint) then entrypoint else [entrypoint],
                }
            },
            withRetry():: self + {
                retry: 2,
            },
            withVariables(variables):: self + {
                variables+: variables,
            },
            withSecrets(secrets):: self + {
                secrets+: secrets,
            },
            setRules(rules):: self + {
                rules: if std.isArray(rules) then rules else [rules]
            },
            withRules(rules):: self + {
                rules+: if std.isArray(rules) then rules else [rules]
            },
            withService(service, variables=null, before_script=null):: (
                if std.isObject(service)
                then self + {
                    services+: if std.isArray(service) then service else [service],
                    [if std.isObject(variables) then "variables"]+: variables,
                    [if std.isArray(before_script) || std.isString(before_script) then "before_script"]+: 
                        if std.isArray(before_script) then before_script else [before_script],
                }
                else self
            ),
            withBeforeScript(script):: self + {
                before_script+: if std.isArray(script) then script else [script]
            },
            withScript(script):: self + {
                script+: if std.isArray(script) then script else [script]
            },
            withAfterScript(script):: self + {
                after_script+: if std.isArray(script) then script else [script]
            },
            withAllowFailure(allow=true, exit_codes=null):: self + {
                allow_failure: if std.isArray(exit_codes) then {exit_codes: exit_codes} else allow
            },
            withCoverage(coverage):: self + {
                coverage: coverage
            },
            withNeedJob(job, artifacts=false, optional=false):: self + {
                needs+: [{ job: job, artifacts: artifacts, optional: optional }]
            },
            withParallel(count):: self + {
                parallel: count,
            },
            withParallelMatrix(matrix):: self + {
                parallel: { matrix: matrix }
            },

            withArtifacts(artifacts):: self + { artifacts: artifacts },
            withCache(cache):: self + { cache: cache },
            withHooks(hooks):: self + { hooks: hooks },
        },
        artifacts:: {
            new(name=null, expire_in=null, when="on_success", paths=null):: {
                [if std.isString(name) then "name"]: name,
                [if std.isString(expire_in) then "expire_in"]: expire_in,
                when: when,
                [if std.isString(paths) || std.isArray(paths) then "paths"]: 
                    if std.isArray(paths) then paths else [paths],

                withPath(path):: self + { paths+: if std.isArray(path) then path else [path]},
                withExclude(path):: self + { exclude+: if std.isArray(path) then path else [path] },
                withExpireIn(expire):: self + { expire_in: expire },
                withExposeAs(name):: self + { expose_as: name },
                withName(name):: self + { name: name, },
                withPublic(isPublic=true):: self + { public: isPublic },
                withUntracked(untracked=true):: self + { untracked: untracked },

                withReportCoverage(format, path):: self + {
                    reports+: { coverage_report: {coverage_format: format, path: path } }
                },
                withReportCodeQuality(file):: self + {
                    reports+: { codequality: file }
                },
                withReportContainerScanning(file):: self + {
                    reports+: { container_scanning: file }
                },
                withReportCoverageFuzzing(file):: self + {
                    reports+: { coverage_fuzzing: file }
                },
                withReportDAST(file):: self + {
                    reports+: { dast: file }
                },
                withReportDependencyScanning(file):: self + {
                    reports+: { dependency_scanning: file }
                },
                withReportDotenv(file):: self + {
                    reports+: { dotenv: file }
                },
                withReportJunit(file):: self + {
                    reports+: { junit+: if std.isArray(file) then file else [file] }
                },
                withReportLoadPerformance(file):: self + {
                    reports+: { load_performance: file }
                },
                withReportRequirements(file):: self + {
                    reports+: { requirements: file }
                },
                withReportSAST(file):: self + {
                    reports+: { sast: file }
                },
                withReportSecretDetection(file):: self + {
                    reports+: { secret_detection: file }
                },
                withReportTerraform(file):: self + {
                    reports+: { terraform: file }
                },
            },
        },
        cache:: {
            new(paths, when="on_success", policy="pull-push", key=null):: {
                paths: if std.isArray(paths) then paths else [paths],
                when: when,
                policy: policy,
                [if std.isString(key) then "key"]: key,

                withPath(path):: self + {
                    paths+: if std.isArray(path) then path else [path],
                },
                withKey(key):: self + { key: key },
                withKeyFile(files, prefix=null):: self + {
                    key: {
                        files: if std.isArray(files) then files else [files],
                        [if std.isString(prefix) then "prefix"]: prefix,
                    }
                },
                withUntracked(bool=true):: self + { untracked: bool },
                withUnprotect(bool=true):: self + { unprotect: bool },
                withPolicy(policy):: self + { policy: policy },
                withFallbackKeys(keys):: self + {
                    fallback_keys+: if std.isArray(keys) then keys else [keys],
                },
            }
        },
        hooks:: {
            new():: {
                withPreGetSources(script): self + {
                    pre_get_sources_script+: if std.isArray(script) then script else [script],
                }
            },
        },
        image:: {
            new(name, entrypoint=[""]):: {
                name: name,
                entrypoint: if std.isArray(entrypoint) then entrypoint else [entrypoint],

                withEntrypoint(entrypoint):: self + {
                    entrypoint+: if std.isArray(entrypoint) then entrypoint else [entrypoint],
                },
                withDocker(platform="linux/amd64", user="root"):: self + {
                    platform: platform,
                    user: user,
                },
                withPullPolicy(policy):: self + { pull_policy: policy },
            }
        },
        services:: {
            new(name, alias, entrypoint=[""]):: {
                name: name,
                alias: alias,
                entrypoint: if std.isArray(entrypoint) then entrypoint else [entrypoint],

                withCommand(cmd):: self + { command: if std.isArray(cmd) then cmd else [cmd] },
                withDocker(platform="linux/amd64", user="root"):: self + {
                    platform: platform,
                    user: user,
                },
                withPullPolicy(policy):: self + { pull_policy: policy },
                withVariables(variables):: self + { variables+: variables },
            },
        },
    }
}