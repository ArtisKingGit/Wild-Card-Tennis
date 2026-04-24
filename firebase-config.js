// Firebase Modular SDK Initialization
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getAuth, GoogleAuthProvider } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-analytics.js";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyCPrbu0PrkxhOo8Tc_dMNFq_aePaA1zNxI",
  authDomain: "cast-in-stone-productions.firebaseapp.com",
  databaseURL: "https://cast-in-stone-productions-default-rtdb.europe-west1.firebasedatabase.app",
  projectId: "cast-in-stone-productions",
  storageBucket: "cast-in-stone-productions.firebasestorage.app",
  messagingSenderId: "1034147733133",
  appId: "1:1034147733133:web:c16e18d095fabf8f768cc4",
  measurementId: "G-J2RYVX6ETT"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const googleProvider = new GoogleAuthProvider();
const analytics = getAnalytics(app);

export { auth, googleProvider, analytics };
