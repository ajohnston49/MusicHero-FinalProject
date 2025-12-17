import pygame
import tkinter as tk
from tkinter import filedialog
import time, json, os

notes = []
start_time = None
song_loaded = False
song_path = None
active_holds = {}  # track when each lane key was pressed

# --- GUI setup ---
root = tk.Tk()
root.title("🎵 Music Hero Track Maker V.1 - Alex Johnston")
root.geometry("575x400")
root.configure(bg="#2c2f33")  # dark background

# --- Styling ---
btn_style = {
    "font": ("Arial", 12, "bold"),
    "bg": "#7289da",
    "fg": "white",
    "activebackground": "#99aab5",
    "activeforeground": "black",
    "relief": "raised",
    "bd": 3,
    "width": 15,
    "height": 2
}

log_frame = tk.Frame(root, bg="#2c2f33")
log_frame.pack(pady=10)

log_label = tk.Label(log_frame, text="Event Log", font=("Arial", 12, "bold"), fg="white", bg="#2c2f33")
log_label.pack()

log_box = tk.Listbox(log_frame, width=60, height=15, bg="#23272a", fg="#ffffff", font=("Consolas", 10))
log_box.pack(pady=5)

def log(msg):
    log_box.insert(tk.END, msg)
    log_box.yview(tk.END)  # auto-scroll

# --- Functions ---
def load_song():
    global song_loaded, song_path
    file_path = filedialog.askopenfilename(filetypes=[("Audio Files", "*.mp3 *.ogg *.wav")])
    if file_path:
        pygame.mixer.music.load(file_path)
        song_loaded = True
        song_path = file_path
        log(f"✅ Loaded: {file_path}")

def play_song():
    global start_time
    if song_loaded:
        pygame.mixer.music.play()
        start_time = time.time()
        log("▶️ Playing song... Tap or hold 1–4 to record notes.")

def save_chart():
    if notes and song_path:
        base, _ = os.path.splitext(song_path)
        json_path = base + ".json"
        with open(json_path, "w") as f:
            json.dump(notes, f, indent=2)
        log(f"💾 Saved {json_path} with {len(notes)} notes")
    else:
        log("⚠️ No notes recorded or no song loaded!")

# --- Buttons ---
btn_frame = tk.Frame(root, bg="#2c2f33")
btn_frame.pack(pady=15)

tk.Button(btn_frame, text="Load Song", command=load_song, **btn_style).grid(row=0, column=0, padx=10, pady=5)
tk.Button(btn_frame, text="Play Song", command=play_song, **btn_style).grid(row=0, column=1, padx=10, pady=5)
tk.Button(btn_frame, text="Save Chart", command=save_chart, **btn_style).grid(row=0, column=2, padx=10, pady=5)

# --- Pygame setup ---
pygame.mixer.init()

# --- Key bindings (Tkinter captures keys directly) ---
def key_press(event):
    global active_holds
    if event.char in ['1','2','3','4'] and start_time:
        lane = int(event.char)
        if lane not in active_holds:
            ms = int((time.time() - start_time) * 1000)
            active_holds[lane] = ms
            log(f"⬇️ Lane {lane} pressed at {ms}ms")

def key_release(event):
    global active_holds
    if event.char in ['1','2','3','4'] and start_time:
        lane = int(event.char)
        if lane in active_holds:
            start_ms = active_holds[lane]
            end_ms = int((time.time() - start_time) * 1000)
            duration = end_ms - start_ms
            notes.append({"time": start_ms, "lane": lane, "duration": duration})
            log(f"⬆️ Lane {lane} released at {end_ms}ms (duration {duration}ms)")
            del active_holds[lane]

root.bind("<KeyPress>", key_press)
root.bind("<KeyRelease>", key_release)

root.mainloop()
