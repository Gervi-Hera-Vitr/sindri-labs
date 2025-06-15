import pygame
import sys


class TextScroller:
    def __init__(self, screen, font_size=36, color=(0, 200, 255), scrawl_speed=3000):
        self.screen = screen
        self.font_size = font_size
        self.color = color
        self.scrawl_speed = scrawl_speed
        self.font = pygame.font.SysFont("consolas", font_size, bold=True)
        self.screen_width, self.screen_height = self.screen.get_size()

    def start_game_text(self):
        intro_text = (
            "Year: 2198\n"
            "Location: North Carolina, Blue Ridge Mountains aka Vault 173.\n"
            "Mission: Find the V.T.R.K (Vault-Tec Repair Kit)\n"
            "and use it to repair the hydroponics systems to save the vault.\n"
            "Time left: 2 years"
        )

        lines = intro_text.split("\n")
        rendered_lines = [self.font.render(line, True, self.color) for line in lines]

        line_spacing = self.font_size + 10
        start_y = self.screen_height // 3
        current_line = 0
        last_time = pygame.time.get_ticks()

        clock = pygame.time.Clock()
        running = True
        fade_triggered = False
        fade_alpha = 0

        # Create fade surface
        fade_surface = pygame.Surface((self.screen_width, self.screen_height))
        fade_surface.fill((0, 0, 0))

        while running:
            dt = clock.tick(60)
            for event in pygame.event.get():
                if event.type == pygame.QUIT or (
                    event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE):
                    running = False

            self.screen.fill((0, 0, 0))

            now = pygame.time.get_ticks()
            if current_line < len(rendered_lines):
                if now - last_time > self.scrawl_speed:
                    current_line += 1
                    last_time = now
            elif not fade_triggered:
                # Wait 2 seconds then begin fade-out
                pygame.time.delay(2000)
                fade_triggered = True

            # Draw revealed lines
            for i in range(min(current_line, len(rendered_lines))):
                text_surface = rendered_lines[i]
                x = (self.screen_width - text_surface.get_width()) // 2
                y = start_y + i * line_spacing
                self.screen.blit(text_surface, (x, y))

            # Fade out
            if fade_triggered:
                fade_alpha += 5  # adjust for slower/faster fade
                if fade_alpha >= 255:
                    fade_alpha = 255
                    running = False
                fade_surface.set_alpha(fade_alpha)
                self.screen.blit(fade_surface, (0, 0))

            pygame.display.flip()

        return

