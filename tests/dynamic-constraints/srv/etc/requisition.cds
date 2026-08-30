
using { cuid } from '@sap/cds/common';
using { sap.ariba.catalog.Product, sap.ariba.catalog.Suppliers } from './catalog';

type Price : Decimal(10,2);

context sap.ariba.buying {

  entity Requisitions : cuid {
    buyer : String;
    Items : Composition of many LineItems on Items.parent = $self;
    totalPrice : Price;
  }

  entity LineItems {
    key parent : Association to Requisitions;
    key pos  : Integer;
    product  : Association to Product;
    supplier : Association to Suppliers; //
    quantity : Integer;
    // supplierCurrency : Currency;
  };

  // entity Product : sap.ariba.catalog.Product {
  //   product : Association to Product;
  // }
  entity Suppliers : sap.ariba.catalog.Suppliers {
    product : Association to Product;
  }

}
