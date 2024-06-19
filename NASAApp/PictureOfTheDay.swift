//
//  PictureOfTheDay.swift
//  NASAApp
//
//  Created by Erick Daniel Padilla on 19/06/24.
//

import Foundation
import SwiftData

@Model
final class PictureOfTheDay {
    @Attribute(.unique) let date: String
    let title: String
    let copyright: String?
    let explanation: String
    let mediaType: MediaType
    let url: String
    let hdurl: String?
    
    enum MediaType: String, Codable {
        case image, video
    }
    
    init(date: String, title: String, copyright: String?, explanation: String, mediaType: MediaType, url: String, hdurl: String?) {
        self.date = date
        self.title = title
        self.copyright = copyright
        self.explanation = explanation
        self.mediaType = mediaType
        self.url = url
        self.hdurl = hdurl
    }
    
    var dateComponents: DateComponents {
        let numbers = date.split(separator: "-").map({ Int($0)! })
        return DateComponents(year: numbers[0], month: numbers[1], day: numbers[2])
    }
}

extension PictureOfTheDay: Codable {
    enum CodingKeys: String, CodingKey {
        case copyright = "copyright"
        case date = "date"
        case explanation = "explanation"
        case hdurl = "hdurl"
        case mediaType = "media_type"
        case title = "title"
        case url = "url"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(title, forKey: .title)
        try container.encode(copyright, forKey: .copyright)
        try container.encode(explanation, forKey: .explanation)
        try container.encode(mediaType.rawValue, forKey: .mediaType)
        try container.encode(url, forKey: .url)
        try container.encode(hdurl, forKey: .hdurl)
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let date = try container.decode(String.self, forKey: .date)
        let title = try container.decode(String.self, forKey: .title)
        let copyright = try? container.decode(String.self, forKey: .copyright)
        let explanation = try container.decode(String.self, forKey: .explanation)
        let mediaTypeRawValue = try container.decode(String.self, forKey: .mediaType)
        guard let mediaType = MediaType(rawValue: mediaTypeRawValue) else {
            throw DecodingError.dataCorruptedError(forKey: .mediaType, in: container, debugDescription: "Invalid media type")
        }
        let url = try container.decode(String.self, forKey: .url)
        let hdurl = try? container.decode(String.self, forKey: .hdurl)
        
        self.init(date: date, title: title, copyright: copyright, explanation: explanation, mediaType: mediaType, url: url, hdurl: hdurl)
    }
}

let mockPicture = PictureOfTheDay(
    date: "2024-06-19",
    title: "NGC 6188: Dragons of Ara",
    copyright: "\nCarlos Taylor\n",
    explanation: "Do dragons fight on the altar of the sky?  Although it might appear that way, these dragons are illusions made of thin gas and dust. The emission nebula NGC 6188, home to the glowing clouds, is found about 4,000 light years away near the edge of a large molecular cloud, unseen at visible wavelengths, in the southern constellation Ara (the Altar). Massive, young stars of the embedded Ara OB1 association were formed in that region only a few million years ago, sculpting the dark shapes and powering the nebular glow with stellar winds and intense ultraviolet radiation. The recent star formation itself was likely triggered by winds and supernova explosions from previous generations of massive stars, that swept up and compressed the molecular gas. This impressively detailed image spans over 2 degrees (four full Moons), corresponding to over 150 light years at the estimated distance of NGC 6188.",
    mediaType: .image,
    url: "https://apod.nasa.gov/apod/image/2406/AraDragons_Taylor_960.jpg",
    hdurl: "https://apod.nasa.gov/apod/image/2406/AraDragons_Taylor_960.jpg"
)
