//
//  ViewController.swift
//  Music
//
//  Created by Philipp Lazarev on 13.06.2024.
//

import UIKit
import AVFoundation
import MediaPlayer

class PlayerViewController: UIViewController {

    var player = AVAudioPlayer()
    
    var currentPosition = 0
    var currentSong = Song(title: "", artist: "", artwork: defaultArtwork)
    
    // MARK: Subviews
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "DefaultThumbnail"))
        imageView.clipsToBounds = true
                        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
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
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        
        button.setImage(stopImage, for: .normal)
        button.tintColor = .systemOrange
        
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        
        
        return button
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        
        button.setImage(previousImage, for: .normal)
        button.tintColor = .systemOrange
        
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)

        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        
        button.setImage(nextImage, for: .normal)
        button.tintColor = .systemOrange
        
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 20.0)

        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 15.0)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var volumeSlider: MPVolumeView = {
        let slider = MPVolumeView(frame: view.bounds)

        slider.translatesAutoresizingMaskIntoConstraints = false

        return slider
    }()
    
    private lazy var minVolumeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(minVolumeImage, for: .normal)
        button.tintColor = .systemOrange
        
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(minVolumeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var maxVolumeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(maxVolumeImage, for: .normal)
        button.tintColor = .systemOrange
        
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(maxVolumeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        setupUI()
        addSubviews()
        setupConstraints()
        
        setCurrentSong()
        self.currentPosition += 1
        setCurrentSong()
        
        super.viewDidLoad()
    }

    
    
    // MARK: - Actions

    @objc private func playButtonTapped(_ sender: Any) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
        togglePlayButton()
    }
    
    @objc private func stopButtonTapped(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            player.play(atTime: 0)
            player.pause()
            togglePlayButton()
        }
        else {
            print("Already stopped!")
        }
    }
    
    @objc private func previousButtonTapped(_ sender: Any) {
        if self.currentPosition == 0 {
            self.currentPosition = musicLibrary.count - 1
        } else {
            self.currentPosition -= 1
        }
        setCurrentSong()
        player.play()
        togglePlayButton()
    }
    
    @objc private func nextButtonTapped(_ sender: Any) {
        if self.currentPosition == musicLibrary.count - 1 {
            self.currentPosition = 0
        } else {
            self.currentPosition += 1
        }
        setCurrentSong()
        player.play()
        togglePlayButton()
    }
    
    @objc private func minVolumeButtonTapped(_ sender: Any) {
        MPVolumeView.setVolume(0.0)
    }
    
    @objc private func maxVolumeButtonTapped(_ sender: Any) {
        MPVolumeView.setVolume(1.0)
    }
    
    
    
    // MARK: - Private
    
    private func setupUI() {
        //title = "Player"
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(coverImageView)
        view.addSubview(playButton)
        view.addSubview(stopButton)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(titleLabel)
        view.addSubview(artistLabel)
        view.addSubview(volumeSlider)
        view.addSubview(minVolumeButton)
        view.addSubview(maxVolumeButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        let spacing = view.frame.size.width / 8
        
        NSLayoutConstraint.activate([
            coverImageView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            coverImageView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor, constant: -125),
            coverImageView.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor, constant: -20),
            coverImageView.heightAnchor.constraint(equalTo: safeAreaGuide.widthAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 30),
            titleLabel.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            artistLabel.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 30),
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            artistLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        NSLayoutConstraint.activate([
            previousButton.centerXAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: spacing),
            previousButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            previousButton.widthAnchor.constraint(equalToConstant: 100),
            previousButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: previousButton.centerXAnchor, constant: spacing*2),
            playButton.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 40),
            playButton.widthAnchor.constraint(equalToConstant: 100),
            playButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            stopButton.centerXAnchor.constraint(equalTo: playButton.centerXAnchor, constant: spacing*2),
            stopButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: stopButton.centerXAnchor, constant: spacing*2),
            nextButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 100),
            nextButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            minVolumeButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 15),
            minVolumeButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            maxVolumeButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 15),
            maxVolumeButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            volumeSlider.leadingAnchor.constraint(equalTo: minVolumeButton.trailingAnchor, constant: 20),
            volumeSlider.trailingAnchor.constraint(equalTo: maxVolumeButton.leadingAnchor, constant: -20),
            volumeSlider.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 15),
            volumeSlider.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func setCurrentSong() {
        Task {
            do {
                currentSong = try await getSong(url: musicLibrary[currentPosition])
                coverImageView.image = currentSong.artwork
                titleLabel.text = currentSong.title
                artistLabel.text = currentSong.artist
                print(currentSong)
            } catch {
                print("Failed to load song: \(error)")
            }
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: musicLibrary[currentPosition])
            player.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    private func togglePlayButton() {
        if player.isPlaying {
            playButton.setImage(pauseImage, for: .normal)
        } else {
            playButton.setImage(playImage, for: .normal)
        }
    }
}

