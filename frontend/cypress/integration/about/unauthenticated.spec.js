describe("Unauthenticated test in about page", () => {
  it("Access to about page w/o authenticated", () => {
    cy.visit("/about");
    cy.url().should("include", "/");
  });
});
