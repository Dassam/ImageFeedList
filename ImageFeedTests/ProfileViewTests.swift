//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Dassam on 22.08.2023.
//

import XCTest
@testable import ImageFeedList

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        _ = viewController.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
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
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(profileService: ProfileServiceStub(), profileImageService: ProfileImageServiceStub())
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.updateProfileDetailsCalled)
        XCTAssertEqual(viewController.model?.name, "Jaan Prokofjev")
        XCTAssertEqual(viewController.model?.userName, "@yaansaanich")
        XCTAssertEqual(viewController.model?.description, "")
    }
    func testPresenterCallsShowAlert() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(
            profileService: ProfileServiceStub(),
            profileImageService: ProfileImageServiceStub())

        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.didTapLogoutButton()
        
        // then
        XCTAssertTrue(viewController.showAlertControllerCalled)
    }
    
    func testPresenterCallsSetAvatar() {
        // given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenter(
            profileService: ProfileServiceStub(),
            profileImageService: ProfileImageServiceStub())

        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        // then
        XCTAssertTrue(viewController.setAvatarCalled)
        XCTAssertEqual(viewController.url?.absoluteString, "example.com")
    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var removeObserverCalled = false
   
    func viewDidLoad() { viewDidLoadCalled = true }
    func viewWillAppear() {}
    func viewWillDisappear() {}
    func didTapLogoutButton() {}
}



final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    var showAlertControllerCalled = false
    var setAvatarCalled = false
    var updateProfileDetailsCalled = false
    var url: URL?
    var model: ProfileViewModel?

    func updateProfileDetails(with model: ProfileViewModel) {
        updateProfileDetailsCalled = true
        self.model = model
    }
    func showAlertController(_ alertController: UIAlertController) {
        showAlertControllerCalled = true
    }
    func setAvatar(_ url: URL) {
        setAvatarCalled = true
        self.url = url
    }
}

final class ProfileServiceStub: ProfileServiceProtocol {
    static var shared: ProfileServiceProtocol = ProfileServiceStub()
    var profile: ProfileResult? = ProfileResult(username: "yaansaanich",
                                                firstName: "Jaan",
                                                lastName: "Prokofjev",
                                                bio: "")
    
    func fetchProfile(_ token: String,
                      completion: @escaping (Result<ProfileResult, Error>) -> Void) {}
}

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    static var shared: ProfileImageServiceProtocol = ProfileImageServiceStub()
    var avatarURL: String? = "example.com"
    func fetchProfileImageURL(username: String,
                              completion: @escaping (Result<String, Error>) -> Void) {}
}
