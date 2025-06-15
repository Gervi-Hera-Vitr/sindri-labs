
import pygame

class Player:
    def __init__(self, x, y, speed=200, size=50, color=(0, 200, 255)):
        self.pos = pygame.Vector2(x, y)
        self.speed = speed
        self.size = size
        self.color = color
        self.direction = pygame.Vector2(0, 0)

    def handle_input(self):
        keys = pygame.key.get_pressed()
        self.direction = pygame.Vector2(0, 0)
        if keys[pygame.K_w]: self.direction.y -= 1
        if keys[pygame.K_s]: self.direction.y += 1
        if keys[pygame.K_a]: self.direction.x -= 1
        if keys[pygame.K_d]: self.direction.x += 1
        if self.direction.length() > 0:
            self.direction = self.direction.normalize()

    def update(self, dt):
        self.pos += self.direction * self.speed * dt

    def draw(self, surface):
        pygame.draw.rect(surface, self.color, (*self.pos, self.size, self.size))
