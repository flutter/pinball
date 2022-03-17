if (typeof firebase === 'undefined') throw new Error('hosting/init-error: Firebase SDK not detected. You must include it before /__/firebase/init.js');
firebase.initializeApp({
  "apiKey": "API_KEY",
  "appId": "APP_ID",
  "authDomain": "AUTH_DOMAIN",
  "databaseURL": "",
  "measurementId": "MEASUREMENT_ID",
  "messagingSenderId": "MEASUREMENT_SENDER_ID",
  "projectId": "PROJECT_ID",
  "storageBucket": "STORAGE_BUCKET"
});