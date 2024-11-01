package ux.virt.lugaru.me.plugins

import io.ktor.client.request.*
import io.ktor.client.statement.*
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.testing.*
import ux.virt.lugaru.me.module
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class StaticTest {
    /**
     * Verify that a GET request to "/static/" will return a 200-status code
     * and a response body that contains the expected HTML content.
     *
     * Asserts that the content at the static route "/static/" responds with a
     * HTML document containing the title "Brick" and a single H1 header with
     * the text "ML Rocks and Python Rolls!"
     */
    @Test
    fun testStaticContentServing() = testApplication {
        application(Application::module)

        client.get("/static/").apply {
            assertEquals(HttpStatusCode.OK, status)
            with(bodyAsText()) {
                assertTrue(contains("<body><h1>ML Rocks and Python Rolls!</h1></body>"))
                assertTrue(contains("<head><title>Brick</title></head>"))
            }
        }
    }
}