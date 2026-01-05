const cds = require("@sap/cds");
const { expect } = cds.test(
  "serve",
  "CatalogService",
  "--from",
  "@capire/bookshop,@capire/common",
  "--in-memory"
);

describe("Consuming actions locally", () => {
  let cats, CatalogService, Books, alice = { user: "alice" };
  const BOOK_ID = 251;
  const QUANTITY = 1;

  before("bootstrap the database", async () => {
    CatalogService = cds.services.CatalogService;
    expect(CatalogService).not.to.be.undefined;

    Books = CatalogService.entities.Books;
    expect(Books).not.to.be.undefined;

    cats = await cds.connect.to("CatalogService");
  });

  it("calls unbound actions - basic variant using srv.send", async () => {
    // Use a managed transaction to create a continuation with an authenticated user
    let p = cats.tx(alice, () => cats.send("submitOrder", { book: BOOK_ID, quantity: QUANTITY }))
    return expect(p).to.be.fulfilled
  });

  it("calls unbound actions - named args variant", async () => {
    // Use a managed transaction to create a continuation with an authenticated user
    let p = cats.tx(alice, () => cats.submitOrder({ book: BOOK_ID, quantity: QUANTITY }))
    return expect(p).to.be.fulfilled
  });

  it("calls unbound actions - positional args variant", async () => {
    // Use a managed transaction to create a continuation with an authenticated user
    let p = cats.tx(alice, () => cats.submitOrder(BOOK_ID, QUANTITY))
    return expect(p).to.be.fulfilled
  });
});
