import pygame

# Pygame setup
pygame.init()
screen = pygame.display.set_mode((0, 0), pygame.FULLSCREEN)
clock = pygame.time.Clock()
running = True

# Game state
show_start_screen = True
show_icons = False
show_return_button = False
# Load assets
scoutpngicon = pygame.image.load("Assets/scout.png")
sniperpngicon = pygame.image.load("/home/captainl/IdeaProjects/Gervi-Héra-Vitr/sindri-labs/labs/001-python/Assets/SniperIcon.png")
shotgunnerpngicon = pygame.image.load("/home/captainl/IdeaProjects/Gervi-Héra-Vitr/sindri-labs/labs/001-python/Assets/ShotgunnerIcon.png")
logo = pygame.image.load("Assets/logo.png")
play_button = pygame.image.load("Assets/playbutton.png")
shop_button = pygame.image.load("Assets/shopicon.png")
inventory_button = pygame.image.load("Assets/inventoryIcon.png")
levels_icon = pygame.image.load("Assets/levelsicon.png")
return_button = pygame.image.load("/home/captainl/IdeaProjects/Gervi-Héra-Vitr/sindri-labs/labs/001-python/Assets/returnbutton.png")
empty_slot = pygame.image.load("/home/captainl/IdeaProjects/Gervi-Héra-Vitr/sindri-labs/labs/001-python/Assets/empty_slot.png")

# Resize function
def resize_image(image, scale_percent):
    width = int(image.get_width() * scale_percent)
    height = int(image.get_height() * scale_percent)
    return pygame.transform.scale(image, (width, height))

# General button click detection
def button_click(rect, mouse_pos, clicked):
    return clicked and rect.collidepoint(mouse_pos)



# Tower class
class Tower:
    def __init__(self, x, y, image, upgrades, damage, range, cost, UpgradeCost, name):
        self.x = x
        self.y = y
        self.image = image
        self.upgrades = upgrades
        self.damage = damage
        self.range = range
        self.cost = cost
        self.UpgradeCost = UpgradeCost

    def draw(self):
        screen.blit(self.image, (mouse_pos[0], mouse_pos[1]))

Scout = Tower(0, 0, scoutpngicon, 4, 1, 5, 50, 0,"Scout")
Sniper = Tower(0, 0, sniperpngicon, 5, 7, 10, 100, 0,"Sniper")
shotgunner = Tower(0, 0, shotgunnerpngicon, 5, 10, 2, 200, 0,"Shotgunner")

Equipped_Towers = [Scout,Sniper]

# Resize images
play_button_resized = resize_image(play_button, 0.25)
shop_button_resized = resize_image(shop_button, 0.6)
inventory_button_resized = resize_image(inventory_button, 0.6)
levels_icon_resized = resize_image(levels_icon, 0.6)
return_button_resized = resize_image(return_button, 0.1)

# Button rects
play_button_rect = play_button_resized.get_rect(topleft=(800, 846))
shop_button_rect = shop_button_resized.get_rect(topleft=(50, 250))
inventory_button_rect = inventory_button_resized.get_rect(topleft=(650, 250))
levels_icon_rect = levels_icon_resized.get_rect(topleft=(1250, 250))
return_button_rect = return_button_resized.get_rect(topleft=(50, 50))

# Main loop
while running:
    mouse_pos = pygame.mouse.get_pos()
    click = False

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
            click = True

    screen.fill((15, 14, 32))  # background color
    pygame.mouse.set_cursor(*pygame.cursors.arrow)
    # Return button
    if show_return_button:
        screen.blit(return_button_resized, return_button_rect.topleft)
        if button_click(return_button_rect, mouse_pos, click):
            print("Return button clicked!")
            show_return_button = False
            show_start_screen = False
            show_icons = True
    # Start screen
    if show_start_screen:
        screen.blit(logo, (410, 100))
        screen.blit(play_button_resized, play_button_rect.topleft)

        if button_click(play_button_rect, mouse_pos, click):
            print("Play button clicked!")
            show_start_screen = False
            show_icons = True

    # Lobby buttons
    if show_icons:
        screen.blit(shop_button_resized, shop_button_rect.topleft)
        screen.blit(inventory_button_resized, inventory_button_rect.topleft)
        screen.blit(levels_icon_resized, levels_icon_rect.topleft)


        if button_click(shop_button_rect, mouse_pos, click):
            print("Shop button clicked!")
            show_icons = False
            show_return_button = True
        if button_click(inventory_button_rect, mouse_pos, click):
            print("Inventory button clicked!")
            show_icons = False
            show_return_button = True
        if button_click(levels_icon_rect, mouse_pos, click):
            print("Levels button clicked!")
            show_icons = False
            show_return_button = True
    pygame.display.flip()
    clock.tick(60)

pygame.quit()
