import XCTest
@testable import Evently

@MainActor
final class EventDetailsViewModelTests: XCTestCase {
    var sut: EventDetailsViewModel!
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_whenLoadEventDetailsFromCache_succeeds_thenUpdateEventDetails() async {
        // given
        sut = makeSUT()
        
        // then
        XCTAssertNil(sut.event)
        
        // given
        let expectation: XCTestExpectation = XCTestExpectation(description: "Data should be loaded from cache")
        
        // when
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            expectation.fulfill()
        }
        
        // then
        await fulfillment(of: [expectation])
        XCTAssertEqual(sut.event, EventDetails.secondSampleEventDetails)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_loadEventDetailsFromAPI_overwrites_eventDetailsFromCache() async {
        // given
        sut = makeSUT()
        let expectation: XCTestExpectation = XCTestExpectation(description: "Data should be loaded from cache")
        
        // when
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            expectation.fulfill()
        }
        
        // then
        await fulfillment(of: [expectation])
        XCTAssertEqual(sut.event, EventDetails.secondSampleEventDetails)
        
        // when
        await sut.loadEventDetailsFromAPI()
        
        // then
        XCTAssertEqual(sut.event, EventDetails.sampleEventDetails)
    }
    
    func test_whenEventDetailsLoaded_thenFormattedPropertiesAreCorrect() async {
        // given
        sut = makeSUT()
        let expectation: XCTestExpectation = XCTestExpectation(description: "Data should be loaded from cache")
        
        // when
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            expectation.fulfill()
        }
        
        // then
        await fulfillment(of: [expectation])
        XCTAssertEqual(sut.eventImagesURLs, EventDetails.secondSampleEventDetails.images.map { $0.url })
        XCTAssertEqual(sut.eventClassificationFormatted,
                      "\(EventDetails.secondSampleEventDetails.classifications[0].segment.name) • \(EventDetails.secondSampleEventDetails.classifications[0].genre.name)")
        XCTAssertEqual(sut.eventDateTimeFormatted,
                      "\(EventDetails.secondSampleEventDetails.dateString!), \(EventDetails.secondSampleEventDetails.timeString!)")
        XCTAssertEqual(sut.eventPriceFormatted,
                      "\(String(format: "%.2f", EventDetails.secondSampleEventDetails.priceRanges![0].min)) \(EventDetails.secondSampleEventDetails.priceRanges![0].currency)")
        XCTAssertEqual(sut.eventSeatMapURL,
                      URL(string: EventDetails.secondSampleEventDetails.seatMap!.staticUrl))
    }
    
    func test_whenLoadEventDetailsFromAPI_fails_thenShowError() async {
        // given
        sut = makeSUTWithError()
        let expectation: XCTestExpectation = XCTestExpectation(description: "Data should not be loaded")
        
        // when
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            expectation.fulfill()
        }
        
        // then
        await fulfillment(of: [expectation])
        XCTAssertTrue(sut.showError)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.event)
    }
    
    func test_whenNoEventData_thenFormattedPropertiesAreNilOrEmpty() {
        // given
        sut = makeSUTWithError()
        
        // then
        XCTAssertEqual(sut.eventImagesURLs, [""])
        XCTAssertNil(sut.eventClassificationFormatted)
        XCTAssertNil(sut.eventDateTimeFormatted)
        XCTAssertNil(sut.eventPriceFormatted)
        XCTAssertNil(sut.eventSeatMapURL)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> EventDetailsViewModel {
        let apiClient: TicketmasterEventDetailsAPIClientProtocol = MockTicketmasterEventDetailsAPIClientWithSuccess()
        let cacheManager: EventDetailsCacheManaging = MockFilledEventDetailsCacheManager()
        
        return EventDetailsViewModel(
            eventId: EventDetails.sampleEventDetails.id,
            apiClient: apiClient,
            cacheManager: cacheManager
        )
    }
    
    private func makeSUTWithError() -> EventDetailsViewModel {
        let apiClient: TicketmasterEventDetailsAPIClientProtocol = MockTicketmasterEventDetailsAPIClientWithDecodingFailure()
        let cacheManager: EventDetailsCacheManaging = MockEmptyEventDetailsCacheManager()
        
        return EventDetailsViewModel(
            eventId: EventDetails.sampleEventDetails.id,
            apiClient: apiClient,
            cacheManager: cacheManager
        )
    }
}
