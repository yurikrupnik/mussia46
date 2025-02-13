mod commands;
mod errors;

use commands::subcommand::parse_subcommand;
// use commands::Errors;
use errors::Errors;
use generals::tracing::init_tracing;

pub type Result<T> = core::result::Result<T, Errors>;

#[tokio::main]
async fn main() -> Result<()> {
    init_tracing();
    parse_subcommand().await?;
    Ok(())
}

#[cfg(test)]
mod test {
    use super::*;
    use clap::CommandFactory;
    use commands::subcommand::Args;

    #[test]
    fn verify_cli() {
        Args::command().debug_assert();
    }
}
