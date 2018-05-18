//
// Copyright (C) 2016-present Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
    
    

import UIKit





import CanvasCore

typealias SettingsSessionAction = (_ session: Session)->Void
typealias SettingsObserveeSelectedAction = (_ session: Session, _ observee: Student)->Void

class SettingsViewController: UIViewController {
    
    // ---------------------------------------------
    // MARK: - IBOutlets
    // ---------------------------------------------
    var logoutButton: UIBarButtonItem?
    var closeButton: UIBarButtonItem?
    var addButton: UIBarButtonItem?
    @IBOutlet weak var observeesContainerView: UIView!

    var backgroundView: TriangleBackgroundGradientView!
    
    let reuseIdentifier = "SettingsObserveesCell"
    
    // ---------------------------------------------
    // MARK: - ViewModel
    // ---------------------------------------------
    var viewModel: SettingsViewModel!
    var observeesViewController: StudentsListViewController?
    
    // ---------------------------------------------
    // MARK: - External Closures
    // ---------------------------------------------
    var closeAction: SettingsSessionAction? = nil
    var logoutAction: SettingsSessionAction? = nil
    var addObserveeAction: SettingsSessionAction? = nil
    var viewGuidesAction: SettingsSessionAction? = nil
    var reportProblemAction: SettingsSessionAction? = nil
    var requestFeatureAction: SettingsSessionAction? = nil
    var allObserveesAction: SettingsSessionAction? = nil
    var observeeSelectedAction: SettingsObserveeSelectedAction? = nil
    
    // ---------------------------------------------
    // MARK: - Initializers
    // ---------------------------------------------
    fileprivate static let defaultStoryboardName = "SettingsViewController"
    static func new(_ storyboardName: String = defaultStoryboardName, session: Session) -> SettingsViewController {
        guard let controller = UIStoryboard(name: storyboardName, bundle: Bundle(for: self)).instantiateInitialViewController() as? SettingsViewController else {
            fatalError("Initial ViewController is not of type SettingsViewController")
        }

        controller.viewModel = SettingsViewModel(session: session)
        controller.observeesViewController = try! StudentsListViewController(session: session)
        controller.observeesViewController?.selectStudentAction = { [weak controller] session, student in
            controller?.observeeSelectedAction?(session, student)
        }
        
        return controller
    }
    
    // ---------------------------------------------
    // MARK: - LifeCycle
    // ---------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        setupObserveeList()

        self.title = NSLocalizedString("Manage Students", comment: "Title of the manage students screen. This screen is used to add/remove students that a parent is observing.")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    // ---------------------------------------------
    // MARK: - View Setup
    // ---------------------------------------------
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        setupCloseButton()
        setupRightNavigationItem()
        if let navBar = self.navigationController?.navigationBar as? TriangleGradientNavigationBar {
            let scheme = ColorCoordinator.colorSchemeForParent()
            navBar.transitionToColors(scheme.tintTopColor, bottomTintColor: scheme.tintBottomColor)
        }
    }

    func setupRightNavigationItem() {
        setupAddButton()
        guard let addButton = addButton else { return }
        self.navigationItem.rightBarButtonItems = [addButton]
    }

    func setupAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(SettingsViewController.addButtonPressed(_:)))
        addButton.accessibilityLabel = NSLocalizedString("Add Student", comment: "Add Student Settings Button Title")
        addButton.accessibilityIdentifier = "add_observee_button"
        addButton.tintColor = UIColor.white

        self.addButton = addButton
    }

    func setupCloseButton() {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(SettingsViewController.closeButtonPressed(_:)))
        closeButton.accessibilityLabel = NSLocalizedString("Close", comment: "Close Button Title")
        closeButton.accessibilityIdentifier = "close_button"
        closeButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = closeButton

        self.closeButton = closeButton
    }

    func setupObserveeList() {
        guard let observeesViewController = observeesViewController else {
            return
        }

        observeesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        observeesViewController.willMove(toParentViewController: self)
        addChildViewController(observeesViewController)
        observeesContainerView.addSubview(observeesViewController.view)
        observeesViewController.didMove(toParentViewController: self)
        observeesContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": observeesViewController.view]))
        observeesContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": observeesViewController.view]))
    }

    // ---------------------------------------------
    // MARK: - Actions
    // ---------------------------------------------
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        closeAction?(viewModel.session)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        addObserveeAction?(viewModel.session)
    }
    
    func addObservee() {
        addObserveeAction?(viewModel.session)
    }
}
