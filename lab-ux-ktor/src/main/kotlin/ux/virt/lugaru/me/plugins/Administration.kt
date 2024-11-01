package ux.virt.lugaru.me.plugins

import io.ktor.server.application.*
import io.ktor.server.engine.*

/**
 * Configures the administration module.
 *
 * This function sets up the HTTP endpoint for the shut-down API.
 *
 * The shut-down API is a special endpoint that can be used to shut down the
 * application.
 * It is useful when Ktor is started as a foreground process
 * and the user wants to shut it down gracefully.
 *
 * The shut-down API is configured in the `application.conf` file as follows:
 *
 **/
fun Application.configureAdministration() {
    install(ShutDownUrl.ApplicationCallPlugin) {
        // The URL that will be intercepted (you can also use the application.config's ktor.deployment.shutdown.url key)
        shutDownUrl = "/ktor/application/shutdown"
        // A function that will be executed to get the exit code of the process
        exitCodeSupplier = { 0 } // ApplicationCall.() -> Int
    }
}
