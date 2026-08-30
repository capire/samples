const cds = require('@sap/cds')
const $super = { validate: cds.validate, skip(){} }


/**
 * Quick and dirty implementation for cds.validate() using db-level constraints.
 */
cds.validate = function (req) {
  if (req.is_entity) {
    const asserts = _collect_asserts4 (req); if (!asserts.length) return
    const vq = SELECT.from (req) .columns (asserts)
    return vq .then (_handle_results)
  }
  if (req instanceof cds.Request === false) return // $super.validate (...arguments)
  const vq = _validation_query4 (req)
  return vq .then (_handle_results)
}

function _validation_query4 (req) {
  let pk = _key_from_data (req)
  let constraints = cds.model.definitions [req.target.name + '.constraints']
  if (constraints) {
    const asserts = constraints.query.columns .filter (c => c.as[0] !== '_' && !((c.as || c.ref[0]) in pk))
    return SELECT.from (constraints, pk) .columns (asserts)
  } else {
    const asserts = _collect_asserts4 (req.target)
    return SELECT.from (req.target, pk) .columns (asserts)
  }
}

function _collect_asserts4 (entity) {
  const cols = []
  for (let e of entity.elements) {
    if (e.$struct) continue // skip structured elements
    let xpr = _asserts4 (e)
    if (xpr) cols.push({ xpr, as: e.name })
  }
  return cols
}

function _asserts4 (e) {
  let xpr = e?.['@assert']?.xpr; if (!xpr) return
  let inherited = _asserts4 (e.parent.__proto__.elements?.[e.name])
  if (inherited) xpr = [ ...inherited.slice(0,-1), ...xpr.slice(1) ]
  return xpr
}

function _handle_results (rows) {
  if (!Array.isArray(rows)) rows = [rows]
  return rows.map (checks => {
    const failed = {}; for (let c in checks)
      if (checks[c]) failed[c] = checks[c]
    if (Object.keys(failed).length) throw cds.error `Invalid input: ${failed}`
    return checks
  })
}

function _key_from_data (req) {
  const pk = {}
  for (let k in req.target.keys)
    if (k in req.data) pk[k] = req.data[k]
  return pk
}