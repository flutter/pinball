if (typeof firebase === 'undefined') throw new Error('hosting/init-error: Firebase SDK not detected. You must include it before /__/firebase/init.js');
firebase.initializeApp({
  "apiKey": "",
  "appId": "",
  "authDomain": "",
  "databaseURL": "",
  "measurementId": "",
  "messagingSenderId": "",
  "projectId": "",
  "storageBucket": ""
});