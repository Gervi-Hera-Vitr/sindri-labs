package ux.virt.lugaru.me.plugins

import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import kotlinx.serialization.json.Json

/**
 * Configures the serialization module.
 *
 * This function installs the ContentNegotiation plugin with JSON support.
 * The JSON configuration is set to pretty print and be lenient in parsing.
 *
 * It also sets up a route to respond with a JSON object at the "/json-ml" endpoint.
 */
fun Application.configureSerialization() {
    install(ContentNegotiation) {
        json(Json{
            prettyPrint = true
            isLenient = true
        })
    }
    routing {
        get("/json-ml") { call.respond(mapOf("hello" to "json ML")) }
    }
}
