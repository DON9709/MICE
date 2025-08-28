//
//  BookmarkViewController.swift
//  MICE
//
//  Created by 송명균 on 8/28/25.
//

import UIKit
import SnapKit

class BookmarkViewController: UIViewController {
    
    private let viewModel = BookmarkViewModel()
    private var pageViewController: UIPageViewController!
    private var pages = [UIViewController]()

    // MARK: - UI Components
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["저장한 스탬프", "다녀온 스탬프"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
        return control
    }()
    
    private let hashtagScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var hashtagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        let hashtags = ["#전체보기", "#박물관", "#전시관", "#미술관", "#기념관"]
        hashtags.forEach { title in
            stackView.addArrangedSubview(createHashtagButton(title: title))
        }
        return stackView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        setupPages()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupPages() {
        let savedVC = StampListViewController(items: viewModel.savedStamps)
        let visitedVC = StampListViewController(items: viewModel.visitedStamps)
        pages.append(savedVC)
        pages.append(visitedVC)
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }

    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(segmentedControl)
        view.addSubview(hashtagScrollView)
        hashtagScrollView.addSubview(hashtagStackView)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(16)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        hashtagScrollView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(35)
        }
        
        hashtagStackView.snp.makeConstraints { make in
            make.height.equalTo(hashtagScrollView)
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(hashtagScrollView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions & Helpers
    @objc private func segmentedControlDidChange(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let currentIndex = pages.firstIndex(of: pageViewController.viewControllers!.first!)!
        let direction: UIPageViewController.NavigationDirection = selectedIndex > currentIndex ? .forward : .reverse
        pageViewController.setViewControllers([pages[selectedIndex]], direction: direction, animated: true, completion: nil)
    }
    
    private func createHashtagButton(title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        
        let button = UIButton(configuration: config)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1.0
        return button
    }
}

// MARK: - UIPageViewController DataSource & Delegate
extension BookmarkViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = pageViewController.viewControllers?.first, let index = pages.firstIndex(of: currentVC) {
            segmentedControl.selectedSegmentIndex = index
        }
    }
}
