package ux.virt.lugaru.me.plugins;

import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.testing.*
import ux.virt.lugaru.me.module
import kotlin.test.Test
import kotlin.test.assertEquals


class TemplatingTest {

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
