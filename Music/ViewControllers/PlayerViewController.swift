//
//  ViewController.swift
//  Music
//
//  Created by Philipp Lazarev on 13.06.2024.
//

import UIKit
import AVFoundation

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
        
        let image = playImage
        button.setImage(image, for: .normal)
        button.tintColor = .systemOrange

        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        return button
    }()
    
    private lazy var previousButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage(systemName: "backward.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .systemOrange
        
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)

        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage(systemName: "forward.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
        button.setImage(image, for: .normal)
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
    
    @objc private func stopButton(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            player.play(atTime: 0)
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
        togglePlayButton()
    }
    
    @objc private func nextButtonTapped(_ sender: Any) {
        if self.currentPosition == musicLibrary.count - 1 {
            self.currentPosition = 0
        } else {
            self.currentPosition += 1
        }
        setCurrentSong()
        togglePlayButton()
    }
    
    
    // MARK: - Private
    
    private func setupUI() {
        title = "Music Library"
        view.backgroundColor = .white
    }
    
    private func addSubviews() {
        view.addSubview(coverImageView)
        view.addSubview(playButton)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(titleLabel)
        view.addSubview(artistLabel)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            coverImageView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            coverImageView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor, constant: -100),
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
            playButton.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 40),
            playButton.widthAnchor.constraint(equalToConstant: 100),
            playButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            previousButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 20),
            previousButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            previousButton.widthAnchor.constraint(equalToConstant: 100),
            previousButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -20),
            nextButton.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 100),
            nextButton.heightAnchor.constraint(equalToConstant: 100)
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

