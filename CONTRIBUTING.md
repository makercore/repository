# Contributing

When contributing to this repository, please first discuss the change you wish
to make via issue, email, or any other method with the owners of this repository
before making a change.

Please note we have a code of conduct, please follow it in all your interactions
with the project.

## Issues

Issues should be used to report problems, request a new feature, or to discuss
potential changes before a PR is created. When you create a new Issue, a
template will be loaded that will guide you through collecting and providing the
information we need to investigate.

If you find an Issue that addresses the problem you're having, please add your
own reproduction information to the existing issue rather than creating a new
one. Adding a reaction can also help be indicating to our maintainers that a
particular problem is affecting more than just the reporter.

## Pull Requests

1. Snippets must start with a comment block containing a short description of up
to 160 characters
2. Binary paths should not be hard-coded, and instead must be used through a
variable. This follows the GNU make style seen on predefined variables used by
implicit rules (e.g. `RM`, `CC` or `CXX`)
3. Variables should be namespaced using the snippet name as prefix, all
uppercase and with any non-alphanumeric characters replaced with underscore. The
only exception is the main binary, if the snippet is related to one (e.g. docker
snippet uses `DOCKER` to point to the binary)
4. Variables should be primarily optional (i.e. `?=`) with sane defaults. They
can also rely on more generic variables, specially with the `or` function
5. Do not use the shell assignment operator `!=`; instead, use the
widely-supported `$(shell <command>)`
6. Do not use the POSIX simple expansion assignment operator `::=`; instead, use
the widely-supported `:=` operator
7. Avoid using the recursive expansion assignment operator `=` unless strictly
needed
8. Ensure any intermediary artifacts (e.g. generated test reports, example
output, build archives) are not committed, and are properly ignored on
`.gitignore`
9. Update the specific checksum file, search and checksum indexes, both plain
and compressed forms
10. You may merge the Pull Request in once workflows are all passing, the target
branch can be rebased onto your branch and you have the sign-off of at least one
developer. If you do not have permission to merge, you may request a reviewer to
merge it for you
