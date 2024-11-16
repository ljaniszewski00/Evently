import XCTest
@testable import Evently

@MainActor
final class EventListViewModelTests: XCTestCase {
    var sut: EventsListViewModel!
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_init_setsDefaultValues() {
        // given
        sut = makeSUT()
        
        // then
        XCTAssertTrue(sut.events.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.displayMode, .list)
        XCTAssertFalse(sut.showEventsSortingSheet)
        XCTAssertEqual(sut.selectedCountry, .poland)
    }
    
    func test_loadFirstEvents_withSuccess_loadsEvents() async {
        // given
        sut = makeSUT()
        
        // when
        await sut.loadFirstEvents()
        
        // then
        XCTAssertEqual(sut.events.count, 2)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_loadFirstEvents_withError_showsError() async {
        // given
        sut = makeSUTWithError()
        
        // when
        await sut.loadFirstEvents()
        
        // then
        XCTAssertTrue(sut.events.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.showError)
        XCTAssertEqual(sut.errorMessage, APIError.decodingError.rawValue)
        XCTAssertNotNil(sut.errorMessage)
    }
    
    func test_loadMoreEvents_withSuccess_appendsEvents() async {
        // given
        sut = makeSUT()
        
        // when
        await sut.loadFirstEvents()
        
        // then
        XCTAssertEqual(sut.events.count, 2)
        
        // when
        await sut.loadMoreEvents()
        
        // then
        XCTAssertEqual(sut.events.count, 4)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.showError)
    }
    
    func test_checkSortingStrategyIsChoosen_returnsCorrectValue() async {
        // given
        sut = makeSUT()
        let strategy: EventsSortingStrategy = (.name, .ascending)
        
        // when
        var result = sut.checkSortingStrategyIsChoosen(strategy)
        
        // then
        XCTAssertFalse(result)
        
        // when
        await sut.chooseEventsSortingStrategy(sortingKey: .name, sortingValue: .ascending)
        result = sut.checkSortingStrategyIsChoosen(strategy)
        
        // then
        XCTAssertTrue(result)
    }
    
    func test_toggleDisplayMode_changesDisplayMode() {
        // given
        sut = makeSUT()
        
        // when
        sut.toggleDisplayMode()
        
        // then
        XCTAssertEqual(sut.displayMode, .grid)
        
        // when
        sut.toggleDisplayMode()
        
        // then
        XCTAssertEqual(sut.displayMode, .list)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> EventsListViewModel {
        let apiClient = MockTicketmasterEventsAPIClientWithTwoEvents()
        return EventsListViewModel(apiClient: apiClient)
    }
    
    private func makeSUTWithError() -> EventsListViewModel {
        let apiClient = MockTicketmasterEventsAPIClientWithDecodingFailure()
        return EventsListViewModel(apiClient: apiClient)
    }
}
