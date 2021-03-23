// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add('login', (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add('drag', { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add('dismiss', { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite('visit', (originalFn, url, options) => { ... })

import firebase from "firebase/app";
import "firebase/auth";

const config = {
    apiKey: Cypress.env('FIREBASE_API_KEY'),
};

if (!firebase.apps.length) {
    firebase.initializeApp(config);
}

if (process.env.NODE_ENV !== "production") {
    const auth = firebase.auth();
    auth.useEmulator(Cypress.env('FIREBASE_AUTH_EMULATOR_URL'));
}

export default firebase;
