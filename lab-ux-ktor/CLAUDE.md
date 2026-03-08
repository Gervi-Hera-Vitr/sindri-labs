# Lab UX Ktor -- Web Application Lab

Kotlin/Ktor web application. Anton's hands-on web development lab.

## Build & Run

```bash
gradle :lab-ux-ktor:build
gradle :lab-ux-ktor:run          # Starts CIO server
gradle :lab-ux-ktor:test         # Runs Ktor test host
```

Main class: `ux.virt.lugaru.me.ApplicationKt`

## Stack

- **Ktor** with CIO engine
- **Thymeleaf** templating
- **kotlinx.serialization** for JSON
- Server features: auto-head-response, status-pages, default-headers, call-logging, content-negotiation

## Dependencies

All managed via `libs.versions.toml`. Dependency constraints enforce versions for httpcore, kotlinx-io-core, kotlinx-serialization-core, and
jetbrains-annotations.

Uses Ktor BOM and Kotlin BOM for transitive version alignment.

## Notes

This is a learning lab, not a production application. The Ktor setup serves as Anton's introduction to server-side Kotlin development.
