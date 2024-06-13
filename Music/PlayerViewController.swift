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
    
    
    // MARK: Subviews
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "DefaultThumbnail"))
        //let imageView = UIImageView(image: generateThumbnail(path: musicLibrary[0]) ?? UIImage(named: "DefaultThumbnail"))
        imageView.clipsToBounds = true
                        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
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
        
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage(systemName: "forward.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .regular))
        button.setImage(image, for: .normal)
        button.tintColor = .systemOrange
        
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        setupUI()
        addSubviews()
        setupConstraints()
        Task {
            do {
                let song = try await getSong(url: musicLibrary[4])
                coverImageView.image = song.artwork
            } catch {
                print("Failed to load song: \(error)")
            }
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do {
            player = try AVAudioPlayer(contentsOf: musicLibrary[0])
            player.prepareToPlay()
        }
        catch {
            print(error)
        }
    }

    

    
    // MARK: - Actions

    @objc private func playButtonTapped(_ sender: Any) {
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
    
    @objc private func StopButton(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            player.play(atTime: 0)
        }
        else {
            print("Already stopped!")
        }
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
            playButton.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20),
            playButton.widthAnchor.constraint(equalToConstant: 100),
            playButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            previousButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 20),
            previousButton.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20),
            previousButton.widthAnchor.constraint(equalToConstant: 100),
            previousButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -20),
            nextButton.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 20),
            nextButton.widthAnchor.constraint(equalToConstant: 100),
            nextButton.heightAnchor.constraint(equalToConstant: 100)
        ])
        /*
            NSLayoutConstraint.activate([
                feedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                feedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                feedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                feedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ])
    */
        }


}

