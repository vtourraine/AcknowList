//
// AcknowListViewController.swift
//
// Copyright (c) 2015-2018 Vincent Tourraine (http://www.vtourraine.net)
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

import UIKit

/// Subclass of `UITableViewController` that displays a list of acknowledgements.
open class AcknowListViewController: UITableViewController {

    /// The represented array of `Acknow`.
    open var acknowledgements: [Acknow]?

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

    /// Display attributes for the views title text.
    open var titleTextAttributes: [NSAttributedString.Key : Any]?

    /// Display attributes for the views footer text.
    open var footerTextAttributes: [NSAttributedString.Key : Any]?

    /// The views background color.
    open var backgroundColor: UIColor?

    /// The table cells background color.
    open var licenceCellBackgroundColor: UIColor?

    /// The color to use as a virtual light source on the selected table cell.
    open var licenceCellHighlightColor: UIColor?

    /// The font used to display the library name.
    open var licenceCellFont: UIFont?

    /// The font color used to display the library name.
    open var licenceCellFontColor: UIColor?

    /// The highlight font color used to display the library name.
    open var licenceCellFontHighlightColor: UIColor?

    /// The background color of the licence detail view.
    open var licenceDetailViewBackgroundColor: UIColor?

    /// The font of the licence detail view.
    open var licenceDetailViewFont: UIFont?

    /// The font color of the licence detail view.
    open var licenceDetailViewFontColor: UIColor?

    /// Determines if the table cell should be customized.
    private var isLicenceCellCustomized: Bool {
        return licenceCellBackgroundColor != nil || licenceCellHighlightColor != nil || licenceCellFont != nil || licenceCellFontColor != nil || licenceCellFontHighlightColor != nil
    }

    // MARK: - Initialization

    /**
     Initializes the `AcknowListViewController` instance based on default configuration.

     - returns: The new `AcknowListViewController` instance.
     */
    public convenience init() {
        let path = AcknowListViewController.defaultAcknowledgementsPlistPath()
        self.init(acknowledgementsPlistPath: path)
    }

    /**
     Initializes the `AcknowListViewController` instance for the plist file based on its name.

     - returns: The new `AcknowListViewController` instance.
     */
    public convenience init(fileNamed fileName: String) {
        let path = AcknowListViewController.acknowledgementsPlistPath(name: fileName)
        self.init(acknowledgementsPlistPath: path)
    }

    /**
     Initializes the `AcknowListViewController` instance for a plist file path.

     - parameter acknowledgementsPlistPath: The path to the acknowledgements plist file.

     - returns: The new `AcknowListViewController` instance.
     */
    public init(acknowledgementsPlistPath: String?) {
        super.init(style: .grouped)

        if let acknowledgementsPlistPath = acknowledgementsPlistPath {
            self.commonInit(acknowledgementsPlistPaths: [acknowledgementsPlistPath])
        }
        else {
            self.commonInit(acknowledgementsPlistPaths: [])
        }
    }

    /**
     Initializes the `AcknowListViewController` instance for a set of plist file paths.

     The first path is the "main" one which will be used for any custom header/footer.

     - parameter acknowledgementsPlistPaths: The paths to the acknowledgements plist files.

     - returns: The new `AcknowListViewController` instance.
     */
    public init(acknowledgementsPlistPaths: [String]) {
        super.init(style: .grouped)
        self.commonInit(acknowledgementsPlistPaths: acknowledgementsPlistPaths)
    }

    /**
     Initializes the `AcknowListViewController` instance with a coder.

     - parameter aDecoder: The archive coder.

     - returns: The new `AcknowListViewController` instance.
     */
    public required init(coder aDecoder: NSCoder) {
        super.init(style: .grouped)
        let path = AcknowListViewController.defaultAcknowledgementsPlistPath()
        if let path = path {
            self.commonInit(acknowledgementsPlistPaths: [path])
        }
        else {
            self.commonInit(acknowledgementsPlistPaths: [])
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    func commonInit(acknowledgementsPlistPaths: [String]) {
        self.title = AcknowLocalization.localizedTitle()

        guard !acknowledgementsPlistPaths.isEmpty else { return }

        if let mainPlistPath = acknowledgementsPlistPaths.first {
            let parser = AcknowParser(plistPath: mainPlistPath)
            let headerFooter = parser.parseHeaderAndFooter()

            let DefaultHeaderText = "This application makes use of the following third party libraries:"
            let DefaultFooterText = "Generated by CocoaPods - https://cocoapods.org"
            let DefaultFooterTextLegacy = "Generated by CocoaPods - http://cocoapods.org"

            if (headerFooter.header == DefaultHeaderText) {
                self.headerText = nil
            }
            else if (headerFooter.header != "") {
                self.headerText = headerFooter.header
            }

            if (headerFooter.footer == DefaultFooterText || headerFooter.footer == DefaultFooterTextLegacy) {
                self.footerText = AcknowLocalization.localizedCocoaPodsFooterText()
            }
            else if (headerFooter.footer != "") {
                self.footerText = headerFooter.footer
            }
        }

        var acknowledgements: [Acknow] = []
        for path in acknowledgementsPlistPaths {
            let parser = AcknowParser(plistPath: path)
            acknowledgements.append(contentsOf: parser.parseAcknowledgements())
        }

        let sortedAcknowledgements = acknowledgements.sorted(by: {
            (ack1: Acknow, ack2: Acknow) -> Bool in
            let result = ack1.title.compare(
                ack2.title,
                options: [],
                range: nil,
                locale: Locale.current)
            return (result == ComparisonResult.orderedAscending)
        })
        self.acknowledgements = sortedAcknowledgements
    }

    // MARK: - Paths

    class func acknowledgementsPlistPath(name:String) -> String? {
        return Bundle.main.path(forResource: name, ofType: "plist")
    }

    class func defaultAcknowledgementsPlistPath() -> String? {
        guard let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return nil
        }

        let defaultAcknowledgementsPlistName = "Pods-\(bundleName)-acknowledgements"
        let defaultAcknowledgementsPlistPath = self.acknowledgementsPlistPath(name: defaultAcknowledgementsPlistName)

        if let defaultAcknowledgementsPlistPath = defaultAcknowledgementsPlistPath,
            FileManager.default.fileExists(atPath: defaultAcknowledgementsPlistPath) == true {
            return defaultAcknowledgementsPlistPath
        }
        else {
            // Legacy value
            return self.acknowledgementsPlistPath(name: "Pods-acknowledgements")
        }
    }

    // MARK: - View life cycle

    /// Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
    override open func awakeFromNib() {
        super.awakeFromNib()

        let path: String?
        if let acknowledgementsPlistName = self.acknowledgementsPlistName {
            path = AcknowListViewController.acknowledgementsPlistPath(name: acknowledgementsPlistName)
        }
        else {
            path = AcknowListViewController.defaultAcknowledgementsPlistPath()
        }

        if let path = path {
            self.commonInit(acknowledgementsPlistPaths: [path])
        }
    }

    /// Called after the controller's view is loaded into memory.
    open override func viewDidLoad() {
        super.viewDidLoad()

        self.configureHeaderView()
        self.configureFooterView()

        if let navigationController = self.navigationController {

            if let textAttributes = self.titleTextAttributes {
                navigationController.navigationBar.titleTextAttributes = textAttributes
            }

            if let backgroundColor = self.backgroundColor {
                self.tableView.backgroundColor = backgroundColor
            }

            if self.presentingViewController != nil &&
                navigationController.viewControllers.first == self {
                let item = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AcknowListViewController.dismissViewController(_:)))
                    self.navigationItem.leftBarButtonItem = item
            }
        }
    }

    /**
     Notifies the view controller that its view is about to be added to a view hierarchy.

     - parameter animated: If `YES`, the view is being added to the window using an animation.
     */
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: animated)
        }
    }

    /**
     Notifies the view controller that its view was added to a view hierarchy.

     - parameter animated: If `YES`, the view is being added to the window using an animation.
     */
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.acknowledgements == nil {
            print(
                "** AcknowList Warning **\n" +
                "No acknowledgements found.\n" +
                "This probably means that you didn’t import the `Pods-acknowledgements.plist` to your main target.\n" +
                "Please take a look at https://github.com/vtourraine/AcknowList for instructions.", terminator: "\n")
        }
    }

    // MARK: - Actions

    /**
     Opens the CocoaPods website with Safari.

     - parameter sender: The event sender.
     */
    @IBAction open func openCocoaPodsWebsite(_ sender: AnyObject) {
        let url = URL(string: AcknowLocalization.CocoaPodsURLString())
        if let url = url {
            if #available(iOS 10.0, tvOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    /**
     Dismisses the view controller.

     - parameter sender: The event sender.
     */
    @IBAction open func dismissViewController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Configuration

    class func LabelMargin () -> CGFloat {
        return 20
    }
    
    class func FooterBottomMargin() -> CGFloat {
        return 20
    }

    func configureHeaderView() {
        let font = UIFont.preferredFont(forTextStyle: .footnote)
        let labelWidth = self.view.frame.width - 2 * AcknowListViewController.LabelMargin()

        if let headerText = self.headerText {
            let labelHeight = self.heightForLabel(text: headerText as NSString, width: labelWidth)
            let labelFrame = CGRect(
                x: AcknowListViewController.LabelMargin(),
                y: AcknowListViewController.LabelMargin(),
                width: labelWidth,
                height: labelHeight)

            let label = UILabel(frame: labelFrame)
            label.text = self.headerText
            label.font = font
            label.textColor = UIColor.gray
            label.backgroundColor = UIColor.clear
            label.numberOfLines = 0
            label.textAlignment = .center
            label.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            if #available(iOS 10.0, tvOS 10.0, *) {
                label.adjustsFontForContentSizeCategory = true
            }

            let headerFrame = CGRect(
                x: 0, y: 0,
                width: self.view.frame.width,
                height: label.frame.height + 2 * AcknowListViewController.LabelMargin())
            let headerView = UIView(frame: headerFrame)
            headerView.addSubview(label)
            self.tableView.tableHeaderView = headerView
        }
    }

    func configureFooterView() {
        let font = UIFont.preferredFont(forTextStyle: .footnote)
        let labelWidth = self.view.frame.width - 2 * AcknowListViewController.LabelMargin()

        if let footerText = self.footerText {
            let labelHeight = self.heightForLabel(text: footerText as NSString, width: labelWidth)
            let labelFrame = CGRect(x: AcknowListViewController.LabelMargin(), y: 0, width: labelWidth, height: labelHeight);

            let label = UILabel(frame: labelFrame)
            label.text = self.footerText
            label.font = font
            label.textColor = UIColor.gray

            if let footerTextAttributes = self.footerTextAttributes {
                let attrString = NSAttributedString(string: footerText, attributes: footerTextAttributes)
                label.attributedText = attrString
            }

            label.backgroundColor = UIColor.clear
            label.numberOfLines = 0
            label.textAlignment = .center
            label.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
            label.isUserInteractionEnabled = true
            if #available(iOS 10.0, tvOS 10.0, *) {
                label.adjustsFontForContentSizeCategory = true
            }

            let CocoaPodsURL = URL(string: AcknowLocalization.CocoaPodsURLString())
            if let CocoaPodsURL = CocoaPodsURL,
                let CocoaPodsURLHost = CocoaPodsURL.host {
                    if footerText.range(of: CocoaPodsURLHost) != nil {
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AcknowListViewController.openCocoaPodsWebsite(_:)))
                        label.addGestureRecognizer(tapGestureRecognizer)
                    }
            }

            let footerFrame = CGRect(x: 0, y: 0, width: label.frame.width, height: label.frame.height + AcknowListViewController.FooterBottomMargin())
            let footerView = UIView(frame: footerFrame)
            footerView.isUserInteractionEnabled = true
            footerView.addSubview(label)
            label.frame = CGRect(x: 0, y: 0, width: label.frame.width, height: label.frame.height);

            self.tableView.tableFooterView = footerView
        }
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

     - parameter tableView: An object representing the table view requesting this information.

     - returns: The number of sections in `tableView`. The default value is 1.
     */
    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let acknowledgements = self.acknowledgements {
            return acknowledgements.count
        }

        return 0
    }

    /**
     Asks the data source for a cell to insert in a particular location of the table view.

     - parameter tableView: The table-view object requesting the cell.
     - parameter indexPath: An index path that locates a row in `tableView`.

     - returns: An object inheriting from `UITableViewCell` that the table view can use for the specified row. An assertion is raised if you return `nil`.
     */
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)
        let cell: UITableViewCell
        if let dequeuedCell = dequeuedCell {
            cell = dequeuedCell
        }
        else {
            if isLicenceCellCustomized {
                #if os(tvOS)
                    tableView.mask = nil
                    cell = TVOSAcknowledgementCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: CellIdentifier, backgroundColor: self.licenceCellBackgroundColor, highlightColor: self.licenceCellHighlightColor, licenceCellFont: self.licenceCellFont, licenceCellFontColor: self.licenceCellFontColor, licenceCellFontHighlightColor: self.licenceCellFontHighlightColor)
                #else
                    cell = IOSAcknowledgementCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: CellIdentifier, backgroundColor: self.licenceCellBackgroundColor, highlightColor: self.licenceCellHighlightColor, licenceCellFont: self.licenceCellFont, licenceCellFontColor: self.licenceCellFontColor, licenceCellFontHighlightColor: self.licenceCellFontHighlightColor)
                #endif

            } else {
                cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: CellIdentifier)
                cell.accessoryType = .disclosureIndicator
            }
        }

        if let acknowledgements = self.acknowledgements,
            let acknowledgement = acknowledgements[(indexPath as NSIndexPath).row] as Acknow?,
            let textLabel = cell.textLabel as UILabel? {
            textLabel.text = acknowledgement.title
        }

        return cell
    }

    // MARK: Table view delegate

    /**
     Tells the delegate that the specified row is now selected.

     - parameter tableView: A table-view object informing the delegate about the new row selection.
     - parameter indexPath: An index path locating the new selected row in `tableView`.
     */
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let acknowledgements = self.acknowledgements,
            let acknowledgement = acknowledgements[(indexPath as NSIndexPath).row] as Acknow?,
            let navigationController = self.navigationController {
            let viewController = AcknowViewController(acknowledgement: acknowledgement)
            viewController.backgroundColor = licenceDetailViewBackgroundColor
            viewController.font = licenceDetailViewFont
            viewController.fontColor = licenceDetailViewFontColor

            navigationController.pushViewController(viewController, animated: true)
        }
    }

    /**
     Asks the delegate for the estimated height of a row in a specified location.

     - parameter tableView: The table-view object requesting this information.
     - parameter indexPath: An index path that locates a row in `tableView`.

     - returns: A nonnegative floating-point value that estimates the height (in points) that `row` should be. Return `UITableViewAutomaticDimension` if you have no estimate.
     */
    open override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: TVOsAcknowledgementCell

fileprivate class TVOSAcknowledgementCell: UITableViewCell {

    fileprivate var customBackgroundColor: UIColor?
    fileprivate var customHighlightColor: UIColor?
    fileprivate var  parallaxMotionEffect: UIMotionEffectGroup
    fileprivate var licenceCellFontColor: UIColor?
    fileprivate var licenceCellFontHighlightColor: UIColor?

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, backgroundColor: UIColor?, highlightColor: UIColor?, licenceCellFont:UIFont?, licenceCellFontColor: UIColor?, licenceCellFontHighlightColor: UIColor?) {
        self.parallaxMotionEffect = TVOSAcknowledgementCell.createParallaxMotionEffects()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.customBackgroundColor = backgroundColor
        self.customHighlightColor = highlightColor
        if #available(iOS 9.0, *) {
            self.focusStyle = .custom
        }

        self.textLabel?.font = licenceCellFont
        self.textLabel?.textColor = licenceCellFontColor
        self.licenceCellFontColor = licenceCellFontColor
        self.licenceCellFontHighlightColor = licenceCellFontHighlightColor

        applyBackground(color: self.customBackgroundColor)
    }

    required init?(coder aDecoder: NSCoder) {
        self.parallaxMotionEffect = TVOSAcknowledgementCell.createParallaxMotionEffects()
        super.init(coder: aDecoder)
    }

    @available(iOS 9.0, *)
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)

        if context.nextFocusedView === self {

            coordinator.addCoordinatedAnimations({
                guard let selectedColor = self.customHighlightColor else {
                    return
                }

                self.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
                self.addMotionEffect(self.parallaxMotionEffect)
                self.applyBackground(color: selectedColor)
                self.textLabel?.textColor = self.licenceCellFontHighlightColor

            }, completion: nil)
        }
        else {
            guard let notSelectedColor = self.customBackgroundColor else {
                return
            }
            self.applyBackground(color: notSelectedColor)
            self.transform = .identity
            self.removeMotionEffect(parallaxMotionEffect)
            self.textLabel?.textColor = licenceCellFontColor
        }
    }

    fileprivate func applyBackground(color: UIColor?) {
        if let backgroundColor = color {
            self.backgroundColor = backgroundColor
            self.contentView.backgroundColor = backgroundColor
            self.layer.cornerRadius = 8.0
            self.layer.masksToBounds = true
        } else {
            self.accessoryType = .disclosureIndicator
        }
    }

    fileprivate class func createParallaxMotionEffects(tiltValue: CGFloat = 0.15, panValue: CGFloat = 10) -> UIMotionEffectGroup {
        let xTilt = UIInterpolatingMotionEffect(keyPath: "layer.transform.rotation.y", type: .tiltAlongHorizontalAxis)
        xTilt.minimumRelativeValue = -tiltValue
        xTilt.maximumRelativeValue = tiltValue

        let yTilt = UIInterpolatingMotionEffect(keyPath: "layer.transform.rotation.x", type: .tiltAlongVerticalAxis)
        yTilt.minimumRelativeValue = -tiltValue
        yTilt.maximumRelativeValue = tiltValue

        let xPan = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xPan.minimumRelativeValue = -panValue
        xPan.maximumRelativeValue = panValue

        let yPan = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yPan.minimumRelativeValue = -panValue
        yPan.maximumRelativeValue = panValue

        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = [xTilt, yTilt, xPan, yPan]

        return motionGroup
    }
}

// MARK: IOSAcknowledgementCell

fileprivate class IOSAcknowledgementCell: UITableViewCell {

    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, backgroundColor: UIColor?, highlightColor: UIColor?, licenceCellFont:UIFont?, licenceCellFontColor: UIColor?, licenceCellFontHighlightColor: UIColor?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.textLabel?.font = licenceCellFont
        self.textLabel?.textColor = licenceCellFontColor

        self.backgroundColor = backgroundColor
        self.contentView.backgroundColor = backgroundColor
        self.accessoryType = .disclosureIndicator
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

