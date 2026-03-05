# Big Data Development Environment

## Prerequisites

- [Nix](https://nixos.org/download.html) with flakes enabled
- Docker

### Installation

**Nix (with flakes):**
```bash
# Install Nix (choose single-user mode)
sh <(curl -L https://nixos.org/nix/install) --daemon

# Enable flakes (add to ~/.config/nix/nix.conf)
experimental-features = nix-command flakes
```

**Docker:**
Follow the [official guide](https://docs.docker.com/engine/install/).

## Quick Start

```bash
# Enter the development shell
nix develop

# Start Hadoop cluster (in another terminal or background)
cd hadoop-infra
docker-compose up -d
```

## Shell Functions

Available after running `nix develop`:

| Function | Description |
|----------|-------------|
| `hdfs-mkdir <path>` | Create directory in HDFS |
| `hdfs-copy <local> <hdfs>` | Copy local file to HDFS |
| `hdfs-cat <path>` | Print file contents from HDFS |
| `hdfs-rm <path>` | Remove file/directory from HDFS |
| `hdfs-ls [path]` | List files in HDFS |
| `hadoop-build` | Build Maven project |
| `hadoop-run <jar> <class> <input> <output>` | Run Hadoop job |

## Environment

The shell automatically configures:
- Java 17
- Maven (with local repository at `.m2/repository`)
- Hadoop classpath pointing to `hadoop-lib/`

## MapReduce Development

Use `labs/2/mapreduce/pom.xml` as a template for your MapReduce programs.
