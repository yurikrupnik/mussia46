FROM messense/rust-musl-cross:x86_64-musl AS chef
# We only pay the installation cost once,
# it will be cached from the second build onwards
RUN cargo install cargo-chef

WORKDIR app

FROM messense/rust-musl-cross:x86_64-musl AS planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM messense/rust-musl-cross:x86_64-musl AS builder
WORKDIR /app

COPY --from=planner /app/recipe.json recipe.json
RUN cargo install cargo-chef --locked
RUN cargo chef cook --release --recipe-path recipe.json

ARG APP_NAME
COPY ./Cargo.toml .
COPY ./Cargo.lock .
COPY ./nx.json .
COPY ./apps ./apps
COPY ./libs ./libs
RUN cargo build --release -p $APP_NAME --target x86_64-unknown-linux-musl

FROM scratch AS final
ARG APP_NAME
COPY --from=builder /target/x86_64-unknown-linux-musl/release/$APP_NAME /$APP_NAME
ENV PORT=8080
EXPOSE ${PORT}
ENTRYPOINT ["/$APP_NAME"]
