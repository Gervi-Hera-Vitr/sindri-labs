import pygame
import sys
import Text
from Player import Player
from pygame import FULLSCREEN

# Initialize Pygame
pygame.init()
player = Player(0, 0)
# Set up screen
screen = pygame.display.set_mode((0,0), FULLSCREEN)

pygame.mouse.set_visible(True)

# Set up clock for delta time
clock = pygame.time.Clock()
def mouse_click(events):
    for event in events:
        if event.type == pygame.MOUSEBUTTONDOWN:
            return pygame.mouse.get_pos()
    return None

# Player setup
intro = Text.TextScroller(screen)
intro.start_game_text()
# Game loop
running = True
while running:
    dt = clock.tick(60) / 1000  # Delta time in seconds

    for event in pygame.event.get():
        if event.type == pygame.QUIT or (
                event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE):
            running = False

    player.handle_input()
    player.update(dt)

    screen.fill((30, 30, 30))
    player.draw(screen)
    pygame.display.flip()

# Clean up
pygame.quit()
sys.exit()
