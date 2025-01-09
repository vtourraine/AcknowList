//
// AcknowListViewController.swift
//
// Copyright (c) 2015-2025 Vincent Tourraine (https://www.vtourraine.net)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

#if os(iOS) || os(tvOS) || os(visionOS)
import UIKit
#endif

#if os(iOS) || os(visionOS)
import SafariServices
#endif

#if os(iOS) || os(tvOS) || os(visionOS)
/// Subclass of `UITableViewController` that displays a list of acknowledgements.
@available(iOS 9.0.0, tvOS 9.0.0, visionOS 1.0.0, *)
@available(iOSApplicationExtension, unavailable)
open class AcknowListViewController: UITableViewController {

    /// The represented array of `Acknow`.
    open var acknowledgements: [Acknow] = []

    /// Indicates if the view controller should try to fetch missing licenses from the GitHub API.
    open var canFetchLicenseFromGitHub = true

    /**
     Header text to be displayed above the list of the acknowledgements.
     It needs to get set before `viewDidLoad` gets called.
     Its value can be defined in the header of the plist file.
     */
    @IBInspectable open var headerText: String?

    /**
     Footer text to be displayed below the list of the acknowledgements.
     It needs to get set before `viewDidLoad` gets called.
     Its value can be defined in the header of the plist file.
     */
    @IBInspectable open var footerText: String?

    /**
     Acknowledgements plist file name whose contents to be loaded.
     It expects to get set by "User Defined Runtime Attributes" in Interface Builder.
     */
    @IBInspectable var acknowledgementsPlistName: String?


    // MARK: - Initialization

    /**
     Initializes the `AcknowListViewController` instance based on default configuration.
     - Returns: The new `AcknowListViewController` instance.
     */
    public init() {
        super.init(style: .grouped)
        title = AcknowLocalization.localizedTitle()

        if let acknowList = AcknowParser.defaultAcknowList() {
            configure(with: acknowList)
        }
    }

    /**
     Initializes the `AcknowListViewController` instance with the content of a plist file based on its name.
     - Parameters fileName: Name of the acknowledgements plist file
     - Returns: The new `AcknowListViewController` instance.
     */
    public convenience init(fileNamed fileName: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: AcknowParser.K.DefaultPods.fileExtension) {
            self.init(plistFileURL: url)
        }
        else {
            self.init()
        }
    }

    /**
     Initializes the `AcknowListViewController` instance with the content of a plist file based on its path.
     - Parameters:
        - plistFileURL: The URL to the acknowledgements plist file.
        - style: `UITableView.Style` to apply to the table view. **Default:** `.grouped`
     - Returns: The new `AcknowListViewController` instance.
     */
    public init(plistFileURL: URL, style: UITableView.Style = .grouped) {
        super.init(style: style)
        title = AcknowLocalization.localizedTitle()

        if let data = try? Data(contentsOf: plistFileURL),
           let acknowList = try? AcknowPodDecoder().decode(from: data) {
            configure(with: acknowList)
        }
    }

    /**
     Initializes the `AcknowListViewController` instance with an array of `Acknow`.
     - Parameters:
        - acknowledgements: The array of `Acknow`.
        - style: `UITableView.Style` to apply to the table view. **Default:** `.grouped`
     - Returns: The new `AcknowListViewController` instance.
     */
    public init(acknowledgements: [Acknow], style: UITableView.Style = .grouped) {
        super.init(style: style)
        title = AcknowLocalization.localizedTitle()
        self.acknowledgements = acknowledgements
    }

    /**
     Initializes the `AcknowListViewController` instance with a coder.
     - Parameter coder: The archive coder.
     - Returns: The new `AcknowListViewController` instance.
     */
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        title = AcknowLocalization.localizedTitle()
    }

    // MARK: - View life cycle

#if !os(visionOS)
    /// Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
    override open func awakeFromNib() {
        super.awakeFromNib()

        if let plistName = acknowledgementsPlistName,
           let url = Bundle.main.url(forResource: plistName, withExtension: AcknowParser.K.DefaultPods.fileExtension),
           let data = try? Data(contentsOf: url),
           let acknowList = try? AcknowPodDecoder().decode(from: data) {
            configure(with: acknowList)
        }
        else if let defaultAcknowList = AcknowParser.defaultAcknowList() {
            configure(with: defaultAcknowList)
        }
    }
#endif

    /// Called after the controller's view is loaded into memory.
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Register the cell before use it
        let identifier = String(describing: UITableViewCell.self)
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
        tableView.cellLayoutMarginsFollowReadableWidth = true

        if let navigationController = navigationController {
            if presentingViewController != nil && navigationController.viewControllers.first == self {
                let item = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AcknowListViewController.dismissViewController(_:)))
                navigationItem.leftBarButtonItem = item
            }
        }
    }

    /**
     Notifies the view controller that its view is about to be added to a view hierarchy.
     - Parameter animated: If `YES`, the view is being added to the window using an animation.
     */
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureHeaderView()
        configureFooterView()

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }

    /**
     Notifies the view controller that its view was added to a view hierarchy.
     - Parameter animated: If `YES`, the view is being added to the window using an animation.
     */
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if acknowledgements.isEmpty {
            print(
                "** AcknowList Warning **\n" +
                "No acknowledgements found.\n" +
                "This probably means that you didn’t import the `Pods-###-acknowledgements.plist` to your main target.\n" +
                "Please take a look at https://github.com/vtourraine/AcknowList for instructions.", terminator: "\n")
        }
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil) { _ in
            self.configureHeaderView()
            self.configureFooterView()
        }
    }

    // MARK: - Actions

    /**
     Opens a link with Safari.
     - Parameter sender: The event sender, a gesture recognizer attached to the label containing the link URL.
     */
    @IBAction open func openLink(_ sender: UIGestureRecognizer) {
        guard let label = sender.view as? UILabel,
            let text = label.text,
            let url = AcknowParser.firstLink(in: text) else {
            return
        }

        url.openWithDefaultBrowser()
    }

    /**
     Dismisses the view controller.
     - Parameter sender: The event sender.
     */
    @IBAction open func dismissViewController(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Configuration

    let LabelMargin: CGFloat = 20
    let FooterBottomMargin: CGFloat = 20

    func configure(with acknowList: AcknowList) {
        acknowledgements = AcknowLocalization.sorted(acknowList.acknowledgements)

        if let header = acknowList.headerText, header != AcknowPodDecoder.K.DefaultHeaderText, !header.isEmpty {
            headerText = header
        }

        if acknowList.footerText == AcknowPodDecoder.K.DefaultFooterText, footerText == nil {
            footerText = AcknowLocalization.localizedCocoaPodsFooterText()
        }
        else if let footer = acknowList.footerText, !footer.isEmpty, footerText == nil {
            footerText = footer
        }
    }

    func headerFooterLabel(frame: CGRect, font: UIFont, text: String?) -> UILabel {
        let label = UILabel(frame: frame)
        label.text = text
        label.font = font
        if #available(iOS 13.0, tvOS 13.0, *) {
            label.textColor = .secondaryLabel
        }
        else {
            label.textColor = .gray
        }
        label.numberOfLines = 0
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]

        if #available(iOS 10.0, tvOS 10.0, *) {
            label.adjustsFontForContentSizeCategory = true
        }

        if let text = text, AcknowParser.firstLink(in: text) != nil {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AcknowListViewController.openLink(_:)))
            label.addGestureRecognizer(tapGestureRecognizer)
            label.isUserInteractionEnabled = true
        }

        return label
    }

    func configureHeaderView() {
        let font = UIFont.preferredFont(forTextStyle: .footnote)
        let labelWidth = view.frame.width - 2 * LabelMargin

        guard let text = headerText else {
            return
        }

        let labelHeight = heightForLabel(text: text as NSString, width: labelWidth)
        let labelFrame = CGRect(x: LabelMargin, y: LabelMargin, width: labelWidth, height: labelHeight)
        let label = headerFooterLabel(frame: labelFrame, font: font, text: text)
        let headerFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: label.frame.height + 2 * LabelMargin)
        let headerView = UIView(frame: headerFrame)
        headerView.isUserInteractionEnabled = label.isUserInteractionEnabled
        headerView.addSubview(label)

        tableView.tableHeaderView = headerView
    }

    func configureFooterView() {
        let font = UIFont.preferredFont(forTextStyle: .footnote)
        let labelWidth = view.frame.width - 2 * LabelMargin

        guard let text = footerText else {
            return
        }

        let labelHeight = heightForLabel(text: text as NSString, width: labelWidth)
        let labelFrame = CGRect(x: LabelMargin, y: 0, width: labelWidth, height: labelHeight);
        let label = headerFooterLabel(frame: labelFrame, font: font, text: text)

        let footerHeight: CGFloat
        let labelOriginY: CGFloat
        if tableView.style == .plain {
            // “Plain” table views need additional margin between the bottom of the last row and the top of the footer label.
            labelOriginY = FooterBottomMargin
            footerHeight = label.frame.height + FooterBottomMargin * 2
        }
        else {
            labelOriginY = 0
            footerHeight = label.frame.height + FooterBottomMargin
        }

        let footerFrame = CGRect(x: 0, y: 0, width: label.frame.width, height: footerHeight)
        let footerView = UIView(frame: footerFrame)
        footerView.isUserInteractionEnabled = label.isUserInteractionEnabled
        footerView.addSubview(label)
        label.frame = CGRect(x: 0, y: labelOriginY, width: label.frame.width, height: label.frame.height);

        tableView.tableFooterView = footerView
    }

    func heightForLabel(text labelText: NSString, width labelWidth: CGFloat) -> CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .footnote)
        let options: NSStringDrawingOptions = NSStringDrawingOptions.usesLineFragmentOrigin
        // should be (NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin)?
        let labelBounds: CGRect = labelText.boundingRect(with: CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude), options: options, attributes: [NSAttributedString.Key.font: font], context: nil)
        let labelHeight = labelBounds.height

        return CGFloat(ceilf(Float(labelHeight)))
    }

    // MARK: - Table view data source

    /**
     Asks the data source to return the number of sections in the table view.
     - Parameter tableView: An object representing the table view requesting this information.
     - Returns: The number of sections in `tableView`. The default value is 1.
     */
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acknowledgements.count
    }

    /**
     Asks the data source for a cell to insert in a particular location of the table view.
     - Parameters:
        - tableView: The table-view object requesting the cell.
        - indexPath: An index path that locates a row in `tableView`.
     - Returns: An object inheriting from `UITableViewCell` that the table view can use for the specified row. An assertion is raised if you return `nil`.
     */
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: UITableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        if let acknowledgement = acknowledgements[(indexPath as NSIndexPath).row] as Acknow?,
           let textLabel = cell.textLabel as UILabel? {
            textLabel.text = acknowledgement.title
            if canOpen(acknowledgement) {
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default
            }
            else {
                cell.accessoryType = .none
                cell.selectionStyle = .none
            }
        }

        return cell
    }

    // MARK: Table view delegate

    /**
     Tells the delegate that the specified row is now selected.
     - Parameters:
        - tableView: A table-view object informing the delegate about the new row selection.
        - indexPath: An index path locating the new selected row in `tableView`.
     */
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let acknowledgement = acknowledgements[indexPath.row] as Acknow?,
           let navigationController = navigationController {
            if acknowledgement.text != nil {
                let viewController = AcknowViewController(acknowledgement: acknowledgement)
                navigationController.pushViewController(viewController, animated: true)
            }
            else if canFetchLicenseFromGitHub,
                    let repository = acknowledgement.repository,
                    GitHubAPI.isGitHubRepository(repository) {
                GitHubAPI.getLicense(for: repository) { [weak self] result in
                    switch result {
                    case .success(let text):
                        let updatedAcknowledgement = Acknow(title: acknowledgement.title, text: text, license: acknowledgement.license, repository: acknowledgement.repository)
                        self?.acknowledgements[indexPath.row] = updatedAcknowledgement
                        let viewController = AcknowViewController(acknowledgement: updatedAcknowledgement)
                        navigationController.pushViewController(viewController, animated: true)

                    case .failure:
                        self?.openRepository(repository)
                    }
                }
            }
            else if let repository = acknowledgement.repository {
                openRepository(repository)
            }
        }
    }

    /**
     Asks the delegate for the estimated height of a row in a specified location.
     - Parameters:
        - tableView: The table-view object requesting this information.
        - indexPath: An index path that locates a row in `tableView`.
     - Returns: A nonnegative floating-point value that estimates the height (in points) that `row` should be. Return `UITableViewAutomaticDimension` if you have no estimate.
     */
    open override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    // MARK: - Navigation

    private func canOpen(_ acknowledgement: Acknow) -> Bool {
        if acknowledgement.text != nil {
            return true
        }
        else if let repository = acknowledgement.repository {
            return canOpenRepository(repository)
        }
        else {
            return false
        }
    }

    private func canOpenRepository(_ repository: URL) -> Bool {
        guard let scheme = repository.scheme else {
            return false
        }

        return scheme == "http" || scheme == "https"
    }

    private func openRepository(_ repository: URL) {
        if canOpenRepository(repository) {
#if os(visionOS)
            UIApplication.shared.open(repository)
#elseif !os(tvOS)
            let safariViewController = SFSafariViewController(url: repository)
            present(safariViewController, animated: true)
#endif
        }
    }
}

#endif
