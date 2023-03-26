//
//  ViewController.swift
//  UIKitResponderChain
//
//  Created by Gennady Stepanov on 25.03.2023.
//

import UIKit

// MARK: - Hierarchy

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
    }
    
    private func setupHierarchy() {
        // container
        let container = ContainerView()
        container.backgroundColor = .gray
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 200),
            container.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension ViewController: SomeParentProtocol {
    func didTriggerResponderChain(_ sender: SomeChildView) {
        print("Responder chain triggered, text is \(sender.currentText)")
    }
}

final class ContainerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let child = SomeChildView(frame: CGRect(x: 20, y: 20, width: 160, height: 160))
        child.backgroundColor = .yellow
        addSubview(child)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init with coder not implemented")
    }
}

final class SomeChildView: UIView {
    // hare can be a reference to viewModel
    // where you can read actual data related to the view
    var currentText = "foo"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let button = UIButton(primaryAction: UIAction { [weak self] _ in
            self?.triggerResponderChain()
        })
        
        button.setTitle("Test me", for: .normal)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init with coder not implemented")
    }
    
    @objc func triggerResponderChain() {
        UIApplication.shared.sendAction(
            #selector(SomeParentProtocol.didTriggerResponderChain),
            to: nil,
            from: self,
            for: nil
        )
    }
}

// MARK: - Responder chain
@objc protocol SomeParentProtocol {
    func didTriggerResponderChain(_ sender: SomeChildView)
}

