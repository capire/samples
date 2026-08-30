using { AdminService } from './admin-service';

@fieldcontrol view AdminService.Books.field.control as select from AdminService.Books { ID,
  genre.name == 'Drama' ? 'readonly' :
  null as price
}

// Make that available to Fiori clients
extend AdminService.Books with columns {
  fc : Association to AdminService.Books.field.control on fc.ID = $self.ID
}
