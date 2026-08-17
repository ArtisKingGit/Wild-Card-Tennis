// ==========================================================================
// Wild Card Tennis - Global Script Engine
// ==========================================================================

// Global Toast System
window.showToast = function(message, type = 'info', duration = 3500) {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    
    // Icon based on type
    let icon = 'ℹ️';
    if (type === 'success') icon = '✓';
    if (type === 'error') icon = '✕';

    toast.innerHTML = `
        <span style="font-size: 1.1rem; font-weight: 800; color: ${type === 'success' ? 'var(--vibrant-yellow)' : type === 'error' ? '#ff4757' : 'var(--secondary-green)'};">${icon}</span>
        <span>${message}</span>
    `;

    container.appendChild(toast);

    setTimeout(() => {
        toast.classList.add('toast-hide');
        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 300);
    }, duration);
};

// Data Management Utility (Bookings & Quotes)
window.WildCardDB = {
    getBookings: function() {
        try {
            return JSON.parse(localStorage.getItem('wildcard_bookings') || '[]');
        } catch (e) {
            return [];
        }
    },
    saveBooking: function(booking) {
        const bookings = this.getBookings();
        booking.id = 'BK-' + Date.now();
        booking.createdAt = new Date().toISOString();
        bookings.unshift(booking);
        localStorage.setItem('wildcard_bookings', JSON.stringify(bookings));
        return booking;
    },
    cancelBooking: function(id) {
        let bookings = this.getBookings();
        bookings = bookings.filter(b => b.id !== id);
        localStorage.setItem('wildcard_bookings', JSON.stringify(bookings));
        return bookings;
    },
    getPlans: function() {
        try {
            return JSON.parse(localStorage.getItem('wildcard_plans') || '[]');
        } catch (e) {
            return [];
        }
    },
    savePlan: function(plan) {
        const plans = this.getPlans();
        plan.id = 'PL-' + Date.now();
        plan.createdAt = new Date().toISOString();
        plans.unshift(plan);
        localStorage.setItem('wildcard_plans', JSON.stringify(plans));
        return plan;
    },
    getProfilePrefs: function() {
        try {
            return JSON.parse(localStorage.getItem('wildcard_tennis_prefs') || '{}');
        } catch (e) {
            return {};
        }
    },
    saveProfilePrefs: function(prefs) {
        localStorage.setItem('wildcard_tennis_prefs', JSON.stringify(prefs));
    }
};

document.addEventListener('DOMContentLoaded', () => {
    // 1. Mobile Drawer Navigation Toggle
    const hamburgerBtn = document.querySelector('.hamburger-btn');
    const mobileDrawer = document.querySelector('.mobile-drawer');
    const drawerOverlay = document.querySelector('.mobile-drawer-overlay');

    if (hamburgerBtn && mobileDrawer) {
        const toggleDrawer = () => {
            const isOpen = mobileDrawer.classList.toggle('open');
            hamburgerBtn.classList.toggle('active', isOpen);
            if (drawerOverlay) drawerOverlay.classList.toggle('active', isOpen);
            document.body.style.overflow = isOpen ? 'hidden' : '';
        };

        hamburgerBtn.addEventListener('click', toggleDrawer);

        if (drawerOverlay) {
            drawerOverlay.addEventListener('click', toggleDrawer);
        }

        mobileDrawer.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', () => {
                if (mobileDrawer.classList.contains('open')) {
                    toggleDrawer();
                }
            });
        });
    }

    // 2. Safe Smooth Scroll (Only for hash anchors on the same page, like #events or #about)
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const targetId = this.getAttribute('href');
            if (targetId && targetId !== '#' && targetId.length > 1) {
                const targetElement = document.querySelector(targetId);
                if (targetElement) {
                    e.preventDefault();
                    targetElement.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            }
        });
    });

    // 3. Live Preview on Index if event form elements exist
    const eventForm = document.getElementById('event-form');
    const dynamicPreview = document.getElementById('dynamic-preview');
    const eventNameInput = document.getElementById('event-name');
    const eventTypeSelect = document.getElementById('event-type');
    const eventDateInput = document.getElementById('event-date');

    if (eventNameInput && eventTypeSelect && eventDateInput && dynamicPreview) {
        const updatePreview = () => {
            const name = eventNameInput.value || 'Your Event Title';
            const type = eventTypeSelect.value || 'Tournament';
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
    }

    if (eventForm) {
        eventForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const btn = eventForm.querySelector('button[type="submit"]');
            if (btn) {
                const originalText = btn.innerText;
                btn.innerText = 'Requesting...';
                btn.disabled = true;

                setTimeout(() => {
                    window.showToast('Tournament proposal sent! Our team will contact you within 24 hours.', 'success');
                    btn.innerText = 'Success!';
                    
                    setTimeout(() => {
                        eventForm.reset();
                        btn.innerText = originalText;
                        btn.disabled = false;
                        if (typeof updatePreview === 'function') updatePreview();
                    }, 2500);
                }, 1000);
            }
        });
    }

    // 4. Scroll animations for event cards
    const cards = document.querySelectorAll('.event-card');
    if (cards.length > 0 && 'IntersectionObserver' in window) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, { threshold: 0.1 });

        cards.forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(40px)';
            card.style.transition = 'all 0.6s cubic-bezier(0.16, 1, 0.3, 1)';
            observer.observe(card);
        });
    }
});
