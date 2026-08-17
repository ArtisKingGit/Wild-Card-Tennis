import { auth } from './firebase-config.js';
import { onAuthStateChanged, updateProfile } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

document.addEventListener('DOMContentLoaded', () => {
    const sidebarNav = document.querySelectorAll('.sidebar-nav a');
    const tabs = document.querySelectorAll('.dashboard-tab');
    const profileForm = document.getElementById('profile-form');
    const tennisPrefsForm = document.getElementById('tennis-prefs-form');

    // Containers
    const bookingsContainer = document.getElementById('user-bookings-container');
    const plansContainer = document.getElementById('user-plans-container');
    const activityFeed = document.getElementById('activity-feed');

    const statMatches = document.getElementById('stat-matches');
    const statPlans = document.getElementById('stat-plans');
    const statTier = document.getElementById('stat-tier');
    const sidebarTierBadge = document.getElementById('sidebar-tier-badge');

    // 1. Tab Switching Function
    const switchTab = (targetId) => {
        sidebarNav.forEach(l => {
            const href = l.getAttribute('href').substring(1);
            l.classList.toggle('active', href === targetId);
        });

        tabs.forEach(tab => {
            tab.classList.toggle('active', tab.id === targetId);
        });
    };

    sidebarNav.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const target = link.getAttribute('href').substring(1);
            switchTab(target);
            window.location.hash = target;
        });
    });

    // Check URL hash on page load
    if (window.location.hash) {
        const hashTab = window.location.hash.substring(1);
        if (document.getElementById(hashTab)) {
            switchTab(hashTab);
        }
    }

    // 2. Render User Bookings
    const renderBookings = () => {
        if (!bookingsContainer) return;
        const bookings = window.WildCardDB ? window.WildCardDB.getBookings() : [];
        if (statMatches) statMatches.innerText = bookings.length;

        if (bookings.length === 0) {
            bookingsContainer.innerHTML = `
                <div class="empty-state">
                    <svg viewBox="0 0 24 24"><path d="M19 4h-1V2h-2v2H8V2H6v2H5c-1.11 0-1.99.9-1.99 2L3 20a2 2 0 0 0 2 2h14c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 16H5V10h14v10zm0-12H5V6h14v2zm-7 5h5v5h-5z"/></svg>
                    <p>You have not registered for any upcoming tournaments or clinics yet.</p>
                    <a href="events.html" class="cta-button" style="font-size: 0.85rem;">Find Upcoming Events</a>
                </div>
            `;
            return;
        }

        bookingsContainer.innerHTML = `
            <div class="booked-events-grid">
                ${bookings.map(b => `
                    <div class="booking-card" id="card-${b.id}">
                        <div>
                            <div class="booking-header">
                                <span class="booking-badge">${b.eventType || 'Tournament'}</span>
                                <span style="font-size: 0.75rem; color: var(--secondary-green); font-weight: 700;">${b.status || 'Active'}</span>
                            </div>
                            <h3 style="color: var(--primary-green); margin-bottom: 0.4rem;">${b.eventTitle}</h3>
                            <p style="font-size: 0.85rem; color: #666; margin-bottom: 0.5rem;">📅 ${b.eventDateStr || 'TBD'}</p>
                            <p style="font-size: 0.85rem; color: #666;">🎯 Division: <strong>${b.division || 'Intermediate'}</strong></p>
                            <p style="font-size: 0.85rem; color: #666;">🎟️ Passes: <strong>${b.passes || '1'} Player Pass</strong></p>
                            <p style="font-size: 0.75rem; color: #999; margin-top: 0.8rem;">Ref: ${b.id}</p>
                        </div>
                        <div class="booking-actions">
                            <button class="btn-secondary view-pass-btn" data-id="${b.id}" data-title="${b.eventTitle}">View Digital Pass</button>
                            <button class="btn-danger cancel-booking-btn" data-id="${b.id}">Cancel</button>
                        </div>
                    </div>
                `).join('')}
            </div>
        `;

        // Cancel buttons
        bookingsContainer.querySelectorAll('.cancel-booking-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const id = btn.dataset.id;
                if (confirm('Are you sure you want to cancel this tournament registration?')) {
                    if (window.WildCardDB) window.WildCardDB.cancelBooking(id);
                    if (window.showToast) window.showToast('Registration cancelled.', 'info');
                    renderBookings();
                }
            });
        });

        // View Pass buttons
        bookingsContainer.querySelectorAll('.view-pass-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const title = btn.dataset.title;
                const id = btn.dataset.id;
                if (window.showToast) {
                    window.showToast(`Pass #${id} verified for ${title}! Present at venue reception.`, 'success', 4000);
                }
            });
        });
    };

    // 3. Render User Custom Event Proposals
    const renderPlans = () => {
        if (!plansContainer) return;
        const plans = window.WildCardDB ? window.WildCardDB.getPlans() : [];
        if (statPlans) statPlans.innerText = plans.length;

        if (plans.length === 0) {
            plansContainer.innerHTML = `
                <div class="empty-state">
                    <p>No customized event proposals requested yet.</p>
                    <a href="planner.html" class="cta-button" style="font-size: 0.85rem;">Create Tactical Event Plan</a>
                </div>
            `;
            return;
        }

        plansContainer.innerHTML = `
            <div class="booked-events-grid">
                ${plans.map(p => `
                    <div class="booking-card">
                        <div>
                            <div class="booking-header">
                                <span class="booking-badge" style="background: var(--secondary-green); color: white;">${p.type || 'Custom Event'}</span>
                                <span style="font-size: 0.75rem; color: #f39c12; font-weight: 700;">● ${p.status || 'Under Review'}</span>
                            </div>
                            <h3 style="color: var(--primary-green); margin-bottom: 0.4rem;">${p.title}</h3>
                            <p style="font-size: 0.85rem; color: #666; margin-bottom: 0.3rem;">📅 Proposed Date: <strong>${p.date || 'TBD'}</strong></p>
                            <p style="font-size: 0.85rem; color: #666; margin-bottom: 0.3rem;">🏟️ Courts: <strong>${p.courts} Courts (${p.venue || 'Hard'})</strong></p>
                            <p style="font-size: 0.85rem; color: #666; margin-bottom: 0.3rem;">👥 Players: <strong>${p.players}</strong></p>
                            <p style="font-size: 0.95rem; color: var(--primary-green); font-weight: 800; margin-top: 0.8rem;">Est. Budget: ${p.estimatedBudget || '$0'}</p>
                            <p style="font-size: 0.75rem; color: #999; margin-top: 0.3rem;">Ref: ${p.id}</p>
                        </div>
                        <div class="booking-actions">
                            <button class="btn-secondary" onclick="window.showToast('Our Venue Director has your tactical brief under review. You will receive a formalized PDF proposal.', 'info')">Check Status</button>
                        </div>
                    </div>
                `).join('')}
            </div>
        `;
    };

    // 4. Tennis Preferences Persistence
    const loadTennisPrefs = () => {
        if (!window.WildCardDB) return;
        const prefs = window.WildCardDB.getProfilePrefs();
        if (prefs.skill && document.getElementById('pref-skill')) document.getElementById('pref-skill').value = prefs.skill;
        if (prefs.hand && document.getElementById('pref-hand')) document.getElementById('pref-hand').value = prefs.hand;
        if (prefs.surface && document.getElementById('pref-surface')) document.getElementById('pref-surface').value = prefs.surface;
        if (prefs.racket && document.getElementById('pref-racket')) document.getElementById('pref-racket').value = prefs.racket;
        if (prefs.bio && document.getElementById('input-bio')) document.getElementById('input-bio').value = prefs.bio;
    };

    if (tennisPrefsForm) {
        tennisPrefsForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const prefs = {
                skill: document.getElementById('pref-skill').value,
                hand: document.getElementById('pref-hand').value,
                surface: document.getElementById('pref-surface').value,
                racket: document.getElementById('pref-racket').value,
                bio: document.getElementById('input-bio') ? document.getElementById('input-bio').value : ''
            };
            if (window.WildCardDB) window.WildCardDB.saveProfilePrefs(prefs);
            if (window.showToast) window.showToast('Tennis stats and gear preferences saved!', 'success');
        });
    }

    // 5. Membership Tier Switcher
    const currentTier = localStorage.getItem('wildcard_user_tier') || 'Elite';
    if (statTier) statTier.innerText = currentTier;
    if (sidebarTierBadge) sidebarTierBadge.innerText = `${currentTier} Member`;

    document.querySelectorAll('.select-tier-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            const selectedTier = btn.dataset.tier;
            localStorage.setItem('wildcard_user_tier', selectedTier);
            if (statTier) statTier.innerText = selectedTier;
            if (sidebarTierBadge) sidebarTierBadge.innerText = `${selectedTier} Member`;

            document.querySelectorAll('.tier-card').forEach(c => c.classList.remove('current', 'featured'));
            const parentCard = btn.closest('.tier-card');
            if (parentCard) parentCard.classList.add('current', 'featured');

            if (window.showToast) window.showToast(`Membership tier updated to ${selectedTier}!`, 'success');
        });
    });

    // 6. Load User Data from Firebase
    onAuthStateChanged(auth, (user) => {
        if (user) {
            const displayName = user.displayName || user.email.split('@')[0];
            const photoURL = user.photoURL || `https://ui-avatars.com/api/?name=${encodeURIComponent(displayName)}&background=1a4d2e&color=dfff00`;

            // Sidebar
            const sName = document.getElementById('sidebar-name');
            const sEmail = document.getElementById('sidebar-email');
            const sPic = document.getElementById('sidebar-pic');
            if (sName) sName.innerText = displayName;
            if (sEmail) sEmail.innerText = user.email;
            if (sPic) sPic.src = photoURL;

            // Overview
            const gName = document.getElementById('greeting-name');
            if (gName) gName.innerText = displayName;

            // Form
            const iName = document.getElementById('input-name');
            const iEmail = document.getElementById('input-email');
            const iPic = document.getElementById('input-pic');
            if (iName) iName.value = displayName;
            if (iEmail) iEmail.value = user.email;
            if (iPic) iPic.value = user.photoURL || '';

            renderBookings();
            renderPlans();
            loadTennisPrefs();
        } else {
            // Check if there is guest data
            renderBookings();
            renderPlans();
            loadTennisPrefs();
        }
    });

    // 7. Update Profile Logic
    if (profileForm) {
        profileForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const newName = document.getElementById('input-name').value.trim();
            const newPic = document.getElementById('input-pic').value.trim();
            const newBio = document.getElementById('input-bio').value.trim();

            const submitBtn = profileForm.querySelector('button[type="submit"]');
            if (submitBtn) submitBtn.classList.add('btn-loading');

            // Save bio to prefs
            if (window.WildCardDB) {
                const prefs = window.WildCardDB.getProfilePrefs();
                prefs.bio = newBio;
                window.WildCardDB.saveProfilePrefs(prefs);
            }

            try {
                if (auth.currentUser) {
                    await updateProfile(auth.currentUser, {
                        displayName: newName,
                        photoURL: newPic || auth.currentUser.photoURL
                    });
                }
                if (window.showToast) window.showToast('Profile updated successfully!', 'success');
                
                // Update sidebar UI immediately
                const sName = document.getElementById('sidebar-name');
                const gName = document.getElementById('greeting-name');
                if (sName) sName.innerText = newName;
                if (gName) gName.innerText = newName;
            } catch (error) {
                if (window.showToast) window.showToast(`Error: ${error.message}`, 'error');
            } finally {
                if (submitBtn) submitBtn.classList.remove('btn-loading');
            }
        });
    }
});
