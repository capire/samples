using { sap.capire.bookshop.Books } from '@capire/bookshop';

// Following are invariant constraints declared on domain model entity
annotate Books with {

  // manual two-step mandatory constraint
  title @assert: (case
    when title is null  then 'is missing'
    when trim(title)='' then 'must not be empty'
  end);

  // range check
  stock @assert: (case
    when stock < 0 then 'must not be negative'
  end);

  // range check
  price @assert: (case
    when price <= 0 or price > 500 then 'must be between 0 and 500'
   end);

  // assert target check
  genre @assert: (case
    when genre is not null and not exists genre then 'does not exist'
   end);

  // multiple constraints: mandatory + assert target + special
  author @assert: (case
    when author is null then 'is missing'
    when not exists author then 'does not exist'
  end);
}

// Following need to go on service-level entity, as rewriting would fail for CatalogService
annotate AdminService.Books with {

  author @assert: (case
    when sum(author.books.price) > 111 then author.name || ' already earned too much with his/her books'
    when count(author.books.ID) -1 > 1 then author.name || ' already wrote too many books'
    // FIXME: ^^^^^^^^^^^^^^^^ cqn4sql doesn't support count(author.books) yet
  end);

  price @assert: (case
    when price is null and exists author.books.genre[name = 'Drama']
    then 'Price must be specified for books by drama queens'
  end);
}
