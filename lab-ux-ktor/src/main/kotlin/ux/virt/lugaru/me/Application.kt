package ux.virt.lugaru.me

import io.ktor.server.application.*
import io.ktor.server.cio.*
import io.ktor.server.engine.*
import ux.virt.lugaru.me.plugins.*

fun main() {
    embeddedServer(CIO, port = 8080, host = "0.0.0.0", module = Application::module)
        .start(wait = true)
}

fun Application.module() {
    configureHTTP()
    configureMonitoring()
    configureSerialization()
    configureTemplating()
    configureAdministration()
    configureRouting()
}

const val greeting =" Hello Amazing Lepus Models!"