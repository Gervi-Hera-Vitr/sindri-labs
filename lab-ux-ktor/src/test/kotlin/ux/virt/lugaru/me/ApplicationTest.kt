package ux.virt.lugaru.me

import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.testing.*
import ux.virt.lugaru.me.plugins.configureRouting
import kotlin.test.Test
import kotlin.test.assertEquals

class ApplicationTest {
    @Test
    fun testRoot() = testApplication {
        application(Application::configureRouting)

        client.get("/").apply {
            assertEquals(HttpStatusCode.OK, status)
            assertEquals(greeting, bodyAsText())
        }
    }
}
