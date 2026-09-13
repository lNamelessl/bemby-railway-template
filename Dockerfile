# Bemby on Railway — thin wrapper around the official upstream image.
#
# Pinned to upstream release 1.0.0 (Docker Hub tag `1.0.0`, which is also `latest`
# as of 2026-08-04), built from github.com/liveinaus/Bemby main @ 23c9cb4.
# Bump the tag deliberately after checking the upstream changelog.
FROM docker.io/liveinaus/bemby:1.0.0

# Railway terminates TLS on its reverse proxy and forwards traffic to the container,
# i.e. exactly one proxy hop. The upstream docs recommend TRUST_PROXY=1 in that setup
# so client IPs are read from X-Forwarded-For rather than spoofable directly.
ENV TRUST_PROXY=1
