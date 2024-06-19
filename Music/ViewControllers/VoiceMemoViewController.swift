//
//  VoiceMemoViewController.swift
//  Music
//
//  Created by Philipp Lazarev on 13.06.2024.
//

import UIKit
import Foundation
import AVFoundation
import MediaPlayer

class VoiceMemoViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var audioRecorder: AVAudioRecorder?
    var player = AVAudioPlayer()
    
    var isRecording = false
    var isPlaying = false
    
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
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: waveformImage)
        
        imageView.tintColor = .orange
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return imageView
    }()
    
    private lazy var volumeSlider: MPVolumeView = {
        let slider = MPVolumeView(frame: view.bounds)

        slider.translatesAutoresizingMaskIntoConstraints = false

        return slider
    }()
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        setupUI()
        addSubviews()
        setupConstraints()
        super.viewDidLoad()
    }
    
    
    
    // MARK: - Actions
    
    @objc private func recordButtonTapped(_ sender: Any) {
        if checkRecordPermission() {
            if isRecording {
                stopRecording()
                self.isRecording = false
            } else {
                startRecording()
                self.isRecording = true
            }
        } else {
            handlePermissionDenied()
        }
    }
    
    @objc private func playButtonTapped(_ sender: Any) {
        if isPlaying {
            stopPlaying()
        } else {
            startPlaying()
        }
    }
    
    
    // MARK: - Private
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(recordButton)
        view.addSubview(playButton)
        view.addSubview(volumeSlider)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        let spacing = view.frame.size.width / 3
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor, constant: -50),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            volumeSlider.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 40),
            volumeSlider.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -40),
            volumeSlider.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            volumeSlider.heightAnchor.constraint(equalToConstant: 20),
        
        ])
        
        NSLayoutConstraint.activate([
            recordButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -30),
            recordButton.centerXAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: spacing)
        ])
        
        NSLayoutConstraint.activate([
            playButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            playButton.centerXAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -spacing)
        ])
    }
    
    private func checkRecordPermission() -> Bool {
        let recordPermission = AVAudioApplication.shared.recordPermission
        
        var canRecord = false
        
        switch recordPermission {
        case .undetermined:
            canRecord = self.requestRecordingPermission()
        case .denied:
            print("Recording permission has been denied.")
        case .granted:
            print("Recording permission has been granted.")
            canRecord = true
        @unknown default:
            print("Unknown recording permission status.")
        }
        return canRecord
    }
    
    private func requestRecordingPermission() -> Bool {
        var canRecord = false
        
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    canRecord = true
                } else {
                    self.handlePermissionDenied()
                    print("Permission denied")
                }
            }
        }
        
        return canRecord
    }
    
    
    // Handling errors for actions that are not allowed
    
    private func handlePermissionDenied() {
        let alert = UIAlertController(title: "Permission Denied", message: "Recording permission is required to use this feature. Please enable it in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func handleSimultaneousActions() {
        let alert = UIAlertController(title: "Simultaneous", message: "Recording permission is required to use this feature. Please enable it in Settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func handleNoRecordsAvailable() {
        let alert = UIAlertController(title: "Can't play!", message: "There are no records available to play!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    // Recording actions
    
    private func startRecording() {
        imageView.tintColor = .systemRed
        recordButton.tintColor = .systemRed
        recordButton.setImage(stopRecordImage, for: .normal)
        playButton.isUserInteractionEnabled = false
        playButton.tintColor = .systemGray
        
        audioRecorder = AVAudioRecorder()
        let session = AVAudioSession.sharedInstance()
        do
        {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1, // Mono channel for better clarity
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ] //as [String : Any]
            audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        }
        catch let error {
            print("error: \(error)")
        }
    }
    
    private func stopRecording() {

        imageView.tintColor = .systemOrange
        recordButton.tintColor = .systemOrange
        recordButton.setImage(recordImage, for: .normal)

        audioRecorder?.stop()
        audioRecorder = nil
        
        playButton.isUserInteractionEnabled = true
        playButton.tintColor = .systemOrange
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback)
            try session.setActive(true)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // Playing actions
    
    private func startPlaying() {
        playButton.setImage(pauseImage, for: .normal)
        isPlaying = true
        
        do {
            recordButton.isUserInteractionEnabled = false
            recordButton.tintColor = .systemGray
            player = try AVAudioPlayer(contentsOf: getFileUrl())
            player.prepareToPlay()
            player.delegate = self
            player.play()
        }
        catch {
            print(error)
        }
    }
    
    private func stopPlaying() {
        playButton.setImage(playImage, for: .normal)
        isPlaying = false
        recordButton.isUserInteractionEnabled = true
        recordButton.tintColor = .systemOrange
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopPlaying()
    }
}
