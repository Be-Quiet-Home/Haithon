# Haithon

Native Python bindings for the Haiku API.

Haithon exposes Haiku Kits through the stable `Be` Python package. Applications
can use native classes such as `BApplication`, `BWindow`, `BView`, and
`BMessage` directly from Python while retaining Haiku's message, ownership, and
platform semantics.

Haithon is an independent continuation of Haiku-PyAPI. The original license and
copyright notices are retained.

## Current status

A broad part of the Haiku API is already bound. The project is usable for native
application development, but the binding surface is still being hardened,
especially around object ownership, lifetimes, callback dispatch, and default
arguments.

The `Be` package name is intentionally retained for source compatibility.

## Building and verification

Haithon is currently distributed from source. The HaikuPorts package named
`haiku_pyapi_python310` belongs to the earlier project and does not contain
Haithon-specific changes.

Clone the repository with its submodules:

```
git clone https://github.com/Be-Quiet-Home/Haithon.git --recursive
cd Haithon
```

The repository-root `Makefile` is the public build entrypoint:

```
make
make clean
make help
```

`make` builds Haithon through the inherited Jam provider. `make clean` removes generated build products.

The default build uses Python 3.10 and the release profile. Build variables can
be overridden explicitly:

```
make PYTHON_VERSION=3.10 TYPE=debug JOBS=4
```

| Variable         | Description                                      |
| ---------------- | ------------------------------------------------ |
| `PYTHON_VERSION` | Python version. Default: `3.10`                  |
| `TYPE`           | `release` or `debug`. Default: `release`         |
| `JOBS`           | Number of parallel Jam jobs                      |
| `BUILD_DIR`      | Build directory                                  |

A stable system-wide installation or Haiku package contract has not yet been
declared. Consumers should use a validated Haithon commit and an isolated build
or staging directory.

## Documentation

Install the documentation dependencies and build the Sphinx documentation:

```
cd docs
pkgman install sphinx_python310 sphinx_rtd_theme_python310 sphinxcontrib_jquery_python310
make html
```

The generated documentation is written to `docs/build/html/`.

## Example

`example.py` contains a small native Haiku application using the `Be` package.
