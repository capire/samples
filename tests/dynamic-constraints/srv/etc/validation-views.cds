using { AdminService, sap.capire.bookshop as my } from '../admin-service';

// entity Books.drafts as projection on AdminService.Books;
// @cds.api.ignore view Books.drafts.constraints as select from AdminService.Books.drafts mixin {
//   before: Association to my.Books on before.ID = $self.ID;
//   base: Association to my.Books on base.ID = $self.ID;
// } into { ID, // FIXME: compiler should resolve Books without AdminService prefix
//   case
//     when title is null  then 'is missing'
//     when trim(title)='' then 'must not be empty'
//   end as title,
//   ...
// }

/**
 * Validation constraints for Books
 */
@validation view AdminService.Books.constraints as select from AdminService.Books mixin {
  base: Association to my.Books on base.ID = $self.ID // Should be provided by CAP ootb
} into {
  ID,

  // two-step mandatory check
  case
    when title is null  then 'is missing'
    when trim(title)='' then 'must not be empty'
  end as title,
  // the above is equivalent to:
  // title is null ? 'is missing' : trim(title)='' ? 'must not be empty' :

  // range check
  stock < 0 ? 'must not be negative' :
  null as stock,

  // range check
  price < 0 ? 'must not be negative' :
  null as price,

  // assert target check
  genre.ID is not null and not exists genre ? 'does not exist' :
  null as genre,

  genre.name as _genre,

  // multiple constraints: mandatory + assert target + special
  case
    when author.ID is null then 'is missing' // FIXME: 1) // TODO: 2)
    when not exists author then 'Author does not exist: ' || author.ID
    when sum(base.author.books.price) > 111 then author.name || ' already earned too much' // TODO: 3)
  end as author,

} group by ID; // because of the count(base.author.books) above

// 1) FIXME: expected author.ID to refer to foreign key,
// apparently that is not the case -> move one line up
// and run test to see the erroneous impact.

// 2) TODO: we should allow to write author is null instead of author.ID is null

// 3) TODO: we should support count(author.books)


/**
 * Validation constraints for Authors
 */
@validation view AdminService.Authors.constraints as select from AdminService.Authors { ID, // FIXME: compiler should resolve Authors without AdminService prefix

  // two-step mandatory check
  name = null ? 'is missing' : trim(name)='' ? 'must not be empty' :
  null as name,

  // constraint related to two fields
  dateOfDeath < dateOfBirth ? 'we can''t die before we are born' : null as _born_before_death, // reuse condition
  $self._born_before_death as dateOfBirth,
  $self._born_before_death as dateOfDeath,

}


annotate AdminService.Books.constraints with @cds.api.ignore @odata.draft.enabled: false;
