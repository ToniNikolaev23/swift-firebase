//
//  Query+EXT.swift
//  SwiftulFirebaseBootcamp
//
//  Created by Toni Stoyanov on 13.01.25.
//

import Foundation
import FirebaseFirestore
import Combine

extension Query {
//    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
//        let snapshot = try await self.getDocuments()
//
//        return try snapshot.documents.map { document in
//            try document.data(as: T.self)
//        }
//    }
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentsWithSnapshot(as: type).products
        
       
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (products: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
        
        return (products, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else {return self}
        
        return self .start(afterDocument: lastDocument)
    }
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], any Error>, ListenerRegistration) where T : Decodable {
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let products: [T] = documents.compactMap { documentSnapshot in
                return try? documentSnapshot.data(as: T.self)
            }
            publisher.send(products)
            
        }
        
        return (publisher.eraseToAnyPublisher(), listener)
    }
}
