package ux.virt.lugaru.me.plugins

import io.ktor.server.application.*
import io.ktor.server.plugins.calllogging.*
import io.ktor.server.request.*
import org.slf4j.event.Level

/**
 * Configures the monitoring module.
 *
 * This function sets up the CallLogging plugin to log all incoming requests at the INFO level.
 * The filter is set to only log requests that have a path that starts with "/".
 */
fun Application.configureMonitoring() {
    install(CallLogging) {
        level = Level.INFO
        filter { call -> call.request.path().startsWith("/") }
    }
}
