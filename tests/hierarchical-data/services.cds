using { sap.capire.bookshop as my } from '@capire/bookshop';
service TestService {
  entity Genres as projection on my.Genres;
}
