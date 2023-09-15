from glapp.pyoglapp import *
from glapp.utils import *
from glapp.gameobjects.mesh import *
from OpenGL.GL import *

class ShaderToyPort(PyOGLApp):
    def __init__(self, width, height, frag_name):
        super().__init__(width, height, 720, 480)
        self.screen_plane = None
        self.frag_name = frag_name
        
    def initialise(self):
        self.program_id = create_program(open("shaders/vert.glsl", 'r').read(), open(f"shaders/frag_{self.frag_name}.glsl", 'r').read())
        self.screen_plane = Mesh(self.program_id)

    def display(self, speed):
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        glUseProgram(self.program_id)
        res_id = glGetUniformLocation(self.program_id, "iResolution")
        glUniform2f(res_id, self.screen_width, self.screen_height)
        self.screen_plane.draw(speed)



if __name__ == "__main__":
    pygame.init()
    width, height = 720, 480
    pygame.display.set_mode((width, height), pygame.RESIZABLE | pygame.DOUBLEBUF|pygame.OPENGL|pygame.HWSURFACE)
    

    glViewport(0, 0, width, height)
    
    ShaderToyPort(width, height, "incriter").mainloop()
