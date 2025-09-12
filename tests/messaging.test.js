const cds = require('@sap/cds')
const { expect } = cds.test
cds.User.default = cds.User.Privileged // hard core monkey patch

describe('cap/samples - Messaging', ()=>{

  const _model = '@capire/reviews'
  const Reviews = 'sap.capire.reviews.Reviews'

  it ('should bootstrap sqlite in-memory db', async()=>{
    const db = await cds.deploy (_model) .to ('sqlite::memory:')
    await db.delete(Reviews)
    expect (db.model) .not.undefined
  })

  let ReviewsApp, ReviewsService
  it ('should serve ReviewsService', async()=>{
    await cds.serve('all') .from (_model)
    ReviewsApp = await cds.connect.to ('sap.capire.reviews.app.ReviewsService')
    ReviewsService = await cds.connect.to ('sap.capire.reviews.api.ReviewsService')
    expect (ReviewsApp) .to.exist
    expect (ReviewsService) .to.exist
  })

  let received=[], count=0
  it ('should add messaging event handlers', ()=>{
    ReviewsService.on('AverageRatings.Changed', (msg)=> received.push(msg))
  })

  it ('should add more messaging event handlers', ()=>{
    ReviewsService.on('AverageRatings.Changed', ()=> ++count)
  })

  it ('should add review', async ()=>{
    const review = { subject: '201', rating: 1 }
    const response = await ReviewsApp.create ('Reviews', review)
    expect (response) .to.containSubset (review)
  })

  it ('should add more reviews', ()=> Promise.all ([
    ReviewsApp.create ('Reviews', { subject: '201', reviewer: `Alice`, rating: 2 }),
    ReviewsApp.create ('Reviews', { subject: '201', reviewer: `Bob`,   rating: 3 }),
    ReviewsApp.create ('Reviews', { subject: '201', reviewer: `Carol`, rating: 4 }),
    ReviewsApp.create ('Reviews', { subject: '201', reviewer: `Dave`,  rating: 5 }),
  ]))

  it ('should have received all messages', async()=> {
    await new Promise((done)=>setImmediate(done))
    expect(count).equals(received.length).equals(5)
    expect(received.map(m=>m.data)).to.deep.equal([
      { subject: '201', reviews: 1, rating: 1.0 },
      { subject: '201', reviews: 2, rating: 1.5 },
      { subject: '201', reviews: 3, rating: 2.0 },
      { subject: '201', reviews: 4, rating: 2.5 },
      { subject: '201', reviews: 5, rating: 3.0 },
    ])
  })
})
