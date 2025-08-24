using { AdminService } from '@capire/bookshop';
namespace AdminService; //> for cds.entities

annotate AdminService with @odata.draft.enabled;
annotate AdminService with @requires: false;

extend AdminService.Authors with columns {
  // null as books // to simulate the exclusion of books
}

// Should be provided by CAP ootb:
extend AdminService.Books with columns {
  active : Association to AdminService.Books on active.ID = $self.ID,
}
