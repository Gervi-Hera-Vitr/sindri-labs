package ux.virt.lugaru.me.plugins

import io.ktor.server.application.*
import io.ktor.server.plugins.defaultheaders.*

/**
 * Configures the HTTP module.
 *
 * This function sets up the HTTP server with default headers.
 * The header "X-Engine" is set to "Ktor" to indicate that the request was served by the
 * Ktor framework.
 */
fun Application.configureHTTP() {
    install(DefaultHeaders) {
        header("X-Engine", "Ktor") // will send this header with each response
    }
}
