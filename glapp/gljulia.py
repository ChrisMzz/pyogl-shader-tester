import os
from OpenGL.GL import *
import pygame
from pygame.locals import *


# from https://gist.github.com/NickBeeuwsaert/fec10bd5d63b618e9432
    
    

class PyOGLApp():
    def __init__(self, screen_posX, screen_posY, screen_width, screen_height):
        os.environ['SDL_VIDEO_WINDOW_POS'] = "%d, %d" % (screen_posX, screen_posY)
        self.screen_width = screen_width
        self.screen_height = screen_height
        pygame.init()
        pygame.display.gl_set_attribute(pygame.GL_MULTISAMPLEBUFFERS, 1)
        pygame.display.gl_set_attribute(pygame.GL_MULTISAMPLESAMPLES, 4)
        pygame.display.gl_set_attribute(pygame.GL_CONTEXT_PROFILE_MASK, pygame.GL_CONTEXT_PROFILE_CORE)
        pygame.display.gl_set_attribute(pygame.GL_DEPTH_SIZE, 32)
        self.screen = pygame.display.set_mode((screen_width, screen_height), pygame.DOUBLEBUF|pygame.OPENGL|pygame.HWSURFACE)
        pygame.display.set_caption("Shadertoy testing")
        self.program_id = None
        self.clock = pygame.time.Clock()
        

    def manage_events(self, states):
        running = states["running"]
        paused = states["paused"]
        speed = states["speed"]
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            if event.type == pygame.KEYDOWN and event.key == pygame.K_F11:
                # Toggle fullscreen mode
                pygame.display.toggle_fullscreen()
            if event.type == pygame.KEYDOWN and event.key == pygame.K_p:
                paused = bool(1-paused)
            if event.type == pygame.KEYDOWN: # arrow keys
                if event.key == pygame.K_RIGHT:
                    speed = 5
                elif event.key == pygame.K_LEFT:
                    speed = 0.2
                else:
                    speed = 1
        return {"running":running, "paused":paused, "speed":speed}
        
    def mainloop(self):
        states = {
            "running":True,
            "paused":False,
            "speed":1
        }
        running = states["running"]
        paused = states["paused"]
        time_paused = 0
        self.initialise()
        while running:
            ticks = pygame.time.get_ticks() * 0.002 - time_paused
            states = self.manage_events(states)
            running = states["running"]
            paused = states["paused"]
            speed = states["speed"]
            ticks *= speed
            while paused:
                states = self.manage_events(states)
                running = states["running"]
                paused = states["paused"]
                self.display(ticks)
                pygame.display.flip()
                if not paused:
                    time_paused = (pygame.time.get_ticks()*0.002 - ticks)
            self.display(ticks)
            pygame.display.flip()
            self.clock.tick(60)
        pygame.quit()




def draw(program_id):
    timer_id = glGetUniformLocation(program_id, "iTime")
    glUniform1f(timer_id, pygame.time.get_ticks()*0.1)
    



if __name__ == "__main__":
    width, height = 800, 600
    pygame.init()
    pygame.display.set_mode((width, height), pygame.RESIZABLE | pygame.DOUBLEBUF|pygame.OPENGL|pygame.HWSURFACE)
    

    glViewport(0, 0, width, height)
    
    shader = glCreateShader(GL_VERTEX_SHADER)
    info_log = glGetShaderInfoLog(shader)

    print(info_log)


    program = glCreateProgram()
    
    glAttachShader(program, shader)
    
    glLinkProgram(program)
    
    glUseProgram(program)
    
    running = True
    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            if event.type == pygame.KEYDOWN and event.key == pygame.K_F11:
                # Toggle fullscreen mode
                pygame.display.toggle_fullscreen()
            pygame.display.flip()
        pygame.quit()
        

