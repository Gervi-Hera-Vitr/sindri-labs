import pygame

# === Setup ===
pygame.init()
screen = pygame.display.set_mode((0, 0), pygame.FULLSCREEN)
clock = pygame.time.Clock()
running = True

# === Game State ===
show_start_screen = True
show_icons = show_return_button = show_shop = show_inventory = show_levels = show_adventure_Mode = False
xp = level = gold = 0

# === Utility Functions ===
def draw_text(surface, text, position, font_size=24, color=(255, 255, 255)):
    font = pygame.font.Font(None, font_size)
    surface.blit(font.render(text, True, color), position)

def resize_image(image, scale):
    w, h = image.get_width(), image.get_height()
    return pygame.transform.scale(image, (int(w * scale), int(h * scale)))

def button_click(rect, mouse_pos, clicked):
    return clicked and rect.collidepoint(mouse_pos)

def level_up(xp, level):
    return (xp - 100, level + 1) if xp >= 100 else (xp, level)

def load(path):
    try:
        return pygame.image.load(path)
    except Exception as e:
        print(f"Failed to load {path}: {e}")
        return pygame.Surface((50, 50))

# === Asset Loading ===
asset_path = "/home/captainl/IdeaProjects/Gervi-Héra-Vitr/sindri-labs/labs/001-python/Assets/"
load_asset = lambda name: load(f"{asset_path}{name}")

assets = {
    "play": load_asset("playbutton.png"),
    "shop": load_asset("shopicon.png"),
    "inventory": load_asset("inventoryIcon.png"),
    "levels": load_asset("levelsicon.png"),
    "return": load_asset("returnbutton.png"),
    "adventure": load_asset("AdventureMode.png"),
    "EasyMapButton": load_asset("EasyMapButton.png"),
    "MediumMapButton": load_asset("MediumMapButton.png"),
    "HardMapButton": load_asset("HardMapButton.png"),
    "InsaneMapButton": load_asset("InsaneMapButton.png"),
    "Logo": load_asset("Logo.png"),
    "ScoutIcon": load_asset("ScoutIcon.png"),
    "SniperIcon": load_asset("SniperIcon.png"),
    "ShotgunnerIcon": load_asset("ShotgunnerIcon.png"),
    "empty_slot": load_asset("empty_slot.png"),
    "RedXIcon": load_asset("RedXIcon.png"),
    "Barn": load_asset("Barn.png"),
    "Quick": load_asset("Quick.png"),
    "Zombie": load_asset("Zombie.png"),
    "ZombieBoss": load_asset("ZombieBoss.png"),
    "Tanky": load_asset("Tanky.png")
}

# === Classes ===
class Enemy:
    def __init__(self, x, y, image, health, speed, defense, boss):
        self.x, self.y = x, y
        self.image = image
        self.health, self.speed, self.defense, self.boss = health, speed, defense, boss

    def draw(self):
        screen.blit(self.image, (self.x, self.y))

class Tower:
    def __init__(self, x, y, image, upgrades, damage, range_, cost, upgrade_cost, name, unlocked=True, unlocking_cost=0):
        self.x, self.y = x, y
        self.image = image
        self.upgrades = upgrades
        self.damage, self.range = damage, range_
        self.cost, self.upgrade_cost = cost, upgrade_cost
        self.name, self.unlocked, self.unlocking_cost = name, unlocked, unlocking_cost

    def draw(self, pos):
        screen.blit(self.image, pos)

# === Towers ===
Scout = Tower(0, 0, assets["ScoutIcon"], 4, 1, 5, 50, 0, "Scout")
Sniper = Tower(0, 0, assets["SniperIcon"], 5, 7, 10, 100, 0, "Sniper")
Shotgunner = Tower(0, 0, assets["ShotgunnerIcon"], 5, 10, 2, 200, 0, "Shotgunner", unlocked=False, unlocking_cost=300)
Empty = Tower(0, 0, assets["empty_slot"], 0, 0, 0, 0, 0, "Empty")

Equipped_Towers = [Scout, Sniper, Empty, Empty, Empty]
shop = [Shotgunner]
Unlocked_Towers = []

# === Resized Assets and Buttons ===
def create_button(name, scale, topleft):
    img = resize_image(assets[name], scale)
    return img, img.get_rect(topleft=topleft)

resized, rects = {}, {}
buttons_info = {
    "play": (0.25, (760, 846)), "shop": (0.6, (50, 250)), "inventory": (0.6, (650, 250)),
    "levels": (0.6, (1250, 250)), "return": (0.1, (50, 50)), "adventure": (0.6, (300, 300)),
    "EasyMapButton": (0.2, (100, 400)), "MediumMapButton": (0.2, (500, 400)),
    "HardMapButton": (0.2, (900, 400)), "InsaneMapButton": (0.2, (1300, 400))
}

for name, (scale, pos) in buttons_info.items():
    resized[name], rects[name] = create_button(name, scale, pos)

pygame.mouse.set_cursor(*pygame.cursors.arrow)

# === UI State Drawing ===
def draw_icon_button(image, rect, toggle_flags, mouse_pos, click):
    screen.blit(image, rect.topleft)
    if button_click(rect, mouse_pos, click):
        for key, val in toggle_flags.items():
            globals()[key] = val
        return True
    return False

# === Main Loop ===
while running:
    mouse_pos = pygame.mouse.get_pos()
    click = False

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.MOUSEBUTTONDOWN and event.button == 1:
            click = True

    screen.fill((15, 14, 32))
    draw_text(screen, f"XP: {xp}", (1800, 50))
    draw_text(screen, f"Level: {level}", (1800, 80))
    draw_text(screen, f"Gold: {gold}", (1800, 110))

    if show_return_button and draw_icon_button(resized["return"], rects["return"], {
        "show_return_button": False, "show_shop": False, "show_inventory": False,
        "show_levels": False, "show_icons": True, "show_adventure_Mode": False
    }, mouse_pos, click):
        continue

    if show_start_screen:
        screen.blit(assets["Logo"], (0, 0))
        if draw_icon_button(resized["play"], rects["play"], {
            "show_start_screen": False, "show_icons": True, "show_adventure_Mode": False
        }, mouse_pos, click):
            continue

    if show_icons:
        draw_icon_button(resized["shop"], rects["shop"], {
            "show_icons": False, "show_return_button": True, "show_shop": True, "show_adventure_Mode": False
        }, mouse_pos, click)
        draw_icon_button(resized["inventory"], rects["inventory"], {
            "show_icons": False, "show_return_button": True, "show_inventory": True, "show_adventure_Mode": False
        }, mouse_pos, click)
        draw_icon_button(resized["levels"], rects["levels"], {
            "show_icons": False, "show_return_button": True, "show_levels": True, "show_adventure_Mode": False
        }, mouse_pos, click)

    if show_levels:
        screen.blit(resized["adventure"], rects["adventure"].topleft)
        if button_click(rects["adventure"], mouse_pos, click):
            show_adventure_Mode = True

    if show_adventure_Mode:
        for key in ["EasyMapButton", "MediumMapButton", "HardMapButton", "InsaneMapButton"]:
            screen.blit(resized[key], rects[key].topleft)

    pygame.display.flip()
    clock.tick(60)

pygame.quit()