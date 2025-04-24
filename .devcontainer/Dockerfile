FROM    mcr.microsoft.com/devcontainers/go:1.24

RUN     go install github.com/google/go-jsonnet/cmd/jsonnet@latest \
    &&  go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest \
    &&  go install github.com/google/go-jsonnet/cmd/jsonnet-lint@latest \
    &&  go install github.com/google/go-jsonnet/cmd/jsonnet-deps@latest
