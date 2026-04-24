import { auth } from './firebase-config.js';
import { onAuthStateChanged, updateProfile } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

document.addEventListener('DOMContentLoaded', () => {
    const sidebarNav = document.querySelectorAll('.sidebar-nav a');
    const tabs = document.querySelectorAll('.dashboard-tab');
    const profileForm = document.getElementById('profile-form');

    // Tab Switching Logic
    sidebarNav.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            const target = link.getAttribute('href').substring(1);
            
            sidebarNav.forEach(l => l.classList.remove('active'));
            link.classList.add('active');

            tabs.forEach(tab => {
                tab.classList.remove('active');
                if (tab.id === target) {
                    tab.classList.add('active');
                }
            });
        });
    });

    // Load User Data
    onAuthStateChanged(auth, (user) => {
        if (user) {
            const displayName = user.displayName || user.email.split('@')[0];
            const photoURL = user.photoURL || `https://ui-avatars.com/api/?name=${displayName}&background=dfff00&color=1a4d2e`;

            // Sidebar
            document.getElementById('sidebar-name').innerText = displayName;
            document.getElementById('sidebar-email').innerText = user.email;
            document.getElementById('sidebar-pic').src = photoURL;

            // Overview
            document.getElementById('greeting-name').innerText = displayName;

            // Form
            document.getElementById('input-name').value = displayName;
            document.getElementById('input-email').value = user.email;
            document.getElementById('input-pic').value = user.photoURL || '';
        } else {
            // Redirect to login if not authenticated
            window.location.href = 'auth.html';
        }
    });

    // Update Profile Logic
    if (profileForm) {
        profileForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const newName = document.getElementById('input-name').value;
            const newPic = document.getElementById('input-pic').value;

            try {
                await updateProfile(auth.currentUser, {
                    displayName: newName,
                    photoURL: newPic
                });
                alert("Profile updated successfully!");
                window.location.reload();
            } catch (error) {
                alert(`Error updating profile: ${error.message}`);
            }
        });
    }
});
