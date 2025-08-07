from flask import Flask, render_template, request
from datetime import datetime
import os

app = Flask(__name__)
UPLOAD_FOLDER = 'captured'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload():
    if 'image' in request.files:
        image = request.files['image']
        timestamp = datetime.now().strftime("%Y%m%d-%H%M%S-%f")
        filename = image.filename or 'snap.jpg'
        save_path = os.path.join(UPLOAD_FOLDER, f"{timestamp}-{filename}")
        image.save(save_path)
        print(f"[+] Image saved: {save_path}")
        return 'Success', 200
    else:
        print("[-] No image in request")
        return 'No image', 400

if __name__ == '__main__':
    app.run(debug=True)
