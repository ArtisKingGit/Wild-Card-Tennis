import { auth, googleProvider } from './firebase-config.js';
import { 
    signInWithEmailAndPassword, 
    createUserWithEmailAndPassword, 
    signInWithPopup, 
    onAuthStateChanged,
    signOut,
    updateProfile,
    sendPasswordResetEmail
} from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";

document.addEventListener('DOMContentLoaded', () => {
    const tabLogin = document.getElementById('tab-login');
    const tabSignup = document.getElementById('tab-signup');
    const formLogin = document.getElementById('form-login');
    const formSignup = document.getElementById('form-signup');
    const btnGoogle = document.getElementById('btn-google');
    const forgotPasswordLink = document.getElementById('forgot-password-link');
    const resetModal = document.getElementById('reset-modal');
    const resetForm = document.getElementById('reset-form');
    const resetModalClose = document.getElementById('reset-modal-close');

    // Helper for Toast or fallback alert
    const notify = (msg, type = 'info') => {
        if (typeof window.showToast === 'function') {
            window.showToast(msg, type);
        } else {
            alert(msg);
        }
    };

    // Toggle Login / Signup Tabs
    if (tabLogin && tabSignup) {
        tabLogin.addEventListener('click', () => {
            tabLogin.classList.add('active');
            tabSignup.classList.remove('active');
            if (formLogin) formLogin.classList.add('active');
            if (formSignup) formSignup.classList.remove('active');
        });

        tabSignup.addEventListener('click', () => {
            tabSignup.classList.add('active');
            tabLogin.classList.remove('active');
            if (formSignup) formSignup.classList.add('active');
            if (formLogin) formLogin.classList.remove('active');
        });
    }

    // 1. Email/Password Login
    if (formLogin) {
        formLogin.addEventListener('submit', async (e) => {
            e.preventDefault();
            const submitBtn = formLogin.querySelector('button[type="submit"]');
            const email = formLogin.querySelector('input[type="email"]').value.trim();
            const password = formLogin.querySelector('input[type="password"]').value;
            
            if (submitBtn) submitBtn.classList.add('btn-loading');

            try {
                const userCredential = await signInWithEmailAndPassword(auth, email, password);
                notify(`Welcome back, ${userCredential.user.displayName || 'Player'}!`, 'success');
                setTimeout(() => {
                    window.location.href = 'account.html';
                }, 800);
            } catch (error) {
                let msg = error.message;
                if (error.code === 'auth/invalid-credential' || error.code === 'auth/wrong-password') {
                    msg = 'Incorrect email or password.';
                } else if (error.code === 'auth/user-not-found') {
                    msg = 'No account found with this email address.';
                }
                notify(msg, 'error');
            } finally {
                if (submitBtn) submitBtn.classList.remove('btn-loading');
            }
        });
    }

    // 2. Email/Password Signup
    if (formSignup) {
        formSignup.addEventListener('submit', async (e) => {
            e.preventDefault();
            const submitBtn = formSignup.querySelector('button[type="submit"]');
            const nameInput = formSignup.querySelector('input[type="text"]');
            const emailInput = formSignup.querySelector('input[type="email"]');
            const passwordInput = formSignup.querySelector('input[type="password"]');

            const name = nameInput ? nameInput.value.trim() : '';
            const email = emailInput ? emailInput.value.trim() : '';
            const password = passwordInput ? passwordInput.value : '';

            if (password.length < 6) {
                notify('Password must be at least 6 characters.', 'error');
                return;
            }

            if (submitBtn) submitBtn.classList.add('btn-loading');

            try {
                const userCredential = await createUserWithEmailAndPassword(auth, email, password);
                if (name) {
                    await updateProfile(userCredential.user, {
                        displayName: name,
                        photoURL: `https://ui-avatars.com/api/?name=${encodeURIComponent(name)}&background=1a4d2e&color=dfff00`
                    });
                }
                notify('Account created successfully! Entering locker room...', 'success');
                setTimeout(() => {
                    window.location.href = 'account.html';
                }, 800);
            } catch (error) {
                let msg = error.message;
                if (error.code === 'auth/email-already-in-use') {
                    msg = 'An account with this email already exists.';
                }
                notify(msg, 'error');
            } finally {
                if (submitBtn) submitBtn.classList.remove('btn-loading');
            }
        });
    }

    // 3. Google Sign-In
    if (btnGoogle) {
        btnGoogle.addEventListener('click', async () => {
            btnGoogle.classList.add('btn-loading');
            try {
                const result = await signInWithPopup(auth, googleProvider);
                notify(`Welcome, ${result.user.displayName || 'Player'}!`, 'success');
                setTimeout(() => {
                    window.location.href = 'account.html';
                }, 800);
            } catch (error) {
                if (error.code !== 'auth/popup-closed-by-user') {
                    notify(error.message, 'error');
                }
            } finally {
                btnGoogle.classList.remove('btn-loading');
            }
        });
    }

    // 4. Password Reset Modal Handling
    if (forgotPasswordLink && resetModal) {
        forgotPasswordLink.addEventListener('click', (e) => {
            e.preventDefault();
            resetModal.classList.add('active');
        });
    }

    if (resetModalClose && resetModal) {
        resetModalClose.addEventListener('click', () => {
            resetModal.classList.remove('active');
        });
    }

    if (resetForm) {
        resetForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const resetEmail = document.getElementById('reset-email').value.trim();
            const submitBtn = resetForm.querySelector('button[type="submit"]');

            if (submitBtn) submitBtn.classList.add('btn-loading');
            try {
                await sendPasswordResetEmail(auth, resetEmail);
                notify('Password reset email sent! Check your inbox.', 'success');
                if (resetModal) resetModal.classList.remove('active');
                resetForm.reset();
            } catch (error) {
                notify(error.message, 'error');
            } finally {
                if (submitBtn) submitBtn.classList.remove('btn-loading');
            }
        });
    }

    // 5. Global Auth State Observer
    onAuthStateChanged(auth, (user) => {
        const isAuthPage = window.location.pathname.endsWith('auth.html');
        
        // If user is signed in and is on auth.html, redirect to account
        if (user && isAuthPage) {
            window.location.href = 'account.html';
            return;
        }

        const loginBtns = document.querySelectorAll('.login-button, .login-trigger');
        const userProfiles = document.querySelectorAll('.user-profile, #user-profile');
        const userNames = document.querySelectorAll('#user-name, .header-user-name');
        const userPics = document.querySelectorAll('#user-pic, .header-user-pic');
        const logoutLinks = document.querySelectorAll('#logout-link, .logout-trigger');

        if (user) {
            const displayName = user.displayName || user.email.split('@')[0];
            const photoURL = user.photoURL || `https://ui-avatars.com/api/?name=${encodeURIComponent(displayName)}&background=1a4d2e&color=dfff00`;

            loginBtns.forEach(btn => btn.style.display = 'none');
            
            userProfiles.forEach(profile => {
                profile.style.display = 'inline-flex';
            });
            userNames.forEach(name => name.innerText = displayName);
            userPics.forEach(pic => {
                pic.src = photoURL;
                pic.alt = displayName;
            });
            logoutLinks.forEach(link => link.style.display = 'inline-block');
        } else {
            loginBtns.forEach(btn => btn.style.display = 'inline-flex');
            userProfiles.forEach(profile => profile.style.display = 'none');
            logoutLinks.forEach(link => link.style.display = 'none');
        }
    });

    // 6. Global Logout Handler
    document.addEventListener('click', async (e) => {
        if (e.target.id === 'logout-link' || e.target.closest('#logout-link') || e.target.classList.contains('logout-trigger')) {
            e.preventDefault();
            try {
                await signOut(auth);
                notify('Logged out successfully.', 'info');
                setTimeout(() => {
                    window.location.href = 'index.html';
                }, 500);
            } catch (error) {
                console.error("Logout failed", error);
            }
        }
    });
});
