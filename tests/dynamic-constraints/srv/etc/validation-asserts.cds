using { sap.capire.bookshop.Books } from '@capire/bookshop';

// @mandatory
// @readonly
// @hidden @visible @inapplicable

// @assert.range
// @assert.format
// @assert.target

// Following are invariant constraints declared on domain model entity
annotate Books with {

  // manual two-step mandatory constraint
  // title @assert.constraint: {
  //   not_null: { condition: (title is not null), message: 'is missing' },
  //   not_empty: { condition: (trim(title) != ''), message: 'must not be empty' },
  // };

  // manual two-step mandatory constraint
  title @assert: (case
    when title is null  then 'is missing'
    when trim(title)='' then 'must not be empty'
  end);

  // range check
  stock @assert: (case
    when stock <= 0 then 'must not a positive number'
  end);

  // range check
  price @assert: (case
    // when price is not null and not price between 0 and 500 then 'must be between 0 and 500'
    when price <= 0 or price > 500 then 'must be between 0 and 500'
  end);

  // assert target check
  // genre @assert: (case
  //   when genre is not null and not exists genre then 'does not exist'
  // end);

  genre @assert: (case
    when genre is null then null // genre may be null
    when not exists genre then 'does not exist'
  end);

  // multiple constraints: mandatory + assert target, ...
  author @assert: (case
    when author is null then 'is missing'
    when not exists author then 'does not exist'
  end);
}


// Following need to go on service-level entity, as rewriting would fail for CatalogService
annotate AdminService.Books with {

  // ... + special
  author @assert: (case
    when sum(author.books.price) > 111 then author.name || ' already earned too much with their books'
    when count(author.books.ID) -1 > 1 then author.name || ' already wrote too many books'
    // FIXME: ^^^^^^^^^^^^^^^^ cqn4sql doesn't support count(author.books) yet
  end);

  price @mandatory: (exists author.books.genre[name = 'Drama']);

  price @assert: (case
    when price is null and exists author.books.genre[name = 'Drama']
    then 'Price must be specified for books by drama queens'
  end);

}
