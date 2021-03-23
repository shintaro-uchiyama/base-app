import firebase from "../../support/firebase";

describe("Authentication test in index page", () => {
  beforeEach(() => {
    firebase
      .auth()
      .signInWithEmailAndPassword("test@example.com", "123456")
      .then(async (user) => {
        await user.user.delete();
        await firebase
          .auth()
          .createUserWithEmailAndPassword("test@example.com", "123456");
      })
      .catch(async (e) => {
        console.log("e: ", e);
        await firebase
          .auth()
          .createUserWithEmailAndPassword("test@example.com", "123456");
      });
  });

  it("Login by firebase authentication", () => {
    console.log("test start");
    cy.visit("/");
    cy.get("[data-cy=link-to-about]").click();
    cy.url().should("include", "/about");
  });
});
