CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

create table if not exists tasks (
                                   id uuid primary key default uuid_generate_v4(),
  title varchar(255) not null,
  description varchar(255) not null default '',
  completed boolean not null default false
  );

insert into tasks (title, description, completed) values ('Hello, world!', 'My task desc', false);
insert into tasks (title, description, completed) values ('Clean room', 'My task desc', false);
insert into tasks (title, description, completed) values ('Present on Rust', 'Rust app for CLI and Webserver', true);


-- Create a trigger function
CREATE OR REPLACE FUNCTION notify_table_changes()
RETURNS TRIGGER AS $$
BEGIN
    -- Send a NOTIFY event with the table name and operation type
    PERFORM pg_notify('table_events',
                      json_build_object(
                          'table', TG_TABLE_NAME,
                          'action', 'insert',
                          'data', row_to_json(NEW),
                          'prev_data', row_to_json(OLD)
                      )::text);
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach the trigger to your target table (e.g., `my_table`)
CREATE TRIGGER tasks_trigger
  AFTER INSERT OR UPDATE OR DELETE ON tasks
  FOR EACH ROW EXECUTE FUNCTION notify_table_changes();
