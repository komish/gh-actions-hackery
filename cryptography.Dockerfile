ARG CRYPTOGRAPHY_VERSION=43.0.1

FROM registry.access.redhat.com/ubi9-minimal:9.4-1227 AS basebuilder
ARG CRYPTOGRAPHY_VERSION
# Install Rust so that we can ensure backwards compatibility with installing/building the cryptography wheel across all platforms
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustc --version
RUN uname -a

RUN set -e && microdnf clean all && rm -rf /var/cache/microdnf/* \
  && microdnf update -y \
  && microdnf install -y libffi-devel openssl-devel python3-devel gcc python3-pip python3-setuptools \
  && pip3 install --upgrade pip~=23.3.2 \
  && pip3 install pipenv==2023.11.15 \
  && pip3 install -vvv cryptography==$CRYPTOGRAPHY_VERSION \
  && microdnf remove -y gcc libffi-devel openssl-devel python3-devel \
  && microdnf clean all \
  && rm -rf /var/cache/microdnf