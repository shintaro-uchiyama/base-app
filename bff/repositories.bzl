load("@bazel_gazelle//:deps.bzl", "go_repository")

def go_repositories():
    go_repository(
        name = "com_github_google_uuid",
        importpath = "github.com/google/uuid",
        sum = "h1:kxhtnfFVi+rYdOALN0B3k9UT86zVJKfBimRaciULW4I=",
        version = "v1.1.5",
    )
