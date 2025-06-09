//
//  TrainingImagesController.swift
//  GYm-Couples-APi
//
//  Created by Daniel Pinilla on 2/8/25.
//


//
//  File.swift
//  
//
//  Created by Daniel Pinilla on 5/31/24.
//
import Fluent
import Vapor

struct TrainingImagesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let images = routes.grouped("images")
        images.get(use: getAllImages)
        images.post(use: uploadImage)
        images.put(use: update)
        images.delete(":imageID", use: delete)
        images.get("imageName", use: getImageByFilename)
    }
    @Sendable
    func getAllImages(req: Request) async throws -> [ImageModel] {
           try await ImageModel.query(on: req.db).all()
       }
    @Sendable
    func getImageByFilename(req: Request) throws -> EventLoopFuture<Response> {
        let filename =  try req.query.get(String.self, at: "name")
        
   

        // Find image in database by filename
        return ImageModel.query(on: req.db)
                    .filter(\.$filename == filename)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { imageModel in
                        let response = Response(status: .ok)
                        response.headers.contentType = .jpeg // Adjust content type based on your file type
                        response.body = .init(data: imageModel.imageData)
                        return req.eventLoop.makeSucceededFuture(response)
                    }
    }
   
    
    struct ImageUploadData: Content {
        var file: File
    }
    @Sendable
    func uploadImage(_ req: Request) throws -> EventLoopFuture<ImageModel> {
        let data = try req.content.decode(ImageUploadData.self)
        let filename = data.file.filename
        let imageData = Data(buffer: data.file.data) // Convert ByteBuffer to Data
        
        let imageModel = ImageModel(filename: filename, imageData: imageData)
        
        return imageModel.save(on: req.db).map { imageModel }
    }
    @Sendable
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let updatedImage = try req.content.decode(TrainingImages.self)
        return TrainingImages.find(updatedImage.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { image in
                image.imagePath = updatedImage.imagePath
                return image.save(on: req.db).transform(to: .ok)
            }
    }
    @Sendable
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let directory = DirectoryConfiguration.detect().workingDirectory
        return TrainingImages.find(req.parameters.get("imageID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { image in
                let filePath = directory + image.imagePath
                do {
                    try FileManager.default.removeItem(atPath: filePath)
                } catch {
                    return req.eventLoop.makeFailedFuture(error)
                }
                return image.delete(on: req.db).transform(to: .ok)
            }
    }
    @Sendable
    func fetch(req: Request) throws -> EventLoopFuture<Response> {
        let directory = DirectoryConfiguration.detect().workingDirectory
        let imageName =  try req.query.get(String.self, at: "name")
        let filePath = directory + "Public/Uploads/" + imageName

        return req.eventLoop.future(req.fileio.streamFile(at: filePath))
    }
}
