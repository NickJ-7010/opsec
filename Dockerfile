FROM oven/bun:1-slim AS base

FROM base AS install
RUN mkdir -p /tmp
COPY package.json bun.lock /tmp/

RUN cd /tmp && bun install --frozen-lockfile --production --os linux --cpu arm64

FROM base AS prerelease
COPY --from=install /tmp/node_modules node_modules
COPY . .

RUN bun build --compile --target=bun-linux-arm64 --define 'process.env.OPENTUI_LIBC="glibc"' ./src/app.tsx --outfile /opsec

FROM debian:bookworm-slim AS bundler

ARG REPO_ORIGIN
ARG REPO_CODENAME
ARG REPO_ARCH
ARG GPG_PRIVATE_KEY_B64
ARG GPG_PASSPHRASE
ARG GNUPGHOME

RUN apt-get update && \
    apt-get install -y --no-install-recommends reprepro gnupg && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opsec-build/DEBIAN
RUN mkdir -p /opsec-build/usr/local/bin

COPY --from=prerelease /opsec /opsec-build/usr/local/bin/opsec
RUN chmod 0755 /opsec-build/usr/local/bin/opsec

RUN mkdir -p /tmp/packages

COPY ./bundle.sh .

RUN ./bundle.sh

FROM nginx/nginx-unprivileged:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=bundler /repo /usr/share/nginx/html

EXPOSE 8080
