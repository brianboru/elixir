
FROM bitwalker/alpine-elixir:latest
LABEL Name=simple_console Version=0.0.1
COPY . .

RUN export MIX_ENV=dev && \
    rm -Rf _build && \
    mix deps.get && \
    mix start