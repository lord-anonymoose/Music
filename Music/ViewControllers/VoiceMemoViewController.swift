//
//  VoiceMemoViewController.swift
//  Music
//
//  Created by Philipp Lazarev on 13.06.2024.
//

import UIKit
import Foundation

class VoiceMemoViewController: UIViewController {
    
    // MARK: Subviews

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        setupUI()
        addSubviews()
        setupConstraints()
        
        super.viewDidLoad()
    }

    
    
    // MARK: - Actions

    @objc private func playButtonTapped(_ sender: Any) {
        // Example
    }
    
    
    // MARK: - Private
    
    private func setupUI() {
        //title = "Memo"
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        
    }
    
    private func setupConstraints() {
        
    }
    
}
