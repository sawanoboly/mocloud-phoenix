FROM elixir:1.2

RUN apt-get -y update \
  && apt-get -y install build-essential git curl

ENV NAVE_DIR /opt/nave
ENV NAVE_NODEVER 5.10.1

ADD config /config

WORKDIR /opt/setup
ADD setup/install_nodejs.sh /opt/setup/install_nodejs.sh
RUN ./install_nodejs.sh
RUN mix local.hex --force
RUN mix local.rebar --force

ADD setup /opt/setup
ENTRYPOINT ["/opt/setup/run.sh"]
