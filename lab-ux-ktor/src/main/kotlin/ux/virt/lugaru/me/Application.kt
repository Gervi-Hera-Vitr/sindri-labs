package ux.virt.lugaru.me

import io.ktor.server.application.*
import io.ktor.server.cio.*
import io.ktor.server.engine.*
import ux.virt.lugaru.me.plugins.*

/**
 * The main entry point of the application.
 *
 * This function starts an embedded HTTP server at
 * [host = "0.0.0.0"][port = 8080] that serves the application.
 *
 * The server is configured using the [module] function.
 *
 * The server is started with [EmbeddedServer.start] and is configured
 * to wait until the server is stopped before exiting.
 *
 * This function is the entry point of the application and should be
 * invoked when running the application.
 */
fun main() {
    embeddedServer(CIO, port = 8080, host = "0.0.0.0", module = Application::module)
        .start(wait = true)
}

/**
 * Configures the application's modules and plugins.
 *
 * This function sets up the application's HTTP settings, monitoring,
 * serialization, templating, administration, and routing.
 * It installs
 * and configures each module to ensure the application is properly
 * initialized and ready to handle requests.
 */
fun Application.module() {
    configureHTTP()
    configureMonitoring()
    configureSerialization()
    configureTemplating()
    configureAdministration()
    configureRouting()
}

const val greeting =" Hello Amazing Lepus Models!"