

# import time module, Observer, FileSystemEventHandler
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from ConfigLoaders import load_profiles_dict, load_exports_dict
from Bundler import modify_lua_ast
from threading import Timer, Lock

def load_tmw_cache():
    try:
        with open("./cache/tmwloc.txt", 'r') as f:
            return f.read()
    except:
        return None

def get_tmw_path():
    tmw_cache = load_tmw_cache()
    if tmw_cache is not None:
        return tmw_cache

    print("Please enter the path to your TellMeWhen location:")
    tmw_path = input()
    with open("./cache/tmwloc.txt", 'w+') as f:
        f.write(tmw_path)

    return tmw_path

DebounceLock = Lock()

def debounce(wait):
    """ Decorator that will postpone a functions
        execution until after wait seconds
        have elapsed since the last time it was invoked. """
    def decorator(fn):
        def debounced(*args, **kwargs):
            def call_it():
                if DebounceLock.locked():
                    print('Debounce locked!')

                DebounceLock.acquire()
                fn(*args, **kwargs)
                DebounceLock.release()
            try:
                if debounced.t.finished.is_set():
                    try:
                        if not debounced.two.finished.is_set():
                            debounced.t = debounced.two

                            debounced.two = Timer(wait, call_it)
                            debounced.two.start()
                            return
                    except(AttributeError):
                        pass

                    # print('Recreating debounce t')
                    debounced.t = Timer(0.5, call_it)
                    debounced.t.start()
                else:
                    try:
                        if not DebounceLock.locked():
                            return
                        debounced.two.cancel()
                    except(AttributeError):
                        pass
                    
                    debounced.two = Timer(wait, call_it)
                    debounced.two.start()
            except(AttributeError):
                debounced.t = Timer(0.5, call_it)
                debounced.t.start()
            
        return debounced
    return decorator
 
class OnMyWatch:
    # Set the directory on watch
    watchDirectory = "../"
 
    def __init__(self):
        self.observer = Observer()
 
    def run(self):
        event_handler = Handler()
        self.observer.schedule(event_handler, self.watchDirectory, recursive = True)
        self.observer.start()
        try:
            while True:
                time.sleep(5)
        except:
            self.observer.stop()
            print("Observer Stopped")
 
        self.observer.join()
 
@debounce(1)
def rebuild_makulu():
    print("Rebuilding Makulu...")
    print('Building ...', end=' ')

    profiles = load_profiles_dict()
    exports = {
        "AIO": {
            "name": "AIO",
            "profiles": list(profiles.keys())
        }
    }
    profile_start_time = time.time()
    modified_lua_code = modify_lua_ast(exports["AIO"], profiles)
    with open(get_tmw_path(), 'w+') as f:
        print('Creating ast took: %.2f ms' % ((time.time() - profile_start_time) * 1000), end='')
        f.write(modified_lua_code)
        print(". Overall time: %.2f ms" % ((time.time() - profile_start_time) * 1000))
    

class Handler(FileSystemEventHandler):
 
    @staticmethod
    def on_any_event(event):
        if event.is_directory:
            return None
 
        if event.event_type == 'modified':
            # Event is modified, you can process it now
            if event.src_path.endswith(".lua") and not "/AutoBundle/" in event.src_path:
                rebuild_makulu()
 
if __name__ == '__main__':
    tmw_path = get_tmw_path()
    watch = OnMyWatch()
    watch.run()