/**
 * Main UI Interactivity Script
 */

document.addEventListener('DOMContentLoaded', () => {
    // 1. Animate Numerical Counters
    const counters = document.querySelectorAll('.stat-number');
    counters.forEach(counter => {
        const target = parseInt(counter.getAttribute('data-target') || counter.innerText.trim(), 10);
        if (!isNaN(target) && target > 0) {
            counter.innerText = '0';
            const duration = 1200; // ms
            const stepTime = 20;
            const steps = duration / stepTime;
            const increment = target / steps;
            let current = 0;

            const timer = setInterval(() => {
                current += increment;
                if (current >= target) {
                    counter.innerText = target;
                    clearInterval(timer);
                } else {
                    counter.innerText = Math.floor(current);
                }
            }, stepTime);
        }
    });

    // 2. Auto-dismiss alerts after 5 seconds
    const alerts = document.querySelectorAll('.alert-futuristic');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(() => alert.remove(), 600);
        }, 5000);
    });

    // 3. Quick Table Search on pages with #tableSearch input
    const tableSearch = document.getElementById('tableSearch');
    if (tableSearch) {
        tableSearch.addEventListener('keyup', function () {
            const query = this.value.toLowerCase();
            const rows = document.querySelectorAll('.table-futuristic tbody tr');
            rows.forEach(row => {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(query) ? '' : 'none';
            });
        });
    }
});

