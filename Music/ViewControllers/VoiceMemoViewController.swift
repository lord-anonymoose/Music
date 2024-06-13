//
//  VoiceMemoViewController.swift
//  Music
//
//  Created by Philipp Lazarev on 13.06.2024.
//

import UIKit
import Foundation
import AVFoundation


class VoiceMemoViewController: UIViewController {
    
    var audioRecorder: AVAudioRecorder?
    
    // MARK: Subviews

    private lazy var recordButton: UIButton = {
        let button = UIButton()
        
        button.setImage(recordImage, for: .normal)
        button.tintColor = .systemOrange

        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)

        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        
        button.setImage(playImage, for: .normal)
        button.tintColor = .systemOrange

        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        setupUI()
        addSubviews()
        setupConstraints()
        
        checkRecordPermission()
        requestRecordingPermission()
        super.viewDidLoad()
    }

    
    
    // MARK: - Actions

    @objc private func recordButtonTapped(_ sender: Any) {
        // Example
    }
    
    @objc private func playButtonTapped(_ sender: Any) {
        
    }
    
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(recordButton)
        view.addSubview(playButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        let spacing = view.frame.size.width / 3

        NSLayoutConstraint.activate([
            recordButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -30),
            recordButton.centerXAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: spacing)
        ])
        
        NSLayoutConstraint.activate([
            playButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            playButton.centerXAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -spacing)
        ])
        
    }
    
    private func checkRecordPermission() {
        print("Checking record permission")
        let recordPermission = AVAudioApplication.shared.recordPermission
        
        switch recordPermission {
        case .undetermined:
            print("Recording permission has not been determined yet.")
        case .denied:
            print("Recording permission has been denied.")
        case .granted:
            print("Recording permission has been granted.")
        @unknown default:
            print("Unknown recording permission status.")
        }
    }
    
    private func requestRecordingPermission() {
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    self.startRecording()
                    print("Permission granted")
                } else {
                    self.handlePermissionDenied()
                    print("Permission denied")
                }
            }
        }
    }
    
    private func handlePermissionDenied() {
        let alert = UIAlertController(title: "Permission Denied", message: "Recording permission is required to use this feature. Please enable it in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func startRecording() {
        
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        print("Recording stopped.")
    }
}
