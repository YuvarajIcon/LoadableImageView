//
//  Downloader.swift
//
//  Created by Yuvaraj on 22/12/21.
//

import Foundation
import UIKit

///Protocol to recieve updates.
public protocol DownloadUpdatesReciever: AnyObject {
    func downloadCompleted(for url: URL)
}

public enum DownloadProgress {
    case notstarted
    case started
    case finished
    case finishedWithError
}

class DownloadTask {
    var value: URLSessionDataTask
    var progress: DownloadProgress = .notstarted
    var key: URL
    
    init(value: URLSessionDataTask, key: URL, progress: DownloadProgress = .notstarted) {
        self.value = value
        self.key = key
        self.progress = progress
    }
}

class DownloadedImage {
    var url: URL
    var image: UIImage
    
    init(url: URL, image: UIImage) {
        self.url = url
        self.image = image
    }
}

///Singleton class for all types of download related tasks.
///Has two private caches, both will be discarded as per system's policy.
///For consistency, do not have condition that check with any object with cache. If there is a need create another cache.
open class Downloader {
    public static var shared: Downloader = Downloader()
    private let imageCache = NSCache<NSString, DownloadedImage>()
    private var downloadCache = NSCache<NSString, DownloadTask>()
    open var delegates: MulticastDelegate<DownloadUpdatesReciever> = MulticastDelegate<DownloadUpdatesReciever>()
    
    private func cachedImage(for url: URL) -> DownloadedImage? {
        return self.imageCache.object(forKey: NSString(string: url.absoluteString))
    }
    
    private func downloadTask(for url: URL) -> DownloadTask? {
        return self.downloadCache.object(forKey: NSString(string: url.absoluteString))
    }
    
    private func downloadImage(with url: URL) {
        let downloadTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                self.downloadTask(for: url)?.progress = .finishedWithError
            } else if let data = data {
                if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                    self.downloadTask(for: url)?.progress = .finishedWithError
                }
                guard let response = response as? HTTPURLResponse, response.statusCode != 400, response.statusCode != 404 else {
                    self.downloadTask(for: url)?.progress = .finishedWithError
                    return
                }
                if let image = UIImage(data: data) {
                    let downloadedImage = DownloadedImage(url: url, image: image)
                    self.imageCache.setObject(downloadedImage, forKey: NSString(string: url.absoluteString))
                    self.downloadTask(for: url)?.progress = .finished
                    self.delegates.invoke(invocation: { $0.downloadCompleted(for: url) })
                } else {
                    self.downloadTask(for: url)?.progress = .finishedWithError
                }
            }
        }
        self.downloadCache.setObject(DownloadTask(value: downloadTask, key: url, progress: .started), forKey: NSString(string: url.absoluteString))
        downloadTask.resume()
    }
    
    ///Returns an image from cache if it is present.
    ///If the task for this URL is in progress, it returns nil.
    ///Else if the task is not present, it starts the task and returns nil.
    ///If task was completed with error, next time when requested, it will restart the task and returns nil.
    open func imageFor(url: URL) -> UIImage? {
        if let imageFromCache = self.cachedImage(for: url) {
            if let task = self.downloadTask(for: url) {
                if task.progress == .finishedWithError {
                    self.downloadImage(with: url)
                    return nil
                }
                return imageFromCache.image
            }
        }
        else if self.downloadTask(for: url) == nil {
            self.downloadImage(with: url)
        }
        else if let task = self.downloadTask(for: url) {
            if task.progress == .finishedWithError {
                self.downloadImage(with: url)
                return nil
            }
        }
        return nil
    }
    
    ///Returns the progress for specified task.
    open func taskProgressFor(url: URL) -> DownloadProgress {
        return self.downloadTask(for: url)?.progress ?? .notstarted
    }
}

///Generic class to have multiple delegates
open class MulticastDelegate <T> {
    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    open func add(delegate: T) {
        delegates.add(delegate as AnyObject)
    }

    open func remove(delegate: T) {
        for oneDelegate in delegates.allObjects.reversed() {
            if oneDelegate === delegate as AnyObject {
                delegates.remove(oneDelegate)
            }
        }
    }

    open func invoke(invocation: (T) -> ()) {
        for delegate in delegates.allObjects.reversed() {
            invocation(delegate as! T)
        }
    }
}
