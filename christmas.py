from flask import Flask, send_file
from pydub import AudioSegment
from pydub.generators import Sine
import os

app = Flask(__name__)

NOTES = {
    "C4": 261, "D4": 294, "E4": 329, "F4": 349,
    "G4": 392, "A4": 440, "B4": 493, "C5": 523,
    "D5": 587, "E5": 659
}

jingle_bells = [
    ("E4", 400), ("E4", 400), ("E4", 800),
    ("E4", 400), ("E4", 400), ("E4", 800),
    ("E4", 400), ("G4", 400), ("C4", 400), ("D4", 400), ("E4", 1600),
    ("F4", 400), ("F4", 400), ("F4", 400), ("F4", 400),
    ("F4", 400), ("E4", 400), ("E4", 400), ("E4", 400), ("E4", 400),
    ("E4", 400), ("D4", 400), ("D4", 400), ("E4", 400),
    ("D4", 800), ("G4", 800)
]

@app.route('/get-music', methods=['GET'])
def get_music():
    file_path = "jingle_bells.wav"
    try:
        # Generate melody
        song = AudioSegment.silent(duration=0)
        for note, duration in jingle_bells:
            if note in NOTES:
                tone = Sine(NOTES[note]).to_audio_segment(duration=duration)
                song += tone + AudioSegment.silent(duration=50)

        song.export(file_path, format="wav")

        # Serve the file
        return send_file(file_path, as_attachment=True, conditional=True)

    except Exception as e:
        return {"error": str(e)}, 500

    finally:
        # Delay removal of the file to ensure it is no longer in use
        if os.path.exists(file_path):
            try:
                os.remove(file_path)
            except PermissionError:
                print(f"Could not delete {file_path}. File is in use.")

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
