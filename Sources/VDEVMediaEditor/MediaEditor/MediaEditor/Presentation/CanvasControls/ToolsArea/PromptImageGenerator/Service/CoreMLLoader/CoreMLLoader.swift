//
//  CoreMLLoader.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import Foundation
import Combine
import Path
import ZIPFoundation
import StableDiffusion
import CoreML

@available(iOS 16.2, *)
final class CoreMLLoader {
    private(set) var mlSate: CurrentValueSubject<LoaderState, Never> = .init(.notStarted)
    private var downloadURL: URL {
        AIConfig.shared.mlVariant.url
    }
    private var rootPath: DynamicPath { Path.caches }
    private var fileFolderPath: Path { rootPath/AIConfig.shared.mlRootFolderName }
    private var fileZipPath: Path { fileFolderPath/fileNameZip }
    private var filePath: Path { fileFolderPath/fileName }
    
    private var fileNameZip: String {
        AIConfig.shared.mlVariant.zipName
    }
    
    private var fileName: String {
        AIConfig.shared.mlVariant.pathName
    }
    
    private var downloadSubscriber: Cancellable?
    private(set) var downloader: Downloader? = nil
    private let canGenerateImageByPrompt: Bool
    
    init(canGenerateImageByPrompt: Bool) {
        self.canGenerateImageByPrompt = canGenerateImageByPrompt
        self.startCheck()
    }
    
    func load() {
        loadExecute()
    }
    
    func cancelLoad() {
        downloader?.cancel()
    }
    
    @discardableResult
    private func startCheck() -> Bool {
        guard self.canGenerateImageByPrompt else {
            mlSate.send(.notAvailable)
            try? fileFolderPath.delete()
            return false
        }
        guard let result = checkForExist() else {
            mlSate.send(.notStarted)
            return false
        }
        
        switch result {
        case .coreML:
            self.onReady()
            return true
        case .zip:
            mlSate.send(.notStarted)
            return false
        }
    }
    
    private func checkForExist() -> CheckFile? {
        if !rootPath.exists {
            return nil
        }
        if !fileFolderPath.exists {
            return nil
        }
        var result: CheckFile? = nil
        if fileZipPath.exists {
            result = .zip
        }
        if filePath.exists {
            try? fileZipPath.delete()
            result = .coreML
        }
        return result
    }
    
    enum LoaderState {
        case ready(URL)
        case downloading(Double)
        case notStarted
        case failed(Error)
        case notAvailable
        case uncompressing
    }
    
    enum CheckFile {
        case zip
        case coreML
    }
}

// MARK: - Donwloading
@available(iOS 16.2, *)
fileprivate extension CoreMLLoader {
    func onReady() {
        self.mlSate.send(.ready(filePath.url))
    }
    
    func loadExecute() {
        guard !startCheck() else { return }
        
        let checkResult = checkForExist()
        
        mlSate.send(.downloading(0))
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return}
            do {
                if let checkResult = checkResult {
                    switch checkResult {
                    case .coreML:
                        self.onReady()
                    case .zip:
                        try self.unzip(downloadedPath: fileZipPath, destinationPath: fileFolderPath)
                        self.onReady()
                    }
                } else {
                    try self.fileFolderPath.delete()
                    try self.fileFolderPath.mkdir(.p)
                    try self.download(url: self.downloadURL,
                                      destination: self.fileZipPath.url)
                    try self.unzip(downloadedPath: fileZipPath, destinationPath: fileFolderPath)
                    self.onReady()
                }
                
            } catch {
                if let error = error as? URLError {
                    switch error.code {
                    case .cancelled:
                        self.startCheck()
                        return
                    default: break
                    }
                }
                self.mlSate.send(.failed(error))
            }
        }
    }
    
    private func download(url: URL, destination: URL) throws {
        let downloader = Downloader(from: url, to: destination)
        self.downloader = downloader
        downloadSubscriber = downloader.downloadState.sink { state in
            if case .downloading(let progress) = state {
                print("===========>", progress)
                self.mlSate.send(.downloading(progress))
            }
        }
        try downloader.waitUntilDone()
    }
    
    private func unzip(downloadedPath: Path, destinationPath: Path) throws {
        self.mlSate.send(.uncompressing)
        do {
            try FileManager().unzipItem(at: downloadedPath.url, to: destinationPath.url)
        } catch {
            // Cleanup if error occurs while unzipping
            try destinationPath.delete()
            throw error
        }
        try downloadedPath.delete()
    }
}
