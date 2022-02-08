FROM ubuntu:21.10

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y \
  curl \
  git \
  sudo \
  vim \
  zsh

COPY [".", "/dotfiles with space"]
RUN ["/dotfiles with space/install.sh"]

WORKDIR /root
ENTRYPOINT zsh
