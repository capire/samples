//
// Quick and dirty implementation for cds.validate()
// using db-level constraints.
//

const cds = require('@sap/cds'); require('./validate.js')
cds.on('served', ()=> {
  const { AdminService } = cds.services
  AdminService.after (['CREATE','UPDATE'], (_,req) =>  cds.validate (req))
})



Object.defineProperties (cds.entity.prototype, {
  constraints: { get() { return cds.model.definitions[this.name+'.constraints'] }},
  controls: { get() { return cds.model.definitions[this.name+'.field.control'] }},
})
