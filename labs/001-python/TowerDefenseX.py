import pygame
from PIL.ImageQt import rgb

# pygame setup
pygame.init()
screen = pygame.display.set_mode((0, 0), pygame.FULLSCREEN)
clock = pygame.time.Clock()
running = True

# Load assets
logo = pygame.image.load("/home/captainl/IdeaProjects/Gervi-Héra-Vitr/sindri-labs/labs/001-python/Assets/logo.png")
playbutton = pygame.image.load("/home/captainl/IdeaProjects/Gervi-Héra-Vitr/sindri-labs/labs/001-python/Assets/playbutton.png")

# Resize play button
new_width = playbutton.get_width() // 4
new_height = playbutton.get_height() // 4
playbutton_resized = pygame.transform.scale(playbutton, (new_width, new_height))

# Get play button rect (for click detection)
playbutton_rect = playbutton_resized.get_rect(topleft=(383, 746))

while running:
    mouse_pos = pygame.mouse.get_pos()
    click = False

    # Event polling
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.MOUSEBUTTONDOWN:
            if event.button == 1:  # Left click
                click = True

    # Fill background
    screen.fill((10, 80, 80))

    # Draw elements
    pygame.mouse.set_cursor(*pygame.cursors.arrow)
    screen.blit(logo, (0, 0))
    screen.blit(playbutton_resized, playbutton_rect.topleft)

    # Check if clicked
    if click and playbutton_rect.collidepoint(mouse_pos):
        print("Play button clicked!")

    # Update display
    pygame.display.flip()
    clock.tick(60)

pygame.quit()
