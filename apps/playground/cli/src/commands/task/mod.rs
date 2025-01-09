use clap::Parser;
use models::task::{CreateTaskArgs, UpdateTaskArgs};

#[derive(Parser, Debug)]
pub struct TaskSubcommand {
    #[clap(subcommand)]
    pub action: TaskAction,
}

#[derive(Parser, Debug)]
pub enum TaskAction {
    #[clap(about = "Create a new Task", name = "create")]
    Create(CreateTaskArgs),
    #[clap(about = "Update a Task")]
    Update(UpdateCommand),
    #[clap(about = "Get a Task by ID")]
    Get(GetTask),
    #[clap(about = "Delete a Task by ID")]
    Delete(DeleteTask),
    #[clap(about = "Read Tasks")]
    List,
    #[clap(about = "Drop all Tasks")]
    Drop,
}

#[derive(Debug, Parser)]
pub struct GetTask {
    /// Task ID
    pub id: String,
}

#[derive(Parser, Debug)]
pub struct DeleteTask {
    /// Task IDs
    pub id: Vec<String>,
}

#[derive(Parser, Debug)]
pub struct UpdateCommand {
    /// Task ID
    pub id: String,

    #[clap(flatten)]
    pub body: UpdateTaskArgs,
}
