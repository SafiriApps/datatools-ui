/* globals afterEach, beforeEach, describe, expect, it, jest */

import nock from 'nock'

import {polyline} from '../valhalla'

describe('scenario-editor > utils > valhalla >', () => {
  let consoleWarnSpy
  let originalGraphHopperPointLimit

  beforeEach(() => {
    consoleWarnSpy = jest.spyOn(console, 'warn').mockImplementation(() => {})
    originalGraphHopperPointLimit = process.env.GRAPH_HOPPER_POINT_LIMIT
  })

  afterEach(() => {
    consoleWarnSpy.mockRestore()
    nock.cleanAll()
    if (originalGraphHopperPointLimit) {
      process.env.GRAPH_HOPPER_POINT_LIMIT = originalGraphHopperPointLimit
    } else {
      delete process.env.GRAPH_HOPPER_POINT_LIMIT
    }
  })

  it('falls back to straight individual legs without dropping the final stop', async () => {
    process.env.GRAPH_HOPPER_POINT_LIMIT = '5'
    nock('https://graphhopper.com')
      .get(/\/api\/1\/route.*/)
      .times(12)
      .reply(200, {paths: []})

    const points = Array.from({length: 10}, (_, i) => ({
      lat: i + 0.25,
      lng: i
    }))

    const result = await polyline(points, true)

    expect(result).toHaveLength(points.length - 1)
    expect(result[0]).toEqual([[0, 0.25], [1, 1.25]])
    expect(result[result.length - 1]).toEqual([[8, 8.25], [9, 9.25]])
    expect(nock.isDone()).toBe(true)
  })
})
