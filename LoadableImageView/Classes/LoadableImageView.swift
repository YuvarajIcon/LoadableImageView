//
//  LoadableImageView.swift
//
//  Created by Yuvaraj on 23/12/21.
//

import Foundation
import Downloader
import HelpfulExtensions
import UIKit

open class LoadableImageView: UIImageView {
    deinit {
        debugPrint("LoadableImageView deinit")
    }
    
    private var _urlString: String?
    private var _progress: DownloadProgress = .notstarted {
        didSet {
            if useLoaders {
                self.manageLoaders()
            } else {
                self.manageImages()
            }
        }
    }
    private var _indicator: UIActivityIndicatorView?
    private var _downloadedImage: UIImage?
    private var _onFailure: (() -> Void)? = nil
    private var _onSuccess: (() -> Void)? = nil
    private lazy var assignDelegate: Void = {
        Downloader.shared.delegates.add(delegate: self)
    }()
    
    ///Image to set before the download starts. This property and `useLoaders` are mutaully exclusive. Setting this to `nil` will set `useLoaders` to `true`.
    open var placeHolderImage: UIImage? {
        didSet {
            if placeHolderImage != nil {
                self.useLoaders = false
            } else {
                self.useLoaders = true
            }
        }
    }
    
    ///Image to set when download fails.
    open var errorImage: UIImage?
    
    ///A boolean value to use loaders. Setting this to true will show activity indicators instead of placeholder image & set `placeHolderImage` to `nil`. Default value is `true`.
    open var useLoaders: Bool = true {
        didSet {
            if useLoaders {
                self.placeHolderImage = nil
            }
        }
    }
    
    ///Fetches image from remote URL. If the given URLString is invalid, `onFailure` is called.
    open func load(from urlString: String, onFailure: (() -> Void)? = nil, onSuccess: (() -> Void)? = nil) {
        self._urlString = urlString
        self._onFailure = onFailure
        self._onSuccess = onSuccess
        guard urlString.isValidUrl else {
            self._progress = .finishedWithError
            onFailure?()
            return
        }
        guard let url = URL(string: urlString) else {
            onFailure?()
            return
        }
        if let image = Downloader.shared.imageFor(url: url) {
            self._downloadedImage = image
            self._progress = .finished
            onSuccess?()
        } else {
            self._progress = Downloader.shared.taskProgressFor(url: url)
            if self._progress == .finishedWithError {
                onFailure?()
            }
        }
        _ = assignDelegate
    }
    
    ///Fetches from remote URL. Calls `load(from:)` function, with previously called parameters. If `load(from:)` was not called prior to this, nothing will happen.
    open func reload() {
        guard let url = self._urlString else { return }
        self.load(from: url, onFailure: self._onFailure, onSuccess: self._onSuccess)
    }
    
    private func manageImages() {
        switch _progress {
        case .notstarted:
            self.image = placeHolderImage
            break
            
        case .started:
            self.image = placeHolderImage
            break
            
        case .finished:
            self.image = _downloadedImage
            break
            
        case .finishedWithError:
            self.image = errorImage
            break
        }
    }
    
    private func manageLoaders() {
        switch _progress {
        case .notstarted, .started:
            self.image = nil
            if _indicator != nil { return }
            _indicator = UIActivityIndicatorView()
            guard let indicator = _indicator else { return }
            self.addSubview(indicator)
            indicator.attachCenterXAnchor(to: self)
            indicator.attachCentenYAnchor(to: self)
            indicator.startAnimating()
            break
            
        case .finished:
            self.image = _downloadedImage
            _indicator?.stopAnimating()
            _indicator?.removeFromSuperview()
            break
            
        case .finishedWithError:
            self.image = errorImage
            _indicator?.stopAnimating()
            _indicator?.removeFromSuperview()
            break
        }
    }
}

extension LoadableImageView: DownloadUpdatesReciever {
    public func downloadCompleted(for url: URL) {
        if url.absoluteString == self._urlString {
            DispatchQueue.main.async {
                self.load(from: url.absoluteString,
                    onFailure: self._onFailure,
                    onSuccess: self._onSuccess
                )
            }
        }
    }
}

