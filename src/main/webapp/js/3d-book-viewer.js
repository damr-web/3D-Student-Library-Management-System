/**
 * 3D Book Viewer - Interactive 360-degree Book Inspection
 * Used on book-details.jsp
 */

function init3DBookViewer(bookData) {
    const container = document.getElementById('book-viewer-container');
    const canvas = document.getElementById('book-viewer-canvas');
    if (!container || !canvas || typeof THREE === 'undefined') return;

    const width = container.clientWidth;
    const height = container.clientHeight;

    // Scene & Camera
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(45, width / height, 0.1, 100);
    camera.position.set(0, 0, 5.2);

    // Renderer
    const renderer = new THREE.WebGLRenderer({ canvas: canvas, alpha: true, antialias: true });
    renderer.setSize(width, height);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));

    // Lights
    const ambientLight = new THREE.AmbientLight(0xffffff, 1.2);
    scene.add(ambientLight);

    const dirLight1 = new THREE.DirectionalLight(0x00f2fe, 1.8);
    dirLight1.position.set(5, 5, 4);
    scene.add(dirLight1);

    const dirLight2 = new THREE.DirectionalLight(0x9d4edd, 1.5);
    dirLight2.position.set(-5, -3, 3);
    scene.add(dirLight2);

    // Dynamic Cover Canvas Texture with Title & Author
    const coverCanvas = document.createElement('canvas');
    coverCanvas.width = 512;
    coverCanvas.height = 768;
    const ctx = coverCanvas.getContext('2d');

    // Background gradient
    const grad = ctx.createLinearGradient(0, 0, 512, 768);
    grad.addColorStop(0, '#0f172a');
    grad.addColorStop(0.5, '#1e1b4b');
    grad.addColorStop(1, '#020617');
    ctx.fillStyle = grad;
    ctx.fillRect(0, 0, 512, 768);

    // Cyber border
    ctx.strokeStyle = '#00f2fe';
    ctx.lineWidth = 12;
    ctx.strokeRect(24, 24, 512 - 48, 768 - 48);

    ctx.strokeStyle = '#9d4edd';
    ctx.lineWidth = 4;
    ctx.strokeRect(36, 36, 512 - 72, 768 - 72);

    // Category
    ctx.fillStyle = '#00f2fe';
    ctx.font = 'bold 24px "Outfit", sans-serif';
    ctx.textAlign = 'center';
    ctx.fillText((bookData.category || 'LIBRARY BOOK').toUpperCase(), 256, 120);

    // Title
    ctx.fillStyle = '#ffffff';
    ctx.font = 'bold 36px "Outfit", sans-serif';
    const words = (bookData.title || 'Book Title').split(' ');
    let line = '';
    let y = 280;
    for (let i = 0; i < words.length; i++) {
        const testLine = line + words[i] + ' ';
        const metrics = ctx.measureText(testLine);
        if (metrics.width > 420 && i > 0) {
            ctx.fillText(line.trim(), 256, y);
            line = words[i] + ' ';
            y += 48;
        } else {
            line = testLine;
        }
    }
    ctx.fillText(line.trim(), 256, y);

    // Author
    ctx.fillStyle = '#94a3b8';
    ctx.font = 'italic 26px "Inter", sans-serif';
    ctx.fillText('by ' + (bookData.author || 'Author'), 256, y + 65);

    // Library insignia
    ctx.fillStyle = '#ffd166';
    ctx.font = 'bold 20px "Outfit", sans-serif';
    ctx.fillText('STUDENT LIBRARY MANAGEMENT', 256, 680);

    const coverTexture = new THREE.CanvasTexture(coverCanvas);

    // Create 3D Book Model
    const book = new THREE.Group();

    const bookWidth = 2.2;
    const bookHeight = 3.0;
    const bookThickness = 0.55;

    // Pages
    const pagesGeo = new THREE.BoxGeometry(bookWidth * 0.94, bookHeight * 0.96, bookThickness * 0.9);
    const pagesMat = new THREE.MeshStandardMaterial({
        color: 0xf6f5ee,
        roughness: 0.9
    });
    const pagesMesh = new THREE.Mesh(pagesGeo, pagesMat);
    pagesMesh.position.set(bookWidth * 0.03, 0, 0);
    book.add(pagesMesh);

    // Cover materials
    const coverMat = new THREE.MeshStandardMaterial({
        map: coverTexture,
        roughness: 0.3,
        metalness: 0.2
    });
    const spineMat = new THREE.MeshStandardMaterial({
        color: 0x1e1b4b,
        roughness: 0.4,
        metalness: 0.3
    });

    // Front Cover
    const frontGeo = new THREE.BoxGeometry(bookWidth, bookHeight, 0.05);
    const frontMesh = new THREE.Mesh(frontGeo, coverMat);
    frontMesh.position.set(0, 0, bookThickness / 2 + 0.02);
    book.add(frontMesh);

    // Back Cover
    const backMesh = new THREE.Mesh(frontGeo, spineMat);
    backMesh.position.set(0, 0, -bookThickness / 2 - 0.02);
    book.add(backMesh);

    // Spine
    const spineGeo = new THREE.BoxGeometry(0.08, bookHeight, bookThickness + 0.08);
    const spineMesh = new THREE.Mesh(spineGeo, spineMat);
    spineMesh.position.set(-bookWidth / 2 - 0.03, 0, 0);
    book.add(spineMesh);

    book.rotation.set(0.15, -0.4, 0);
    scene.add(book);

    // Mouse / Touch Drag Orbit Interaction
    let isDragging = false;
    let previousMousePosition = { x: 0, y: 0 };

    canvas.addEventListener('mousedown', (e) => {
        isDragging = true;
        previousMousePosition = { x: e.clientX, y: e.clientY };
    });

    window.addEventListener('mouseup', () => {
        isDragging = false;
    });

    canvas.addEventListener('mousemove', (e) => {
        if (!isDragging) return;
        const deltaX = e.clientX - previousMousePosition.x;
        const deltaY = e.clientY - previousMousePosition.y;

        book.rotation.y += deltaX * 0.01;
        book.rotation.x += deltaY * 0.01;

        previousMousePosition = { x: e.clientX, y: e.clientY };
    });

    // Touch support
    canvas.addEventListener('touchstart', (e) => {
        if (e.touches.length === 1) {
            isDragging = true;
            previousMousePosition = { x: e.touches[0].clientX, y: e.touches[0].clientY };
        }
    }, { passive: true });

    window.addEventListener('touchend', () => {
        isDragging = false;
    });

    canvas.addEventListener('touchmove', (e) => {
        if (!isDragging || e.touches.length !== 1) return;
        const deltaX = e.touches[0].clientX - previousMousePosition.x;
        const deltaY = e.touches[0].clientY - previousMousePosition.y;

        book.rotation.y += deltaX * 0.01;
        book.rotation.x += deltaY * 0.01;

        previousMousePosition = { x: e.touches[0].clientX, y: e.touches[0].clientY };
    }, { passive: true });

    // Resize
    window.addEventListener('resize', () => {
        const newWidth = container.clientWidth;
        const newHeight = container.clientHeight;
        camera.aspect = newWidth / newHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(newWidth, newHeight);
    });

    // Render loop
    function animate() {
        requestAnimationFrame(animate);

        // Auto slow idle rotation when user is not dragging
        if (!isDragging) {
            book.rotation.y += 0.005;
            book.position.y = Math.sin(performance.now() * 0.002) * 0.08;
        }

        renderer.render(scene, camera);
    }
    animate();
}

