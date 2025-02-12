# Using Handlers in Ansible

## Overview
Handlers in Ansible are special tasks that are triggered only when notified by other tasks. They are typically used for restarting services, reloading configurations, or any other operations that should occur only if a change is detected in a task.

Handlers help optimize automation by ensuring that operations like restarting a service happen only when necessary, preventing unnecessary disruptions.

---

## Directory Structure for Handlers

A well-structured Ansible role should include handlers under:
```
roles/
│── <role_name>/
│   ├── tasks/
│   │   ├── main.yml
│   ├── handlers/
│   │   ├── main.yml
```

### Example: Directory Structure
For example, in the role `database_container_setup`, the structure will look like this:
```
roles/
│── database_container_setup/
│   ├── tasks/
│   │   ├── main.yml
│   ├── handlers/
│   │   ├── main.yml
```

---

## Defining Handlers

Handlers are defined inside `handlers/main.yml` within a role. Below is an example:

📌 **roles/database_container_setup/handlers/main.yml**
```yaml
---
- name: Stop PostgreSQL Container
  docker_container:
    name: postgres-container
    state: stopped

- name: Start PostgreSQL Container
  docker_container:
    name: postgres-container
    state: started
```

---

## Calling Handlers with `notify`

To use handlers, you need to notify them from a task in `tasks/main.yml`:

📌 **roles/database_container_setup/tasks/main.yml**
```yaml
- name: Start PostgreSQL Container
  docker_container:
    name: postgres-container
    image: postgres:15
    state: started
    restart_policy: always
    env:
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "funkY!123"
      POSTGRES_DB: "docker_trials"
    ports:
      - "5432:5432"
  notify:
    - Stop PostgreSQL Container
    - Start PostgreSQL Container
```

---

## When Do Handlers Execute?
Handlers execute **only when a notifying task makes a change**. If no changes occur in the notifying task, the handler will not run.

### Example Scenario:
1. If the PostgreSQL container is already running, Ansible detects no change → **Handler does not run**.
2. If the PostgreSQL container is restarted due to a configuration change → **Handler is triggered**.

---

## Running the Playbook
To execute the playbook and use handlers, run:
```sh
ansible-playbook deploy_springboot_no_compose.yml -i inventory --ask-become-pass
```

This ensures the playbook executes while asking for sudo privileges.

---

## Best Practices for Handlers
✅ Use handlers only for tasks that need to run **conditionally** upon changes.
✅ Name handlers meaningfully (e.g., `Restart PostgreSQL Container`).
✅ Ensure that tasks using `notify` are actually making changes before expecting handlers to run.
✅ Keep handlers modular and reusable within roles.

---

## Conclusion
Handlers are a crucial part of Ansible automation, ensuring that necessary tasks like restarting services or refreshing configurations are done **only when needed**. This enhances efficiency and prevents unnecessary disruptions.

By structuring handlers properly within roles, you can improve the maintainability and scalability of your Ansible automation.

