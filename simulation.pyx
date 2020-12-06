import timeit
import sdl2
import sdl2.ext

cdef class Simulation:
    """This is here it all begin, it control everything"""
    # Globals

    # private
    cdef long fps, running, quit, generation
    cdef float timer, old_timer

    # public & readonly
    cdef public object window, surface, renderer
    cdef readonly RESET_TIMER, NUM_CAR, LEARNING_RATE, LEARNING_RATE_DEC, LEARNING_RATE_MIN

    def __init__(self):
        # General variables
        self.fps = 30
        self.timer = timeit.default_timer()
        self.running = 1
        self.quit = 0
        self.generation = 0
        self.window = None
        self.surface = None
        self.renderer = None

        # Simulation variable
        self.RESET_TIMER = 20000  # reset the track after n ms
        self.NUM_CAR = 100  # how many car to spawn
        self.LEARNING_RATE = 0.1
        self.LEARNING_RATE_DEC = 0.001
        self.LEARNING_RATE_MIN = 0.05


        # CODE
        # from main -> simulation.__init__ -> setup() -> (loop() until quit == 1) -----------------------------> leave()
        #                                                   |
        #                                                   |-> start() -> (inner_loop) ----------------> end()
        #                                                        |             \-> update() -> render()   /
        #                                                        |                   \<---------/        /
        #                                                        |<-------------------------------------/
        self.setup()
        self.loop()     # <- loop forever until quit == 1
        self.leave()

    def setup(self):
        """Only called once"""
        # SDL initialization
        sdl2.SDL_Init(sdl2.SDL_INIT_VIDEO | sdl2.SDL_INIT_EVENTS)
        self.window = sdl2.SDL_CreateWindow(b"Deep Learning Car 2", sdl2.SDL_WINDOWPOS_CENTERED,
                                            sdl2.SDL_WINDOWPOS_CENTERED, 800, 600, sdl2.SDL_WINDOW_SHOWN)
        self.surface = sdl2.SDL_GetWindowSurface(self.window)
        self.renderer = sdl2.SDL_CreateRenderer(self.window, -1, sdl2.SDL_RENDERER_ACCELERATED)

        # TODO : Generate first clean batch of car

    def loop(self):
        while not self.quit:        # loop over multiple generation, leave the program if quit == 1
            self.start()
            while self.running:     # inner loop inside a generation
                self.update()
                if timeit.default_timer() - self.timer > 1 / self.fps:
                    self.render()
                    self.timer = timeit.default_timer()
            self.end()
        # back to __init__, it call self.leave() and the program exit

    def start(self):
        self.generation += 1
        print("Starting generation : ", self.generation)
        # TODO : generateTrack()
        # TODO : start cars

    def update(self):
        # process SDL event
        events = sdl2.ext.get_events()
        for event in events:
            if event.type == sdl2.SDL_QUIT:
                self.running = 0
                self.quit = 1
                break

        # TODO : update cars
        # TODO : check if we keep running or if we end this generation
        #  (set running = 0, the loop will call end() itself)

    def render(self):
        sdl2.SDL_SetRenderDrawColor(self.renderer, 0, 100, 0, 255)
        sdl2.SDL_RenderClear(self.renderer)
        sdl2.SDL_RenderPresent(self.renderer)

    def end(self):
        # TODO make a new batch of car
        # TODO set running to 1
        pass

    def leave(self):
        print("Goodbye !")
        sdl2.SDL_DestroyWindow(self.window)
        sdl2.SDL_Quit()