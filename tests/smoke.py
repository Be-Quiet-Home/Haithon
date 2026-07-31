from pathlib import Path
import sys


EXPECTED_EXTENSION_COUNT = 203
REQUIRED_SYMBOLS = (
    "BApplication",
    "BMessage",
    "BSplitView",
    "BView",
    "BWindow",
)
FOREIGN_GUI_PREFIXES = (
    "PyQt",
    "PySide",
    "gi",
    "gtk",
    "wx",
)


def fail(message):
    raise SystemExit(f"FAIL: {message}")


def main():
    if len(sys.argv) != 2:
        fail("expected the smoke staging root")

    stage_root = Path(sys.argv[1]).resolve()

    import Be

    package_path = Path(Be.__file__).resolve()
    try:
        package_path.relative_to(stage_root)
    except ValueError:
        fail(f"Be imported outside smoke staging: {package_path}")

    missing = [name for name in REQUIRED_SYMBOLS if not hasattr(Be, name)]
    if missing:
        fail(f"missing required symbols: {', '.join(missing)}")

    extension_count = len(list((stage_root / "Be").glob("*.so")))
    if extension_count != EXPECTED_EXTENSION_COUNT:
        fail(
            "unexpected extension count: "
            f"{extension_count} != {EXPECTED_EXTENSION_COUNT}"
        )

    foreign_modules = sorted(
        name
        for name in sys.modules
        if any(
            name == prefix or name.startswith(prefix + ".")
            for prefix in FOREIGN_GUI_PREFIXES
        )
    )
    if foreign_modules:
        fail(f"foreign GUI modules imported: {', '.join(foreign_modules)}")

    print(f"Be package = {package_path}")
    print(f"extension modules = {extension_count}")
    print("foreign GUI modules = none")
    print("HAITHON IMPORT SMOKE: PASS")


if __name__ == "__main__":
    main()
