import Foundation

final class DocumentDownloadManager {

    static let shared = DocumentDownloadManager()
    private init() {}

    // MARK: - Local file path
    func localFileURL(from remoteURL: String , name : String) -> URL? {
        let fileName = buildFileName(name: name, remoteURL: remoteURL)

        let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return documents.appendingPathComponent(fileName)
    }
    func buildFileName(name: String, remoteURL: String) -> String {
        let ext = URL(string: remoteURL)?.pathExtension ?? ""
        return name.hasSuffix(".\(ext)") ? name : "\(name).\(ext)"
    }


    // MARK: - Check if already downloaded
    func isFileDownloaded(remoteURL: String, name : String) -> Bool {
        guard let localURL = localFileURL(from: remoteURL, name : name) else { return false }
        return FileManager.default.fileExists(atPath: localURL.path)
    }

    // MARK: - Download & Save Automatically
    func downloadAndSave(
        name : String,
        remoteURL: String,
        completion: @escaping (URL?) -> Void
    ) {
        guard let url = URL(string: remoteURL),
              let localURL = localFileURL(from: remoteURL, name: name) else {
            completion(nil)
            return
        }

        // Already downloaded → return local file
        if FileManager.default.fileExists(atPath: localURL.path) {
            completion(localURL)
            return
        }

        URLSession.shared.downloadTask(with: url) { tempURL, _, error in
            guard let tempURL, error == nil else {
                completion(nil)
                return
            }

            do {
                try FileManager.default.moveItem(at: tempURL, to: localURL)
                completion(localURL)
            } catch {
                print(" File save error:", error)
                completion(nil)
            }
        }.resume()
    }

    // MARK: - Get all downloaded files
    func getAllDownloadedFiles() -> [URL] {
        let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return (try? FileManager.default.contentsOfDirectory(
            at: documents,
            includingPropertiesForKeys: [.creationDateKey],
            options: [.skipsHiddenFiles]
        )) ?? []
    }
}
/*
import Foundation

final class DocumentDownloadManager {

    static let shared = DocumentDownloadManager()
    private init() {}

    // MARK: - Local file path
    func localFileURL(from remoteURL: String) -> URL? {
        guard let fileName = URL(string: remoteURL)?.lastPathComponent else {
            return nil
        }

        let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return documents.appendingPathComponent(fileName)
    }

    // MARK: - Check if already downloaded
    func isFileDownloaded(remoteURL: String) -> Bool {
        guard let localURL = localFileURL(from: remoteURL) else { return false }
        return FileManager.default.fileExists(atPath: localURL.path)
    }

    // MARK: - Download & Save Automatically
    func downloadAndSave(
        remoteURL: String,
        completion: @escaping (URL?) -> Void
    ) {
        guard let url = URL(string: remoteURL),
              let localURL = localFileURL(from: remoteURL) else {
            completion(nil)
            return
        }

        // Already downloaded → return local file
        if FileManager.default.fileExists(atPath: localURL.path) {
            completion(localURL)
            return
        }

        URLSession.shared.downloadTask(with: url) { tempURL, _, error in
            guard let tempURL, error == nil else {
                completion(nil)
                return
            }

            do {
                try FileManager.default.moveItem(at: tempURL, to: localURL)
                completion(localURL)
            } catch {
                print(" File save error:", error)
                completion(nil)
            }
        }.resume()
    }

    // MARK: - Get all downloaded files
    func getAllDownloadedFiles() -> [URL] {
        let documents = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        return (try? FileManager.default.contentsOfDirectory(
            at: documents,
            includingPropertiesForKeys: [.creationDateKey],
            options: [.skipsHiddenFiles]
        )) ?? []
    }
}
*/
