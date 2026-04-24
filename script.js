document.addEventListener('DOMContentLoaded', () => {
    const eventForm = document.getElementById('event-form');
    const dynamicPreview = document.getElementById('dynamic-preview');
    const eventNameInput = document.getElementById('event-name');
    const eventTypeSelect = document.getElementById('event-type');
    const eventDateInput = document.getElementById('event-date');

    // Live Preview Logic
    const updatePreview = () => {
        const name = eventNameInput.value || 'Your Event Title';
        const type = eventTypeSelect.value;
        const date = eventDateInput.value ? new Date(eventDateInput.value).toLocaleDateString() : 'Date TBD';
        
        dynamicPreview.innerHTML = `
            <strong style="display: block; font-size: 1.5rem; color: var(--primary-green); margin-bottom: 0.5rem;">${name}</strong>
            <span style="display: block; font-weight: 600; color: var(--secondary-green); text-transform: uppercase; font-size: 0.8rem;">${type}</span>
            <span style="display: block; margin-top: 1rem; font-size: 0.9rem;">${date}</span>
        `;
    };

    eventNameInput.addEventListener('input', updatePreview);
    eventTypeSelect.addEventListener('change', updatePreview);
    eventDateInput.addEventListener('change', updatePreview);

    // Form Submission
    eventForm.addEventListener('submit', (e) => {
        e.preventDefault();
        
        const btn = eventForm.querySelector('button');
        const originalText = btn.innerText;
        
        btn.innerText = 'Requesting...';
        btn.disabled = true;
        btn.style.background = '#ccc';

        setTimeout(() => {
            alert('Tournament Proposal Sent Successfully! Our planning team will contact you within 24 hours.');
            btn.innerText = 'Success!';
            btn.style.background = 'var(--secondary-green)';
            btn.style.color = 'white';
            
            setTimeout(() => {
                eventForm.reset();
                btn.innerText = originalText;
                btn.disabled = false;
                btn.style.background = 'var(--vibrant-yellow)';
                btn.style.color = 'var(--primary-green)';
                updatePreview();
            }, 3000);
        }, 1500);
    });

    // Smooth scroll for nav links
    document.querySelectorAll('nav a').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            document.querySelector(targetId).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });

    // Simple scroll animation for cards
    const observerOptions = {
        threshold: 0.1
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    document.querySelectorAll('.event-card').forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(50px)';
        card.style.transition = 'all 0.6s ease-out';
        observer.observe(card);
    });
});
