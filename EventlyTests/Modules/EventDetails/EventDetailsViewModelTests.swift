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
    
    func test_whenLoadEventDetailsFromAPI_succeeds_thenUpdateEventDetails() async {
        // given
        sut = makeSUT()
        
        // then
        XCTAssertNil(sut.event)
        
        // given
        let expectation: XCTestExpectation = XCTestExpectation(description: "Data should be loaded")
        
        // when
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            expectation.fulfill()
        }
        
        // then
        await fulfillment(of: [expectation])
        XCTAssertEqual(sut.event, EventDetails.sampleEventDetails)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_whenEventDetailsLoaded_thenFormattedPropertiesAreCorrect() async {
        // given
        sut = makeSUT()
        let expectation: XCTestExpectation = XCTestExpectation(description: "Data should be loaded")
        
        // when
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            expectation.fulfill()
        }
        
        // then
        await fulfillment(of: [expectation])
        XCTAssertEqual(sut.eventImagesURLs, EventDetails.sampleEventDetails.images.map { $0.url })
        XCTAssertEqual(sut.eventClassificationFormatted,
                      "\(EventDetails.sampleEventDetails.classifications[0].segment.name) • \(EventDetails.sampleEventDetails.classifications[0].genre.name)")
        XCTAssertEqual(sut.eventDateTimeFormatted,
                      "\(EventDetails.sampleEventDetails.dateString!), \(EventDetails.sampleEventDetails.timeString!)")
        XCTAssertEqual(sut.eventPriceFormatted,
                      "\(String(format: "%.2f", EventDetails.sampleEventDetails.priceRanges![0].min)) \(EventDetails.sampleEventDetails.priceRanges![0].currency)")
        XCTAssertEqual(sut.eventSeatMapURL,
                      URL(string: EventDetails.sampleEventDetails.seatMap!.staticUrl))
    }
    
    // MARK: - Shared Cache Problem; Will success when executed separately; Will fail when executed with other tests simultaneously
    
    func test_whenLoadEventDetailsFromAPI_fails_thenShowError() async {
        // given
        sut = makeSUTWithError()
        let expectation: XCTestExpectation = XCTestExpectation(description: "Data should be loaded")
        
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
    
    // MARK: - Shared Cache Problem; Will success when executed separately; Will fail when executed with other tests simultaneously
    
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
        let apiClient = MockTicketmasterEventDetailsAPIClientWithSuccess()
        return EventDetailsViewModel(
            eventId: EventDetails.sampleEventDetails.id,
            apiClient: apiClient
        )
    }
    
    private func makeSUTWithError() -> EventDetailsViewModel {
        let apiClient = MockTicketmasterEventDetailsAPIClientWithDecodingFailure()
        return EventDetailsViewModel(
            eventId: EventDetails.sampleEventDetails.id,
            apiClient: apiClient
        )
    }
}
