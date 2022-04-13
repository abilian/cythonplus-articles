# golomb sequence
# cythonplus multicore, implementation with actors

from libcythonplus.dict cimport cypdict
from .scheduler.scheduler cimport SequentialMailBox, NullResult, Scheduler


cdef cypclass Golomb activable:
    int rank
    active Recorder recorder

    __init__(self,
             lock Scheduler scheduler,
             active Recorder recorder,
             int rank):
        self._active_result_class = NullResult
        self._active_queue_class = consume SequentialMailBox(scheduler)
        self.rank = rank
        self.recorder = recorder

    int gpos(self, int n):
        """Return the value of position n of the Golomb sequence (recursive function).
        """
        if n == 1:
            return 1
        return self.gpos(n - self.gpos(self.gpos(n - 1))) + 1

    void run(self):
        cdef int value

        value = self.gpos(self.rank)
        self.recorder.store(NULL, self.rank, value)


cdef cypclass Recorder activable:
    cypdict[int, int] storage

    __init__(self, lock Scheduler scheduler):
        self._active_result_class = NullResult
        self._active_queue_class = consume SequentialMailBox(scheduler)
        self.storage = cypdict[int, int]()

    void store(self, int key, int value):
        self.storage[key] = value

    cypdict[int, int] content(self):
        return self.storage


cdef cypclass GolombGenerator activable:
    int size
    lock Scheduler scheduler
    active Recorder recorder

    __init__(self, lock Scheduler scheduler, int size):
        self._active_result_class = NullResult
        self._active_queue_class = consume SequentialMailBox(scheduler)
        self.scheduler = scheduler  # keep it for use with sub objects
        self.size = size
        self.recorder = activate (consume Recorder(scheduler))

    void run(self):
        # reverse order of loop for small calculation optimization:
        for rank in range(self.size, 0, -1):
            golomb = <active Golomb> activate(consume Golomb(self.scheduler,
                                                             self.recorder,
                                                             rank))
            golomb.run(NULL)

    cypdict[int, int] results(self):
        recorder = consume self.recorder
        return <cypdict[int, int]> recorder.content()


cdef cypdict[int, int] golomb_sequence(int size) nogil:
    cdef active GolombGenerator generator
    cdef lock Scheduler scheduler

    scheduler = Scheduler()
    generator = activate(consume GolombGenerator(scheduler, size))
    generator.run(NULL)
    scheduler.finish()
    del scheduler
    generator_object = consume(generator)
    return <cypdict[int, int]> generator_object.results()


cdef list golomb_sequence_as_python_list(int size):
    cdef cypdict[int, int] results

    with nogil:
        results = golomb_sequence(size)

    sequence = [item[1] for item in
                    sorted((i, results[i]) for i in range(1, size + 1))
               ]
    return sequence


def main(size=None):
    if not size:
        size = 50
    sequence = golomb_sequence_as_python_list(int(size))
    print(f"length of sequence: {len(sequence)}, last element: {sequence[-1]}")
