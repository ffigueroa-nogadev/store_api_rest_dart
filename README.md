# 🦄 Dart Server Project

Backend server built with **Dart**, using **PostgreSQL** as the database and **Docker** for the development environment.
It includes support for **automatic migrations**, **hot reload in dev mode**, and configuration through `.env` files.

---

## 🚀 Prerequisites

Make sure you have the following installed before starting:

* [Dart SDK](https://dart.dev/get-dart) (latest stable version)
* [Docker](https://docs.docker.com/get-docker/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Derry](https://pub.dev/packages/derry) (to run scripts defined in `pubspec.yaml`)

---

## ⚙️ Installation

1. **Clone the repository**

   ```bash
   git clone <repo-url>
   cd <project-name>
   ```

2. **Install dependencies**

   ```bash
   dart pub get
   ```

3. **Configure environment variables**

   ```bash
   cp .env.example .env
   ```

4. **Start the database using Docker**

   ```bash
   docker compose up -d
   ```

---

## 🧩 Database migrations

This project uses **Derry** to handle migration scripts defined in `pubspec.yaml`.

Install Derry globally if you don’t have it yet:

```bash
dart pub global activate derry
```

Run migrations using the available scripts:

```bash
derry run migrate:up       # Runs pending migrations
derry run migrate:down     # Rolls back the last migration
derry run migrate:fresh    # Resets the database
```

---

## 💻 Development mode (with hot reload)

Run the project in development mode with **hot reload**:

```bash
dart run dev.dart
```

To make it easier, you can create an alias:

```bash
echo 'alias dartdev="dart run dev.dart"' >> ~/.zshrc    # For Zsh
# or
echo 'alias dartdev="dart run dev.dart"' >> ~/.bashrc   # For Bash

source ~/.zshrc  # or ~/.bashrc
```

Then simply run:

```bash
dartdev
```

---

## 🖥️ Run the server

To run the server in production mode or without hot reload:

```bash
dart run bin/server.dart
```

---

## 🧰 Project structure

```
.
├── bin/
│   └── server.dart          # Server entry point
├── lib/
│   ├── db/                  # Database setup and migrations
│   ├── services/            # Business logic
│   ├── routes/              # API routes
│   └── ...                  
├── .env.example             # Example environment variables
├── docker-compose.yml       # PostgreSQL configuration
├── pubspec.yaml             # Dependencies and Derry scripts
└── dev.dart                 # Development script with hot reload
```

---

## 🧾 Useful scripts

| Script                     | Description                                           |
| -------------------------- | ----------------------------------------------------- |
| `dart run dev.dart`        | Starts the server in development mode with hot reload |
| `dart run bin/server.dart` | Starts the production server                          |
| `derry run migrate:up`     | Runs pending migrations                               |
| `derry run migrate:down`   | Rolls back the last migration                         |
| `derry run migrate:fresh`  | Resets the database                                   |

---

## 🧑‍💻 Author

**Facundo Exequiel Figueroa**
💬 Contact: *figueroafacundoexequiel@gmail.com*

