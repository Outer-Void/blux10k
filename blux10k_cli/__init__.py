"""blux10k: environment and toolchain authority for Outer Void (Stage 18).

Read-only by default. It detects the host (OS, architecture, libc, Termux, PRoot, containers), inventories
toolchains (Python, Node, JDK, Gradle, Android SDK and more), checks them and reports. Nothing in the
environment changes unless `bootstrap --apply` is given explicitly, and even then it only runs this
repository's own documented scripts.
"""

__version__ = "3.0.0"
