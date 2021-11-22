//
//  SlideView.swift
//  Sliction
//
//  Created by Awwad on 20.11.21.
//

import UIKit

public protocol SlideToActionViewDelegate: AnyObject {
    func slideDidFinish()
}

final public class SlideView: UIView {

    private var configuration: SliderConfiguration = SliderConfiguration() {
        didSet {
            setupView()
        }
    }

    weak var delegate: SlideToActionViewDelegate?

    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = configuration.radius
        view.backgroundColor = configuration.backgroundColor
        return view
    }()

    private lazy var sliderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = configuration.font
        label.textAlignment = configuration.textAlignment
        label.textColor = configuration.textColor
        label.text = configuration.title
        return label
    }()

    private lazy var sliderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = configuration.slideBorderWidth
        view.layer.borderColor = configuration.slideBorderColor
        view.layer.cornerRadius = configuration.radius
        view.backgroundColor = configuration.slideBackgroundColor
        return view
    }()

    private lazy var sliderImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: configuration.icon))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    private let doneImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "checkmark-selected-purple"))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        recognizer.minimumNumberOfTouches = 1
        return recognizer
    }()

    private lazy var sliderViewLeadingConstraint: NSLayoutConstraint = sliderView.leadingAnchor.constraint(equalTo: leadingAnchor)

    private lazy var backgroundViewLongConstraints: [NSLayoutConstraint] = [
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ]

    private lazy var backgroundViewCenterConstraints: [NSLayoutConstraint] = [
        backgroundView.heightAnchor.constraint(equalToConstant: 48),
        backgroundView.widthAnchor.constraint(equalToConstant: 48),
        backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
        backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor)
    ]

    public init(configuration: SliderConfiguration) {
        super.init(frame: .zero)

        defer {
            self.configuration = configuration
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func startAnimating() {
        sliderLabel.isHidden = true
        sliderView.isHidden = true
        NSLayoutConstraint.deactivate(backgroundViewLongConstraints)
        NSLayoutConstraint.activate(backgroundViewCenterConstraints)
        activityIndicatorView.startAnimating()
        UIView.animate(withDuration: 0.4) {
            self.layoutIfNeeded()
        }
    }

    private func stopAnimating() {
        activityIndicatorView.stopAnimating()
        backgroundView.addSubview(doneImageView)
        NSLayoutConstraint.activate([
            doneImageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            doneImageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            doneImageView.widthAnchor.constraint(equalToConstant: 20),
            doneImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translatedPoint = sender.translation(in: sliderView).x
        let factor: CGFloat = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? -1 : 1

        switch sender.state {
        case .changed:
            if factor * translatedPoint <= 0 {
                sliderViewLeadingConstraint.constant = 0
                return
            }

            if factor * translatedPoint + sliderView.frame.width >= frame.width {
                sliderViewLeadingConstraint.constant = frame.width - sliderView.frame.width
                return
            }

            sliderViewLeadingConstraint.constant = factor * translatedPoint
        case .ended:
            if factor * translatedPoint < frame.width / 4 {
                sliderViewLeadingConstraint.constant = 0
                UIView.animate(withDuration: 0.1) {
                    self.layoutIfNeeded()
                }
            } else {
                sliderViewLeadingConstraint.constant = frame.width - sliderView.frame.width
                UIView.animate(withDuration: 0.1) {
                    self.layoutIfNeeded()
                } completion: { _ in
                    self.delegate?.slideDidFinish()
                    self.startAnimating()
                }
            }
        default:
            break
        }
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        [backgroundView, sliderLabel, sliderView].forEach { addSubview($0) }
        backgroundView.addSubview(activityIndicatorView)
        sliderView.addSubview(sliderImageView)
        sliderView.addGestureRecognizer(panGestureRecognizer)

        NSLayoutConstraint.activate(backgroundViewLongConstraints)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            sliderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            sliderLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            sliderLabel.topAnchor.constraint(equalTo: topAnchor),
            sliderLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            sliderView.heightAnchor.constraint(equalToConstant: 48),
            sliderView.widthAnchor.constraint(equalToConstant: 48),
            sliderView.centerYAnchor.constraint(equalTo: centerYAnchor),
            sliderViewLeadingConstraint,

            sliderImageView.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor),
            sliderImageView.centerXAnchor.constraint(equalTo: sliderView.centerXAnchor),
            sliderImageView.widthAnchor.constraint(equalToConstant: 15),
            sliderImageView.heightAnchor.constraint(equalToConstant: 15),

            activityIndicatorView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        ])
    }
}
