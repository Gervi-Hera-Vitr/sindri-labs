package ux.virt.lugaru.me.plugins

import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.http.content.*
import io.ktor.server.plugins.autohead.*
import io.ktor.server.plugins.statuspages.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import ux.virt.lugaru.me.greeting

/**
 * Configures the routing module.
 *
 * This function sets up the routing of the application, including its error handling and the default route.
 *
 * The default route responds with a "Hello Amazing Lepus Models!" message.
 *
 * The error handling is set up to respond with a "500" message when a [Throwable] is thrown from a route.
 *
 * The static plugin is installed to serve static content from the "static" directory.
 *
 * This function is invoked by the Application module function.
 */
fun Application.configureRouting() {
    install(AutoHeadResponse)
    install(StatusPages) {
        exception<Throwable> { call, cause ->
            call.respondText(text = "500: $cause", status = HttpStatusCode.InternalServerError)
        }
    }
    routing {
        get("/") {
            call.respondText(greeting)
        }
        // Static plugin. Try to access `/static/index.html`
        staticResources("/static", "static")
    }
}
