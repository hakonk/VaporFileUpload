import Vapor
import Foundation
import Multipart

let drop = Droplet()

drop.get { req in
    return JSON([:])
}

drop.post("testPost") { req in
    guard let formData = req.formData, let file = formData["file"] else { throw Abort.badRequest }
    
    let filename = file.filename ?? UUID().uuidString
    let unsafeBufferPointer = UnsafeBufferPointer(start: file.part.body, count: file.part.body.count)
    let url = URL(fileURLWithPath: "\(filename)")
    try Data(unsafeBufferPointer).write(to: url)
    
    print("writing file to \(url.absoluteString)")
    return JSON(["test":"test"])
}

drop.resource("posts", PostController())

drop.run()
