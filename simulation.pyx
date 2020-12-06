import timeit
import sdl2
import sdl2.ext

cdef class Simulation:
    """This is here it all begin, it control everything"""
    # private
    cdef long fps, running, quit, generation
    cdef float timer, old_timer

    # public & readonly
    cdef public object window

    def __init__(self):
        # General variables
        self.fps = 30
        self.timer = timeit.default_timer()
        self.running = 1
        self.quit = 0
        self.generation = 0
        self.window = None

        # Simulation variable

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
        sdl2.ext.init()
        self.window = sdl2.ext.Window("Hello World!", size=(640, 480))
        self.window.show()
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
        self.window.refresh()

    def end(self):
        # TODO make a new batch of car
        # TODO set runnng to 1
        pass

    def leave(self):
        print("Goodbye !")
        sdl2.ext.quit()