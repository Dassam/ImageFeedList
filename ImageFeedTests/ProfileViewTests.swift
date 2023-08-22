//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Dassam on 22.08.2023.
//

import XCTest
@testable import ImageFeedList

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsAddObserver() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.addObserverCalled)
    }
    
    func testViewControllerCallsRemoveObserver() {
        // given
        var viewController: ProfileViewController? = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController?.presenter = presenter
        presenter.view = viewController
        
        // when
        viewController = nil
        
        // then
        XCTAssertTrue(presenter.removeObserverCalled)
    }
    
    func testConvertResultToViewModel() {
        // given
        let presenter = ProfileViewPresenter(profileService: StubProfileService.shared)
        
        // when
        let model = presenter.convertResultToViewModel()
        
        // then
        XCTAssertEqual(model?.name, "Jaan Prokofjev")
        XCTAssertEqual(model?.userName, "@yaansaanich")
        XCTAssertEqual(model?.description, "")
    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    var addObserverCalled = false
    var removeObserverCalled = false
    
    func addObserverForImageURL() { addObserverCalled = true }
    func removeObserverForImageURL() { removeObserverCalled = true }
    func cleanAndSwitchToSplashVC() {}
    func didTapLogoutButton() {}
    func convertResultToViewModel() -> ProfileViewModel? { return nil }
    func checkImageURL() {}
}

final class StubProfileService: ProfileServiceProtocol {
    static var shared: ProfileServiceProtocol = StubProfileService()
    var profile: ProfileResult? = ProfileResult(username: "yaansaanich",
                                                firstName: "Jaan",
                                                lastName: "Prokofjev",
                                                bio: "")
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {}
}
