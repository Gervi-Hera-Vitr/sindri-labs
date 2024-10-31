package ux.virt.lugaru.me.plugins

import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.testing.*
import ux.virt.lugaru.me.module
import kotlin.test.Test
import kotlin.test.assertEquals


class TemplatingTest {

    /**
     * Verifies that a GET request to "/html-thymeleaf" will respond with the expected HTML page.
     *
     * Asserts that the route "/html-thymeleaf" responds with an HTML page containing the text "user1".
     */
    @Test
    fun testTemplatedContentServing() = testApplication {
        application(Application::module)

        client.get("/html-thymeleaf").apply {
            assertEquals(HttpStatusCode.OK, status)
            assertEquals("""
                <!DOCTYPE html >
                <html>
                <head>
                    <meta charset="UTF-8">
                    <title>Title</title>
                </head>
                <body>
                <span>user1</span>
                </body>
                </html>
                

            """.trimIndent(), bodyAsText())
        }
    }
}
