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