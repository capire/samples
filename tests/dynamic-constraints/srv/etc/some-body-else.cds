using { sap.ariba.buying } from './requisition';
context other {

  aspect managed {
    createdBy: User @assert: (createdBy is not null ? null : 'is missing');
    createdAt: DateTime;
    lastModifiedBy: User;
    lastModifiedAt: DateTime;
  }

  type User : String;

  extend buying.Requisitions with managed;
  extend buying.Suppliers with managed;

}
