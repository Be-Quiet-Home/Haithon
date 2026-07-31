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

## Installing

Haithon is currently distributed from source. The HaikuPorts package named
`haiku_pyapi_python310` belongs to the earlier project and does not contain
Haithon-specific changes.

Clone the repository with its submodules:

```
git clone https://github.com/Be-Quiet-Home/Haithon.git --recursive
cd Haithon
```

Build using all available CPU cores:

```
jam -j$(nproc)
```

Install the `Be` Python package:

```
jam install
```

## Build parameters

Additional build parameters use the `-sPARAMETER=VALUE` form.

| Parameter        | Description                                   |
| ---------------- | --------------------------------------------- |
| python_version   | Python version. Default: 3.10                 |
| py               | Alias of `python_version`                     |
| type             | Debug or release build. Default: release      |
| build_location   | Build directory. Default: `build/python$(python_version)_$(type)` |
| install_location | Installation root. Default: `/boot/system/non-packaged/lib/python$(python_version)/site-packages` |

For example, an isolated release build for Python 3.10 can be created with:

```
jam -j$(nproc) \
    -spython_version=3.10 \
    -stype=release \
    -sbuild_location=/boot/home/config/cache/Haithon-build
```

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
