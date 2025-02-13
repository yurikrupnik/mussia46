use crossterm::style::{Color, Stylize};
use std::process::Command;

// Helper function to format Option<String>
pub fn format_option(value: &Option<String>) -> String {
    match value {
        // todo check benchmark
        // Some(s) => String::from(s).with(Color::Blue).to_string(),
        // Some(s) => String::from(s),
        Some(s) => s.into(),
        None => String::from("None"),
    }
}

pub fn color_bool(completed: &bool) -> String {
    if *completed {
        "✔".with(Color::Green).to_string()
    } else {
        "✘".with(Color::Red).to_string()
    }
}

pub fn color_title(title: &str) -> String {
    title.with(Color::DarkGreen).bold().to_string()
}

pub fn run_kubectl_command<T>(command: &str, resource: &str) {
    // assert!(Command::new("kubectl").status().expect("ads"), "kubectl is not installed");
    let output = Command::new("sh")
        .arg(command)
        .arg(resource)
        .output()
        .expect("Failed to execute kubectl command");
    if output.status.success() {
        println!("{}", String::from_utf8_lossy(&output.stderr));
    } else {
        eprintln!("{}", String::from_utf8_lossy(&output.stderr));
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        let result = 2 + 2;
        assert_eq!(result, 4);
    }
}
