FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
  curl \
  git \
  vim \
  zsh

COPY [".", "/dotfiles with space"]
RUN ["/dotfiles with space/install.sh"]

WORKDIR /root
ENTRYPOINT zsh
