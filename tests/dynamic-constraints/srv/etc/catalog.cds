using { cuid, Currency } from '@sap/cds/common';

context sap.ariba.catalog {

  entity Product : cuid { // = ProductDescription in Ariba CG
    name : String(111);
    descr : String(1111);
    price : Decimal(10,2);
    stock : Integer;
    suppliers : Association to many Suppliers;
  }

  entity Suppliers : cuid {
    name : String(111);
    contact : String(111);
    address : String(1111);
    currency : Currency;
  }

}
