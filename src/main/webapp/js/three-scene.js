/**
 * 3D Student Library Management System - Interactive Three.js Scene
 * Features:
 * - 3D Futuristic Bookshelf Environment
 * - Realistic 3D Books with custom spines and page blocks
 * - Floating & Rotating 3D Books with sinusoidal hover
 * - Floating Energy Motes / Knowledge Particles
 * - Mouse Parallax Camera Tracking & Raycasting Book Interaction
 */

(function () {
    const container = document.getElementById('three-canvas-container');
    if (!container) return;

    // Check if Three.js is loaded
    if (typeof THREE === 'undefined') {
        console.warn('Three.js library not detected. Ensure three.min.js is included.');
        return;
    }

    let scene, camera, renderer;
    let floatingBooks = [];
    let shelfBooks = [];
    let particles;
    let mouseX = 0, mouseY = 0;
    let targetCameraX = 0, targetCameraY = 0;
    let raycaster, mouse;
    let hoveredBook = null;

    init();
    animate();

    function init() {
        // 1. Scene Setup
        scene = new THREE.Scene();
        scene.fog = new THREE.FogExp2(0x0a0e1a, 0.028);

        // 2. Camera Setup
        camera = new THREE.PerspectiveCamera(55, window.innerWidth / window.innerHeight, 0.1, 1000);
        camera.position.set(0, 1.5, 12);

        // 3. WebGL Renderer
        renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });
        renderer.setSize(window.innerWidth, window.innerHeight);
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
        renderer.toneMapping = THREE.ACESFilmicToneMapping;
        renderer.toneMappingExposure = 1.2;
        container.appendChild(renderer.domElement);

        // 4. Lighting
        const ambientLight = new THREE.AmbientLight(0x232d4b, 1.4);
        scene.add(ambientLight);

        // Main directional sunlight/moonlight
        const dirLight = new THREE.DirectionalLight(0xffffff, 0.9);
        dirLight.position.set(5, 12, 10);
        scene.add(dirLight);

        // Cyber Cyan Accent Point Light
        const cyanLight = new THREE.PointLight(0x00f2fe, 3.5, 30);
        cyanLight.position.set(-8, 4, 6);
        scene.add(cyanLight);

        // Electric Purple Accent Point Light
        const purpleLight = new THREE.PointLight(0x9d4edd, 3.2, 30);
        purpleLight.position.set(8, -2, 5);
        scene.add(purpleLight);

        // Magenta backlight
        const magentaLight = new THREE.PointLight(0xf72585, 2.0, 25);
        magentaLight.position.set(0, 8, -6);
        scene.add(magentaLight);

        // 5. Construct 3D Elements
        create3DBookshelf();
        createFloatingBooks();
        createParticleField();

        // 6. Interaction Setup
        raycaster = new THREE.Raycaster();
        mouse = new THREE.Vector2();

        window.addEventListener('resize', onWindowResize, false);
        window.addEventListener('mousemove', onMouseMove, false);
        window.addEventListener('touchmove', onTouchMove, { passive: true });
    }

    /**
     * Creates a realistic 3D Book with colored cover and textured white pages
     */
    function createBookMesh(width, height, depth, coverColorHex) {
        const bookGroup = new THREE.Group();

        // Pages block (white/ivory core)
        const pagesGeo = new THREE.BoxGeometry(width * 0.92, height * 0.94, depth * 0.88);
        const pagesMat = new THREE.MeshStandardMaterial({
            color: 0xf1f0ea,
            roughness: 0.9,
            metalness: 0.05
        });
        const pagesMesh = new THREE.Mesh(pagesGeo, pagesMat);
        pagesMesh.position.set(width * 0.04, 0, 0);
        bookGroup.add(pagesMesh);

        // Book Cover (Front, Back, and Spine)
        const coverMat = new THREE.MeshStandardMaterial({
            color: coverColorHex,
            roughness: 0.35,
            metalness: 0.25
        });

        // Spine
        const spineGeo = new THREE.BoxGeometry(width * 0.08, height, depth);
        const spineMesh = new THREE.Mesh(spineGeo, coverMat);
        spineMesh.position.set(-width * 0.46, 0, 0);
        bookGroup.add(spineMesh);

        // Front Cover
        const coverGeo = new THREE.BoxGeometry(width * 0.96, height, depth * 0.06);
        const frontCover = new THREE.Mesh(coverGeo, coverMat);
        frontCover.position.set(0.02, 0, depth * 0.47);
        bookGroup.add(frontCover);

        // Back Cover
        const backCover = new THREE.Mesh(coverGeo, coverMat);
        backCover.position.set(0.02, 0, -depth * 0.47);
        bookGroup.add(backCover);

        // Gold spine accent stripes
        const goldMat = new THREE.MeshStandardMaterial({
            color: 0xffd166,
            metalness: 0.8,
            roughness: 0.2
        });
        const stripeGeo = new THREE.BoxGeometry(width * 0.082, height * 0.04, depth * 0.7);
        const stripe1 = new THREE.Mesh(stripeGeo, goldMat);
        stripe1.position.set(-width * 0.465, height * 0.3, 0);
        const stripe2 = stripe1.clone();
        stripe2.position.set(-width * 0.465, -height * 0.3, 0);
        bookGroup.add(stripe1);
        bookGroup.add(stripe2);

        return bookGroup;
    }

    /**
     * Builds multi-tier architectural bookshelf in the 3D background
     */
    function create3DBookshelf() {
        const shelfGroup = new THREE.Group();
        const shelfWoodMat = new THREE.MeshStandardMaterial({
            color: 0x141a2e,
            roughness: 0.6,
            metalness: 0.3
        });

        const tiers = 3;
        const shelfWidth = 14;
        const tierHeight = 2.8;

        // Shelf horizontal planks
        for (let t = 0; t <= tiers; t++) {
            const plankGeo = new THREE.BoxGeometry(shelfWidth, 0.18, 2.2);
            const plank = new THREE.Mesh(plankGeo, shelfWoodMat);
            plank.position.set(0, (t * tierHeight) - 2.8, -4.5);
            shelfGroup.add(plank);
        }

        // Side vertical panels
        const sideGeo = new THREE.BoxGeometry(0.2, tiers * tierHeight + 0.3, 2.2);
        const leftSide = new THREE.Mesh(sideGeo, shelfWoodMat);
        leftSide.position.set(-shelfWidth / 2, 1.4 - 2.8, -4.5);
        shelfGroup.add(leftSide);

        const rightSide = new THREE.Mesh(sideGeo, shelfWoodMat);
        rightSide.position.set(shelfWidth / 2, 1.4 - 2.8, -4.5);
        shelfGroup.add(rightSide);

        // Central vertical dividers
        const midSide = new THREE.Mesh(sideGeo, shelfWoodMat);
        midSide.position.set(0, 1.4 - 2.8, -4.5);
        shelfGroup.add(midSide);

        // Colors palette for library books
        const bookColors = [
            0x00f2fe, // Cyan
            0x9d4edd, // Purple
            0x4facfe, // Blue
            0x10b981, // Emerald
            0xf72585, // Magenta
            0xf59e0b, // Amber
            0x3a86ff, // Royal Blue
            0xe63946, // Crimson
            0x06d6a0  // Teal
        ];

        // Populate shelves with rows of books
        for (let t = 0; t < tiers; t++) {
            const shelfY = (t * tierHeight) - 2.8 + 0.12;

            // Populate left and right bay
            [-shelfWidth / 4, shelfWidth / 4].forEach(bayCenterX => {
                const numBooks = 14;
                const spacing = 0.42;
                const startX = bayCenterX - ((numBooks - 1) * spacing) / 2;

                for (let b = 0; b < numBooks; b++) {
                    const w = 1.1 + Math.random() * 0.2;
                    const h = 1.6 + Math.random() * 0.5;
                    const d = 0.28 + Math.random() * 0.12;
                    const color = bookColors[Math.floor(Math.random() * bookColors.length)];

                    const book = createBookMesh(w, h, d, color);
                    const posX = startX + b * spacing;
                    const posY = shelfY + h / 2;
                    const posZ = -4.5 + (Math.random() * 0.2 - 0.1);

                    book.position.set(posX, posY, posZ);
                    book.rotation.y = Math.PI / 2; // Facing spine out

                    // Random slight tilt for realistic lived-in library feel
                    if (Math.random() > 0.8) {
                        book.rotation.z = (Math.random() - 0.5) * 0.15;
                    }

                    shelfGroup.add(book);
                    shelfBooks.push(book);
                }
            });
        }

        scene.add(shelfGroup);
    }

    /**
     * Creates prominent floating, rotating 3D books in midground & foreground
     */
    function createFloatingBooks() {
        const floatData = [
            { pos: [-4.5, 2.0, 4.0], scale: 1.35, rotSpeed: [0.008, 0.012, 0.005], color: 0x00f2fe },
            { pos: [4.8, 1.2, 3.5], scale: 1.25, rotSpeed: [-0.007, 0.01, -0.004], color: 0x9d4edd },
            { pos: [-6.0, -2.2, 5.0], scale: 1.4, rotSpeed: [0.005, -0.009, 0.006], color: 0x4facfe },
            { pos: [5.8, -2.5, 4.5], scale: 1.3, rotSpeed: [-0.008, 0.008, 0.007], color: 0xf72585 },
            { pos: [0.0, 4.2, 2.0], scale: 1.1, rotSpeed: [0.006, 0.014, -0.003], color: 0x10b981 }
        ];

        floatData.forEach(item => {
            const bookMesh = createBookMesh(1.4, 1.9, 0.35, item.color);
            bookMesh.position.set(item.pos[0], item.pos[1], item.pos[2]);
            bookMesh.scale.set(item.scale, item.scale, item.scale);
            bookMesh.rotation.set(
                Math.random() * Math.PI,
                Math.random() * Math.PI,
                Math.random() * Math.PI
            );

            // Store animation state
            bookMesh.userData = {
                initialY: item.pos[1],
                rotSpeed: item.rotSpeed,
                floatSpeed: 1.2 + Math.random() * 0.6,
                floatOffset: Math.random() * Math.PI * 2,
                isFloating: true
            };

            scene.add(bookMesh);
            floatingBooks.push(bookMesh);
        });
    }

    /**
     * Creates 1200 floating glowing energy motes (knowledge particles)
     */
    function createParticleField() {
        const particleCount = 1200;
        const geometry = new THREE.BufferGeometry();
        const positions = new Float32Array(particleCount * 3);
        const colors = new Float32Array(particleCount * 3);

        const color1 = new THREE.Color(0x00f2fe);
        const color2 = new THREE.Color(0x9d4edd);
        const color3 = new THREE.Color(0x4facfe);

        for (let i = 0; i < particleCount; i++) {
            const i3 = i * 3;
            positions[i3] = (Math.random() - 0.5) * 35;
            positions[i3 + 1] = (Math.random() - 0.5) * 25;
            positions[i3 + 2] = (Math.random() - 0.5) * 25;

            const mixedColor = Math.random() < 0.45 ? color1 : (Math.random() < 0.8 ? color2 : color3);
            colors[i3] = mixedColor.r;
            colors[i3 + 1] = mixedColor.g;
            colors[i3 + 2] = mixedColor.b;
        }

        geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
        geometry.setAttribute('color', new THREE.BufferAttribute(colors, 3));

        // Create glowing circular particle texture programmatically
        const canvas = document.createElement('canvas');
        canvas.width = 64;
        canvas.height = 64;
        const ctx = canvas.getContext('2d');
        const grad = ctx.createRadialGradient(32, 32, 0, 32, 32, 30);
        grad.addColorStop(0, 'rgba(255, 255, 255, 1)');
        grad.addColorStop(0.3, 'rgba(0, 242, 254, 0.8)');
        grad.addColorStop(1, 'rgba(0, 0, 0, 0)');
        ctx.fillStyle = grad;
        ctx.fillRect(0, 0, 64, 64);

        const pTexture = new THREE.CanvasTexture(canvas);

        const material = new THREE.PointsMaterial({
            size: 0.18,
            map: pTexture,
            vertexColors: true,
            transparent: true,
            opacity: 0.8,
            blending: THREE.AdditiveBlending,
            depthWrite: false
        });

        particles = new THREE.Points(geometry, material);
        scene.add(particles);
    }

    function onMouseMove(event) {
        mouseX = (event.clientX / window.innerWidth) * 2 - 1;
        mouseY = -(event.clientY / window.innerHeight) * 2 + 1;

        mouse.x = mouseX;
        mouse.y = mouseY;

        targetCameraX = mouseX * 1.8;
        targetCameraY = mouseY * 1.2 + 1.5;
    }

    function onTouchMove(event) {
        if (event.touches.length > 0) {
            mouseX = (event.touches[0].clientX / window.innerWidth) * 2 - 1;
            mouseY = -(event.touches[0].clientY / window.innerHeight) * 2 + 1;
            targetCameraX = mouseX * 1.5;
            targetCameraY = mouseY * 1.0 + 1.5;
        }
    }

    function onWindowResize() {
        if (!camera || !renderer) return;
        camera.aspect = window.innerWidth / window.innerHeight;
        camera.updateProjectionMatrix();
        renderer.setSize(window.innerWidth, window.innerHeight);
    }

    /**
     * Main Render & Animation Loop
     */
    function animate() {
        requestAnimationFrame(animate);

        const time = performance.now() * 0.001;

        // 1. Smooth Camera Parallax Tracking
        camera.position.x += (targetCameraX - camera.position.x) * 0.04;
        camera.position.y += (targetCameraY - camera.position.y) * 0.04;
        camera.lookAt(0, 0.5, 0);

        // 2. Animate Floating Books (Sinusoidal Hover & Rotation)
        floatingBooks.forEach((book, idx) => {
            const data = book.userData;
            book.position.y = data.initialY + Math.sin(time * data.floatSpeed + data.floatOffset) * 0.35;
            book.rotation.x += data.rotSpeed[0];
            book.rotation.y += data.rotSpeed[1];
            book.rotation.z += data.rotSpeed[2];
        });

        // 3. Animate Knowledge Particle Field
        if (particles) {
            particles.rotation.y = time * 0.025;
            particles.rotation.x = Math.sin(time * 0.015) * 0.05;
        }

        // 4. Raycast Hover Interaction on Floating Books
        raycaster.setFromCamera(mouse, camera);
        const intersects = raycaster.intersectObjects(floatingBooks, true);

        if (intersects.length > 0) {
            // Find root book group
            let obj = intersects[0].object;
            while (obj.parent && obj.parent !== scene) {
                obj = obj.parent;
            }
            if (obj && obj.userData && obj.userData.isFloating) {
                obj.scale.lerp(new THREE.Vector3(1.5, 1.5, 1.5), 0.1);
            }
        } else {
            floatingBooks.forEach(b => {
                b.scale.lerp(new THREE.Vector3(1.25, 1.25, 1.25), 0.08);
            });
        }

        renderer.render(scene, camera);
    }
})();

