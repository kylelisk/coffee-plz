import * as supertest from 'supertest'
import app from './CoffeeApp'

// Literally the most basic of tests lol
describe('App', () => {
    it('Runs!', () =>
        supertest(app)
            .get('/')
            .expect('Content-Type', /json/)
            .expect(200)
    )
})
