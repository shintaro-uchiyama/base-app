import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
} from "../../support/firebase";

describe("Authentication test in index page", () => {
  const email = "test@example.com";
  const password = "123456";

  beforeEach(() => {
    signInWithEmailAndPassword(email, password)
      .then(async (user) => {
        await user.user.delete();
        await createUserWithEmailAndPassword(email, password);
      })
      .catch(async (e) => {
        await createUserWithEmailAndPassword(email, password);
      });
  });

  it("Login by firebase authentication", () => {
    cy.visit("/");
    cy.get("[data-cy=link-to-about]").click();
    cy.url().should("include", "/about");

    cy.get("[data-cy=user-email]").should("contain", email);
  });
});
