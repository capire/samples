using { sap.capire.bookshop.Books } from '@capire/bookshop';


/**
 * Validation constraints for Books
 */
@validations aspect AdminService.Books.constraints.aspect : Books {

  // two-step mandatory check
  check_title = case
    when title is null  then 'is missing'
    when trim(title)='' then 'must not be empty'
  end;

  check_title2 = (
    title is null ? 'is missing' :
    trim(title)='' ? 'must not be empty' : null
  );

  // range check
  check_stock = stock < 0 ? 'must not be negative' : null;

  // range check
  check_price = price < 0 ? 'must not be negative' : null;

  // assert target check
  // check_genre = genre is not null and not exists genre ? 'does not exist' : null;

  // multiple constraints: mandatory + assert target + special
  check_author = case
    when author.ID is null then 'is missing' // FIXME: 1) // TODO: 2)
    // when not exists author then 'Author does not exist: ' || author.ID
    when count(author.books.ID) -1 > 1 then author.name || ' already wrote too many books' // TODO: 3)
    when /* exists */ author.books[genre.name like '%Noire%'] then 'Author has written a Noire book'
  end
}
