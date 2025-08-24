using { sap.ariba.buying.Requisitions } from '../srv/etc/requisition';

annotate Requisitions with {
  buyer @assert: (buyer is null ? 'is missing' : null);
}
