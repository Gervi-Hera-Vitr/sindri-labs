package ux.virt.lugaru.me.plugins

import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.server.thymeleaf.Thymeleaf
import io.ktor.server.thymeleaf.ThymeleafContent
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver

/**
 * Configures the templating module.
 *
 * This function sets up the Thymeleaf template engine.
 * It configures the template resolver to look for templates in the "templates/thymeleaf/" directory
 * with a ".html" suffix.
 * It installs the Thymeleaf plugin and sets up a route for "/html-thymeleaf" that renders the "index"
 * template with a "user" variable set to a [ThymeleafUser] instance.
 */
fun Application.configureTemplating() {
    install(Thymeleaf) {
        setTemplateResolver(ClassLoaderTemplateResolver().apply {
            prefix = "templates/thymeleaf/"
            suffix = ".html"
            characterEncoding = "utf-8"
        })
    }
    routing {
        get("/html-thymeleaf") {
            call.respond(ThymeleafContent("index", mapOf("user" to ThymeleafUser(1, "user1"))))
        }
    }
}

data class ThymeleafUser(val id: Int, val name: String)
