import { auth, googleProvider } from './firebase-config.js';
import { 
    signInWithEmailAndPassword, 
    createUserWithEmailAndPassword, 
    signInWithPopup, 
    onAuthStateChanged,
    signOut 
} from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

document.addEventListener('DOMContentLoaded', () => {
    const tabLogin = document.getElementById('tab-login');
    const tabSignup = document.getElementById('tab-signup');
    const formLogin = document.getElementById('form-login');
    const formSignup = document.getElementById('form-signup');
    const btnGoogle = document.getElementById('btn-google');

    // Toggle logic remains same
    if (tabLogin && tabSignup) {
        tabLogin.addEventListener('click', () => {
            tabLogin.classList.add('active');
            tabSignup.classList.remove('active');
            formLogin.classList.add('active');
            formSignup.classList.remove('active');
        });

        tabSignup.addEventListener('click', () => {
            tabSignup.classList.add('active');
            tabLogin.classList.remove('active');
            formSignup.classList.add('active');
            formLogin.classList.remove('active');
        });
    }

    // --- FIREBASE AUTH LOGIC ---

    // 1. Email/Password Login
    if (formLogin) {
        formLogin.addEventListener('submit', async (e) => {
            e.preventDefault();
            const email = e.target.querySelector('input[type="email"]').value;
            const password = e.target.querySelector('input[type="password"]').value;
            
            try {
                const userCredential = await signInWithEmailAndPassword(auth, email, password);
                console.log("Logged in:", userCredential.user);
                window.location.href = 'index.html';
            } catch (error) {
                alert(`Login Error: ${error.message}`);
            }
        });
    }

    // 2. Email/Password Signup
    if (formSignup) {
        formSignup.addEventListener('submit', async (e) => {
            e.preventDefault();
            const name = e.target.querySelector('input[type="text"]').value;
            const email = e.target.querySelector('input[type="email"]').value;
            const password = e.target.querySelector('input[type="password"]').value;

            try {
                const userCredential = await createUserWithEmailAndPassword(auth, email, password);
                console.log("Signed up:", userCredential.user);
                // Note: Updating displayName would require updateProfile, but we can just use the email for now
                window.location.href = 'index.html';
            } catch (error) {
                alert(`Signup Error: ${error.message}`);
            }
        });
    }

    // 3. Google Sign-In
    if (btnGoogle) {
        btnGoogle.addEventListener('click', async () => {
            try {
                const result = await signInWithPopup(auth, googleProvider);
                console.log("Google user:", result.user);
                window.location.href = 'index.html';
            } catch (error) {
                alert(`Google Auth Error: ${error.message}`);
            }
        });
    }

    // 4. Global Auth State Observer
    onAuthStateChanged(auth, (user) => {
        const loginBtns = document.querySelectorAll('.login-button');
        const userProfiles = document.querySelectorAll('#user-profile');
        const userNames = document.querySelectorAll('#user-name');
        const userPics = document.querySelectorAll('#user-pic');

        if (user) {
            // User is signed in
            const displayName = user.displayName || user.email.split('@')[0];
            const photoURL = user.photoURL || `https://ui-avatars.com/api/?name=${displayName}&background=dfff00&color=1a4d2e`;

            loginBtns.forEach(btn => btn.style.display = 'none');
            
            userProfiles.forEach(profile => profile.style.display = 'inline-flex');
            userNames.forEach(name => name.innerText = displayName);
            userPics.forEach(pic => {
                pic.src = photoURL;
                pic.alt = displayName;
            });
        } else {
            // User is signed out
            loginBtns.forEach(btn => btn.style.display = 'inline-flex');
            userProfiles.forEach(profile => profile.style.display = 'none');
        }
    });

    // 5. Logout Logic
    const logoutHandler = async (e) => {
        if (e.target.id === 'logout-link' || e.target.closest('#logout-link')) {
            e.preventDefault();
            try {
                await signOut(auth);
                window.location.reload();
            } catch (error) {
                console.error("Logout failed", error);
            }
        }
    };

    document.addEventListener('click', logoutHandler);
});
