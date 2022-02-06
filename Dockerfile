FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
  curl \
  git \
  vim \
  zsh

COPY . /dotfiles
RUN ["/dotfiles/install.sh"]

WORKDIR /root
ENTRYPOINT zsh
